import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/cart/controller/wishlist_controller.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Animated heart that toggles a product in the wishlist.
class WishlistHeart extends StatelessWidget {
  final Product product;
  final double size;
  const WishlistHeart({super.key, required this.product, this.size = 34});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fav = context.select<WishlistController, bool>(
      (w) => w.contains(product.id),
    );
    return Semantics(
      button: true,
      label: fav ? l.removeFromWishlist : l.addToWishlist,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          context.read<WishlistController>().toggle(product);
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.kWhite,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 3,
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.elasticOut,
            transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
            child: Icon(
              fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(fav),
              size: size * 0.58,
              color: fav ? color.error : color.kBlack,
            ),
          ),
        ),
      ),
    );
  }
}

/// Small "+" button that turns into a check mark after adding to the cart.
class AddToCartMiniButton extends StatefulWidget {
  final Product product;

  /// Hero tag used when the product needs options and details are opened.
  final String heroTag;
  const AddToCartMiniButton({
    super.key,
    required this.product,
    required this.heroTag,
  });

  @override
  State<AddToCartMiniButton> createState() => _AddToCartMiniButtonState();
}

class _AddToCartMiniButtonState extends State<AddToCartMiniButton> {
  bool _added = false;

  Future<void> _add() async {
    if (widget.product.options.isNotEmpty) {
      // Needs a choice (storage, colour...) - let the shopper pick on the details page.
      context.push(
        AppRoutes.productDetails,
        args: ProductDetailsArgs(widget.product, widget.heroTag),
      );
      return;
    }
    HapticFeedback.lightImpact();
    context.read<CartController>().add(widget.product);
    setState(() => _added = true);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (mounted) setState(() => _added = false);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.product.inStock;
    return Semantics(
      button: true,
      label: context.l10n.addToCart,
      child: GestureDetector(
        onTap: enabled ? _add : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: !enabled
                ? color.kLightGrey.withValues(alpha: 0.3)
                : _added
                ? color.primaryDarkColor
                : color.kBlack,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
            child: Icon(
              _added
                  ? Icons.check_rounded
                  : widget.product.options.isNotEmpty
                  ? Icons.tune_rounded
                  : Icons.add_shopping_cart_rounded,
              key: ValueKey(_added),
              size: 18,
              color: _added ? Colors.white : color.background,
            ),
          ),
        ),
      ),
    );
  }
}

/// Product tile used in grids and carousels. The image is a [Hero].
class ProductCard extends StatelessWidget {
  final Product product;

  /// Unique per list on screen (e.g. `flash`, `grid`) so Hero tags never clash.
  final String heroPrefix;
  const ProductCard({
    super.key,
    required this.product,
    required this.heroPrefix,
  });

  String get heroTag => '$heroPrefix-${product.id}';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Material(
      color: color.kWhite,
      elevation: 0,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => context.push(
          AppRoutes.productDetails,
          args: ProductDetailsArgs(product, heroTag),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color.kLightGrey.withValues(alpha: 0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: heroTag,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(22),
                          ),
                          child: AppNetworkImage(product.image),
                        ),
                      ),
                    ),
                    if (product.discountPercent > 0)
                      PositionedDirectional(
                        top: 8,
                        start: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: color.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${product.discountPercent}%',
                            style: ts(
                              11,
                              w: FontWeight.w700,
                              c: color.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    PositionedDirectional(
                      top: 8,
                      end: 8,
                      child: WishlistHeart(product: product),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ts(13, w: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: product.inStock
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      money(product.price),
                                      style: ts(16, w: FontWeight.w600),
                                    ),
                                    if (product.oldPrice != null)
                                      Text(
                                        money(product.oldPrice!),
                                        style:
                                            ts(
                                              11,
                                              w: FontWeight.w400,
                                              c: color.kGrey,
                                            ).copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                      ),
                                  ],
                                )
                              : Text(
                                  l.outOfStock,
                                  style: ts(13, c: color.error),
                                ),
                        ),
                        AddToCartMiniButton(product: product, heroTag: heroTag),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
