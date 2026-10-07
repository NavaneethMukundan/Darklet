import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/home/controller/home_controller.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_network_image.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductDetailsArgs args;
  const ProductDetailsScreen({super.key, required this.args});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _pages = PageController();
  int _page = 0;
  int _qty = 1;
  late List<int> _sel = product.defaultSelection;
  bool _added = false;

  Product get product => widget.args.product;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeController>().markViewed(product);
    });
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _addToCart() {
    HapticFeedback.mediumImpact();
    context.read<CartController>().add(
      product,
      quantity: _qty,
      selection: _sel,
    );
    setState(() => _added = true);
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _added = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = product;
    final images = p.images.isEmpty ? [''] : p.images;
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppTopBar(
          title: l.details,
          actions: [
            WishlistHeart(product: p, size: 46),
            const CartIconButton(),
          ],
        ),
        body: ContentWidth(
          child: LayoutBuilder(
            builder: (context, box) {
              final wide = box.maxWidth > 640;
              final gallery = _Gallery(
                images: images,
                controller: _pages,
                page: _page,
                heroTag: widget.args.heroTag,
                onPage: (i) => setState(() => _page = i),
              );
              final info = _Info(
                product: p,
                selection: _sel,
                onSelect: (i, v) => setState(() => _sel = [..._sel]..[i] = v),
              );
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      child: wide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: gallery),
                                kWidth20,
                                Expanded(child: info),
                              ],
                            )
                          : Column(children: [gallery, kHeight20, info]),
                    ),
                  ),
                  _BottomBar(
                    qty: _qty,
                    added: _added,
                    enabled: p.inStock,
                    total: p.priceFor(_sel) * _qty,
                    onQty: (v) => setState(
                      () => _qty = v.clamp(1, CartController.maxQuantity),
                    ),
                    onAdd: _addToCart,
                    onViewCart: () => context.push(AppRoutes.cart),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  final List<String> images;
  final PageController controller;
  final int page;
  final String heroTag;
  final ValueChanged<int> onPage;
  const _Gallery({
    required this.images,
    required this.controller,
    required this.page,
    required this.heroTag,
    required this.onPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: PageView.builder(
              controller: controller,
              itemCount: images.length,
              onPageChanged: onPage,
              itemBuilder: (_, i) {
                final img = AppNetworkImage(images[i]);
                return i == 0 ? Hero(tag: heroTag, child: img) : img;
              },
            ),
          ),
        ),
        if (images.length > 1) ...[
          kHeight10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == page ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: i == page ? color.primaryDarkColor : color.kLightGrey,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final Product product;
  final List<int> selection;
  final void Function(int option, int value) onSelect;
  const _Info({
    required this.product,
    required this.selection,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.brand.toUpperCase(),
          style: ts(12, w: FontWeight.w600, c: color.primaryDarkColor),
        ),
        kHeight5,
        Text(p.name, style: ts(24, w: FontWeight.w700)),
        kHeight10,
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.push(AppRoutes.reviews, args: p),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingStars(p.rating, size: 18),
                kWidth10,
                Text(
                  p.rating.toStringAsFixed(1),
                  style: ts(14, w: FontWeight.w600),
                ),
                kWidth5,
                Text(
                  '(${l.reviewsCount(p.reviewCount)})',
                  style: ts(13, w: FontWeight.w400, c: color.kGrey),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: color.kGrey,
                ).rtlFlip(context),
              ],
            ),
          ),
        ),
        kHeight15,
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              money(p.priceFor(selection)),
              style: ts(28, w: FontWeight.w700),
            ),
            if (p.oldPrice != null) ...[
              kWidth10,
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  money(p.oldPrice! + (p.priceFor(selection) - p.price)),
                  style: ts(
                    15,
                    w: FontWeight.w400,
                    c: color.kGrey,
                  ).copyWith(decoration: TextDecoration.lineThrough),
                ),
              ),
              kWidth10,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '-${p.discountPercent}%',
                  style: ts(12, w: FontWeight.w700, c: color.onPrimary),
                ),
              ),
            ],
          ],
        ),
        kHeight10,
        Row(
          children: [
            Icon(
              p.inStock ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 18,
              color: p.inStock ? color.success : color.error,
            ),
            kWidth5,
            Text(
              p.inStock
                  ? (p.stock <= 10 ? l.onlyLeft(p.stock) : l.inStock)
                  : l.outOfStock,
              style: ts(13, c: p.inStock ? color.success : color.error),
            ),
          ],
        ),
        for (final (i, option) in p.options.indexed) ...[
          kHeight20,
          _OptionPicker(
            option: option,
            selected: selection[i],
            onSelect: (v) => onSelect(i, v),
          ),
        ],
        kHeight20,
        Text(l.description, style: ts(17, w: FontWeight.w600)),
        kHeight10,
        Text(
          p.description,
          style: ts(14, w: FontWeight.w400, c: color.kBlackSecondary),
        ),
        if (p.specs.isNotEmpty) ...[
          kHeight20,
          Text(l.specifications, style: ts(17, w: FontWeight.w600)),
          kHeight10,
          Container(
            decoration: BoxDecoration(
              color: color.kWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.kLightGrey.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                for (final (i, e) in p.specs.entries.indexed) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      color: color.kLightGrey.withValues(alpha: 0.3),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.key,
                            style: ts(13, w: FontWeight.w400, c: color.kGrey),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            e.value,
                            textAlign: TextAlign.end,
                            style: ts(13, w: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        kHeight20,
        SecondaryButton(
          label: l.seeReviews(p.reviewCount),
          icon: Icons.rate_review_outlined,
          onPressed: () => context.push(AppRoutes.reviews, args: p),
        ),
      ],
    );
  }
}

extension on Icon {
  Widget rtlFlip(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl
      ? Transform.flip(flipX: true, child: this)
      : this;
}

class _BottomBar extends StatelessWidget {
  final int qty;
  final bool added;
  final bool enabled;
  final double total;
  final ValueChanged<int> onQty;
  final VoidCallback onAdd;
  final VoidCallback onViewCart;
  const _BottomBar({
    required this.qty,
    required this.added,
    required this.enabled,
    required this.total,
    required this.onQty,
    required this.onAdd,
    required this.onViewCart,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: color.kWhite,
        border: Border(
          top: BorderSide(color: color.kLightGrey.withValues(alpha: 0.4)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              QuantityStepper(value: qty, onChanged: onQty),
              kWidth15,
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: added
                      ? PrimaryButton(
                          key: const ValueKey('added'),
                          brand: true,
                          icon: Icons.check_rounded,
                          label: l.viewCart,
                          onPressed: onViewCart,
                        )
                      : PrimaryButton(
                          key: const ValueKey('add'),
                          icon: Icons.add_shopping_cart_rounded,
                          label: enabled
                              ? '${l.addToCart} • ${money(total)}'
                              : l.outOfStock,
                          onPressed: enabled ? onAdd : null,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chips (or colour swatches) to choose one value of a product option.
class _OptionPicker extends StatelessWidget {
  final ProductOption option;
  final int selected;
  final ValueChanged<int> onSelect;
  const _OptionPicker({
    required this.option,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final current = option.values[selected];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: '${option.name}: ',
            style: ts(15, w: FontWeight.w600),
            children: [
              TextSpan(
                text: current.label,
                style: ts(15, w: FontWeight.w400, c: color.kGrey),
              ),
            ],
          ),
        ),
        kHeight10,
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final (i, v) in option.values.indexed)
              Semantics(
                button: true,
                selected: i == selected,
                label: '${option.name} ${v.label}',
                child: GestureDetector(
                  onTap: () => onSelect(i),
                  child: v.swatch != null
                      ? AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: i == selected
                                  ? color.primaryDarkColor
                                  : color.kLightGrey,
                              width: i == selected ? 2.5 : 1,
                            ),
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(v.swatch!),
                              border: Border.all(
                                color: color.kLightGrey.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        )
                      : AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: i == selected
                                ? color.secondaryColor
                                : color.kWhite,
                            border: Border.all(
                              color: i == selected
                                  ? color.primaryDarkColor
                                  : color.kLightGrey,
                              width: i == selected ? 1.5 : 1,
                            ),
                          ),
                          child: Text(
                            v.label,
                            style: ts(
                              13,
                              w: i == selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
