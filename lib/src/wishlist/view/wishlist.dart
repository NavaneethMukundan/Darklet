import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/cart/controller/wishlist_controller.dart';
import 'package:darklet/src/home/controller/navigation_controller.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_network_image.dart';
import 'package:darklet/src/utils/widgets/bottom_navigation.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/product_card.dart';
import 'package:darklet/src/utils/widgets/skeleton.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final wish = context.watch<WishlistController>();
    final items = wish.items
        .where((p) => p.name.toLowerCase().contains(_filter.toLowerCase()))
        .toList();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentWidth(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  children: [
                    TwoToneTitle(l.wishlistTitleA, l.wishlistTitleB, size: 26),
                    kHeight15,
                    TextField(
                      onChanged: (v) => setState(() => _filter = v),
                      style: ts(14, w: FontWeight.w400),
                      decoration: InputDecoration(
                        hintText: l.searchWishlist,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: color.kBlackSecondary,
                        ),
                      ),
                    ),
                    kHeight15,
                  ],
                ),
              ),
              Expanded(
                child: wish.loading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ListSkeleton(count: 4, itemHeight: 123),
                      )
                    : wish.items.isEmpty
                    ? EmptyState(
                        icon: Icons.favorite_border_rounded,
                        title: l.wishlistEmptyTitle,
                        message: l.wishlistEmptyMessage,
                        actionLabel: l.startShopping,
                        onAction: () =>
                            context.read<NavigationController>().select(0),
                      )
                    : items.isEmpty
                    ? EmptyState(
                        icon: Icons.search_off_rounded,
                        title: l.noResults,
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          BottomNavigation.barClearance,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => kHeight15,
                        itemBuilder: (_, i) => _WishlistRow(product: items[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WishlistRow extends StatelessWidget {
  final Product product;
  const _WishlistRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Material(
      color: color.kWhite,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(
          AppRoutes.productDetails,
          args: ProductDetailsArgs(product, 'wish-${product.id}'),
        ),
        child: Container(
          height: 123,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.kLightGrey.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: 'wish-${product.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AppNetworkImage(product.image),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 4,
                      end: 4,
                      child: WishlistHeart(product: product, size: 28),
                    ),
                  ],
                ),
              ),
              kWidth10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ts(15, w: FontWeight.w600),
                    ),
                    kHeight5,
                    Text(
                      product.brand,
                      style: ts(12, w: FontWeight.w400, c: color.kGrey),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            money(product.price),
                            style: ts(16, w: FontWeight.w600),
                          ),
                        ),
                        Semantics(
                          button: true,
                          label: l.addToCart,
                          child: GestureDetector(
                            onTap: product.inStock
                                ? () {
                                    context.read<CartController>().add(product);
                                    showSnack(
                                      context,
                                      l.addedToCart,
                                      actionLabel: l.viewCart,
                                      onAction: () =>
                                          context.push(AppRoutes.cart),
                                    );
                                  }
                                : null,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color.kBlack,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 20,
                                color: color.background,
                              ),
                            ),
                          ),
                        ),
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
