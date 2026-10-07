import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/home/controller/home_controller.dart';
import 'package:darklet/src/home/controller/navigation_controller.dart';
import 'package:darklet/src/home/widget/flash_sale_timer.dart';
import 'package:darklet/src/home/widget/search_field_widget.dart';
import 'package:darklet/src/models/category.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/notifications/controller/notification_controller.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/category_helpers.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/load_status.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/bottom_navigation.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/product_card.dart';
import 'package:darklet/src/utils/widgets/skeleton.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final home = context.watch<HomeController>();
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            color: color.primaryDarkColor,
            onRefresh: () => home.load(force: true),
            child: ContentWidth(
              child: LayoutBuilder(
                builder: (context, c) {
                  final cols = Responsive.gridColumns(c.maxWidth);
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      BottomNavigation.barClearance,
                    ),
                    children: [
                      const _Header(),
                      kHeight20,
                      SearchFieldWidget(
                        content: l.searchProducts,
                        onTap: () => context.push(AppRoutes.search),
                      ),
                      kHeight20,
                      const _PromoBanner(),
                      if (home.status == LoadStatus.error)
                        SizedBox(
                          height: 320,
                          child: ErrorState(
                            onRetry: () => home.load(force: true),
                          ),
                        )
                      else if (home.status != LoadStatus.loaded)
                        ..._skeleton(cols)
                      else ...[
                        kHeight25,
                        SectionHeader(
                          l.categories,
                          actionLabel: l.viewAll,
                          onAction: () =>
                              context.read<NavigationController>().select(1),
                        ),
                        kHeight15,
                        _CategoryRow(categories: home.categories),
                        kHeight25,
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                l.flashSales,
                                style: ts(
                                  20,
                                  w: FontWeight.w600,
                                  c: color.kBlackSecondary,
                                ),
                              ),
                            ),
                            kWidth10,
                            const FlashSaleTimer(),
                          ],
                        ),
                        kHeight15,
                        _ProductGrid(
                          products: home.flashSale,
                          columns: cols,
                          heroPrefix: 'flash',
                        ),
                        if (home.recentlyViewed.isNotEmpty) ...[
                          kHeight25,
                          SectionHeader(l.recentlyViewed),
                          kHeight15,
                          _RecentRow(products: home.recentlyViewed),
                        ],
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _skeleton(int cols) => [
    kHeight25,
    const Skeleton(height: 90, radius: 20),
    kHeight25,
    ProductGridSkeleton(columns: cols, count: cols * 2),
  ];
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = context.watch<AuthController>().user;
    final unread = context.select<NotificationController, int>(
      (n) => n.unreadCount,
    );
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.read<NavigationController>().select(3),
          child: UserAvatar(source: user?.avatarUrl, size: 52),
        ),
        kWidth10,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.hello(user?.name.split(' ').first ?? l.guest),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ts(17, w: FontWeight.w600),
              ),
              Text.rich(
                TextSpan(
                  text: '${l.welcomeTo} ',
                  style: ts(13, w: FontWeight.w400, c: color.kGrey),
                  children: [
                    TextSpan(
                      text: 'Darklet',
                      style: ts(
                        13,
                        w: FontWeight.w600,
                        c: color.primaryDarkColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        kWidth10,
        SquareIconButton(
          icon: Icons.notifications_none_rounded,
          tooltip: l.notifications,
          onTap: () => context.push(AppRoutes.notifications),
          badge: unread == 0 ? null : CountBadge(unread),
        ),
        kWidth10,
        const CartIconButton(),
      ],
    );
  }
}

/// Promo banner drawn in code (gradient + icon) - no photo to license.
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [color.primaryDarkColor, const Color(0xFF2F5A00)],
        ),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -10,
            bottom: -20,
            child: Icon(
              Icons.devices_rounded,
              size: 130,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l.promoTitle,
                style: ts(22, w: FontWeight.w700, c: Colors.white),
              ),
              kHeight5,
              Text(
                l.promoSubtitle,
                style: ts(
                  13,
                  w: FontWeight.w400,
                  c: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final List<Category> categories;
  const _CategoryRow({required this.categories});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) => kWidth20,
        itemBuilder: (_, i) {
          final c = categories[i];
          final name = categoryLabel(l, c.id, c.name);
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push(
              AppRoutes.products,
              args: ProductListArgs(categoryId: c.id, title: name),
            ),
            child: SizedBox(
              width: 80,
              child: Column(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [color.secondaryColor, color.kWhiteSecondary],
                      ),
                    ),
                    child: Icon(
                      categoryIcon(c.id),
                      size: 32,
                      color: color.primaryDarkColor,
                    ),
                  ),
                  kHeight5,
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ts(13, c: color.kBlackSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<Product> products;
  final int columns;
  final String heroPrefix;
  const _ProductGrid({
    required this.products,
    required this.columns,
    required this.heroPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, i) =>
          ProductCard(product: products[i], heroPrefix: heroPrefix),
    );
  }
}

class _RecentRow extends StatelessWidget {
  final List<Product> products;
  const _RecentRow({required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (_, _) => kWidth15,
        itemBuilder: (_, i) => SizedBox(
          width: 160,
          child: ProductCard(product: products[i], heroPrefix: 'recent'),
        ),
      ),
    );
  }
}
