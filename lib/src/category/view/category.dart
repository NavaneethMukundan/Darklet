import 'package:darklet/src/home/controller/home_controller.dart';
import 'package:darklet/src/home/widget/search_field_widget.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/category_helpers.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/load_status.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_network_image.dart';
import 'package:darklet/src/utils/widgets/bottom_navigation.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/skeleton.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final home = context.watch<HomeController>();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentWidth(
          child: RefreshIndicator(
            color: color.primaryDarkColor,
            onRefresh: () => home.load(force: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                BottomNavigation.barClearance,
              ),
              children: [
                Center(
                  child: TwoToneTitle(
                    l.categoryTitleA,
                    l.categoryTitleB,
                    size: 26,
                  ),
                ),
                kHeight15,
                Row(
                  children: [
                    Expanded(
                      child: SearchFieldWidget(
                        content: l.searchProducts,
                        onTap: () => context.push(AppRoutes.search),
                      ),
                    ),
                    kWidth10,
                    SquareIconButton(
                      icon: Icons.tune_rounded,
                      tooltip: l.filters,
                      onTap: () => context.push(AppRoutes.search),
                    ),
                  ],
                ),
                kHeight25,
                if (home.status == LoadStatus.error)
                  SizedBox(
                    height: 300,
                    child: ErrorState(onRetry: () => home.load(force: true)),
                  )
                else if (home.status != LoadStatus.loaded)
                  const ListSkeleton(count: 4, itemHeight: 123)
                else
                  for (final c in home.categories) ...[
                    _CategoryTile(
                      tint: Color(c.tint),
                      title: categoryLabel(l, c.id, c.name),
                      icon: categoryIcon(c.id),
                      image: c.image,
                      semantics: l.categorySection(
                        categoryLabel(l, c.id, c.name),
                      ),
                      onTap: () => context.push(
                        AppRoutes.products,
                        args: ProductListArgs(
                          categoryId: c.id,
                          title: categoryLabel(l, c.id, c.name),
                        ),
                      ),
                    ),
                    kHeight15,
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Color tint;
  final String title;
  final String semantics;
  final IconData icon;
  final String image;
  final VoidCallback onTap;
  const _CategoryTile({
    required this.tint,
    required this.title,
    required this.semantics,
    required this.icon,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semantics,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 123,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppNetworkImage(image),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.centerStart,
                      end: AlignmentDirectional.centerEnd,
                      colors: [tint, tint.withValues(alpha: 0.25)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.white, size: 30),
                      kWidth15,
                      Expanded(
                        child: Text(
                          title,
                          style: ts(20, w: FontWeight.w700, c: Colors.white),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      )._flipInRtl(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension _FlipIcon on Icon {
  Widget _flipInRtl(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl
      ? Transform.flip(flipX: true, child: this)
      : this;
}
