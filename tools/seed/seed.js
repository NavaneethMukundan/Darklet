// Uploads the demo catalogue (assets/mock/*.json) to Firestore.
//
//   cd tools/seed && npm install firebase-admin
//   export GOOGLE_APPLICATION_CREDENTIALS=/path/to/serviceAccountKey.json   # never commit this file
//   node seed.js
//
// Product images in the mock data are remote URLs. To host them yourself,
// upload the files to Firebase Storage (products/...) and replace the URLs.
const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");

admin.initializeApp();
const db = admin.firestore();
const read = (f) => JSON.parse(fs.readFileSync(path.join(__dirname, "../../assets/mock", f), "utf8"));

async function put(collection, items) {
  const batch = db.batch();
  for (const { id, ...data } of items) batch.set(db.collection(collection).doc(id), data);
  await batch.commit();
  console.log(`${collection}: ${items.length} documents`);
}

(async () => {
  await put("categories", read("categories.json"));
  await put("products", read("products.json"));
  await put("reviews", read("reviews.json"));
  const coupons = read("coupons.json").map((c) => ({ ...c, id: c.code }));
  await put("coupons", coupons);
})().catch((e) => { console.error(e); process.exit(1); });
