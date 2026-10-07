// Cloud Functions for Darklet. Deploy with: firebase deploy --only functions
//
// SECURITY MODEL
//  * The app never writes orders. It calls `placeOrder`, which re-reads prices
//    (including option price differences) and coupons from Firestore, computes
//    the totals itself and, for card payments, verifies with Stripe that the
//    PaymentIntent succeeded for exactly that amount.
//  * `cancelOrder` lets the owner cancel only while the order is placed/confirmed
//    (and refunds a card payment).
//  * Set the Stripe SECRET key with:  firebase functions:secrets:set STRIPE_SECRET_KEY
//    NEVER put it in the Flutter app or commit it.
const { onRequest, onCall, HttpsError } = require("firebase-functions/v2/https");
const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

const DELIVERY = {
  standard: { price: 4.99, freeOver: 1000 },
  express: { price: 12.99 },
  pickup: { price: 0 },
};
const MAX_QTY = 10;
const round2 = (n) => Math.round(n * 100) / 100;
const stripeClient = () => require("stripe")(process.env.STRIPE_SECRET_KEY);

// ---------------------------------------------------------------- payments
exports.createPaymentIntent = onRequest(
  { secrets: ["STRIPE_SECRET_KEY"], cors: true },
  async (req, res) => {
    try {
      const { amount, currency = "usd" } = req.body;
      if (!Number.isInteger(amount) || amount < 50) {
        return res.status(400).json({ error: "invalid amount" });
      }
      const intent = await stripeClient().paymentIntents.create({
        amount,
        currency,
        automatic_payment_methods: { enabled: true },
      });
      // placeOrder later checks this amount against the server-side total.
      res.json({ clientSecret: intent.client_secret });
    } catch (e) {
      console.error(e);
      res.status(500).json({ error: "payment_intent_failed" });
    }
  }
);

// ------------------------------------------------------------------ orders
async function priceItem(raw) {
  const qty = raw.quantity;
  if (!Number.isInteger(qty) || qty < 1 || qty > MAX_QTY) {
    throw new HttpsError("invalid-argument", "bad quantity");
  }
  const snap = await db.collection("products").doc(String(raw.productId)).get();
  if (!snap.exists) throw new HttpsError("not-found", "unknown product");
  const p = snap.data();
  if ((p.stock ?? 0) < qty) throw new HttpsError("failed-precondition", `out of stock: ${p.name}`);

  const labels = raw.variant ? String(raw.variant).split(" • ") : [];
  const options = p.options || [];
  if (labels.length !== options.length) throw new HttpsError("invalid-argument", "bad variant");
  let price = p.price;
  options.forEach((opt, i) => {
    const v = opt.values.find((x) => x.label === labels[i]);
    if (!v) throw new HttpsError("invalid-argument", "bad variant");
    price += v.priceDelta || 0;
  });
  return {
    productId: snap.id,
    name: p.name,
    image: (p.images || [])[0] || "",
    price: round2(price),
    quantity: qty,
    variant: raw.variant || "",
  };
}

async function applyCoupon(code, subtotal) {
  if (!code) return { discount: 0, freeShipping: false, code: null };
  const snap = await db.collection("coupons").doc(String(code).toUpperCase()).get();
  if (!snap.exists) throw new HttpsError("invalid-argument", "invalid coupon");
  const c = snap.data();
  if (subtotal < (c.minSubtotal || 0)) throw new HttpsError("invalid-argument", "coupon minimum not met");
  let discount = 0;
  if (c.type === "percent") discount = (subtotal * c.value) / 100;
  if (c.type === "amount") discount = c.value;
  return {
    discount: round2(Math.min(discount, subtotal)),
    freeShipping: c.type === "freeShipping",
    code: snap.id,
  };
}

exports.placeOrder = onCall({ secrets: ["STRIPE_SECRET_KEY"] }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "sign in first");
  const d = request.data || {};
  if (!Array.isArray(d.items) || d.items.length < 1 || d.items.length > 30) {
    throw new HttpsError("invalid-argument", "bad items");
  }
  const a = d.address || {};
  for (const k of ["fullName", "phone", "line1", "city", "state", "zip", "country"]) {
    if (typeof a[k] !== "string" || !a[k].trim()) throw new HttpsError("invalid-argument", `address.${k}`);
  }
  const delivery = DELIVERY[d.deliveryOptionId];
  if (!delivery) throw new HttpsError("invalid-argument", "bad delivery option");
  if (!["card", "cashOnDelivery"].includes(d.paymentMethod)) {
    throw new HttpsError("invalid-argument", "bad payment method");
  }

  const items = [];
  for (const raw of d.items) items.push(await priceItem(raw));
  const subtotal = round2(items.reduce((s, i) => s + i.price * i.quantity, 0));
  const coupon = await applyCoupon(d.couponCode, subtotal);
  let deliveryFee = delivery.price;
  if (coupon.freeShipping) deliveryFee = 0;
  if (delivery.freeOver && subtotal >= delivery.freeOver) deliveryFee = 0;
  const total = round2(subtotal - coupon.discount + deliveryFee);

  let paymentRef = null;
  if (d.paymentMethod === "card") {
    paymentRef = String(d.paymentRef || "");
    if (!paymentRef) throw new HttpsError("failed-precondition", "payment required");
    if (paymentRef.startsWith("pi_")) {
      const stripe = stripeClient();
      const intent = await stripe.paymentIntents.retrieve(paymentRef);
      if (intent.status !== "succeeded") throw new HttpsError("failed-precondition", "payment not completed");
      if (intent.amount !== Math.round(total * 100)) {
        await stripe.refunds.create({ payment_intent: paymentRef }); // amount tampering
        throw new HttpsError("failed-precondition", "payment amount mismatch (refunded)");
      }
      const used = await db.collection("orders").where("paymentRef", "==", paymentRef).limit(1).get();
      if (!used.empty) throw new HttpsError("already-exists", "payment already used");
    } else if (process.env.ALLOW_MOCK_PAYMENTS !== "true") {
      // Mock gateway references are only accepted in development projects.
      throw new HttpsError("failed-precondition", "invalid payment reference");
    }
  }

  const now = new Date().toISOString();
  const id = `DK-${Date.now() % 1000000}`;
  const order = {
    id,
    userId: uid,
    createdAt: now,
    items,
    subtotal,
    deliveryFee,
    discount: coupon.discount,
    couponCode: coupon.code,
    address: { id: a.id || "a", label: a.label || "", isDefault: false, ...a },
    deliveryOptionId: d.deliveryOptionId,
    paymentMethod: d.paymentMethod,
    paymentRef,
    status: "placed",
    events: [{ status: "placed", at: now }],
  };
  const batch = db.batch();
  batch.set(db.collection("orders").doc(id), order);
  for (const i of items) {
    batch.update(db.collection("products").doc(i.productId), {
      stock: admin.firestore.FieldValue.increment(-i.quantity),
    });
  }
  batch.delete(db.collection("carts").doc(uid));
  await batch.commit();
  return order;
});

exports.cancelOrder = onCall({ secrets: ["STRIPE_SECRET_KEY"] }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "sign in first");
  const ref = db.collection("orders").doc(String(request.data?.orderId));
  const snap = await ref.get();
  if (!snap.exists || snap.data().userId !== uid) throw new HttpsError("not-found", "order not found");
  const o = snap.data();
  if (!["placed", "confirmed"].includes(o.status)) {
    throw new HttpsError("failed-precondition", "order can no longer be cancelled");
  }
  if (o.paymentMethod === "card" && String(o.paymentRef || "").startsWith("pi_")) {
    await stripeClient().refunds.create({ payment_intent: o.paymentRef });
  }
  const now = new Date().toISOString();
  const events = [...o.events, { status: "cancelled", at: now }];
  const batch = db.batch();
  batch.update(ref, { status: "cancelled", events });
  for (const i of o.items) {
    batch.update(db.collection("products").doc(i.productId), {
      stock: admin.firestore.FieldValue.increment(i.quantity),
    });
  }
  await batch.commit();
  return { ...o, status: "cancelled", events };
});

// Push a notification whenever an order's status changes (e.g. set to "shipped"
// from your back office). Devices should subscribe to topic `user_<uid>`.
exports.onOrderStatusChange = onDocumentUpdated("orders/{orderId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (before.status === after.status) return;
  await admin.messaging().send({
    topic: `user_${after.userId}`,
    notification: { title: `Order ${after.id}`, body: `Status: ${after.status}` },
    data: { type: "order", orderId: after.id },
  });
});
