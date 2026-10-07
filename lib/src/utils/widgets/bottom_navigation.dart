import 'package:darklet/src/category/view/category.dart';
import 'package:darklet/src/home/controller/navigation_controller.dart';
import 'package:darklet/src/home/view/home.dart';
import 'package:darklet/src/profile/view/profile.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/wishlist/view/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Main shell: four tabs behind a floating pill navigation bar.
class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  static const _icons = [
    (Icons.home_outlined, Icons.home_rounded),
    (Icons.grid_view_outlined, Icons.grid_view_rounded),
    (Icons.favorite_border_rounded, Icons.favorite_rounded),
    (Icons.person_outline_rounded, Icons.person_rounded),
  ];

  /// Space screens should leave at the bottom so content clears the bar.
  static const double barClearance = 96;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final nav = context.watch<NavigationController>();
    final labels = [l.navHome, l.navCategories, l.navWishlist, l.navProfile];
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: nav.index,
            children: const [
              HomeScreen(),
              CategoryScreen(),
              WishlistScreen(),
              ProfileScreen(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    margin: const EdgeInsets.symmetric(horizontal: 36),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: color.kWhite,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: color.kLightGrey.withValues(alpha: 0.5),
                        width: 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_icons.length, (i) {
                        final selected = nav.index == i;
                        return Semantics(
                          button: true,
                          selected: selected,
                          label: labels[i],
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => nav.select(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: selected
                                    ? color.primaryColor
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                selected ? _icons[i].$2 : _icons[i].$1,
                                size: 24,
                                color: selected
                                    ? color.onPrimary
                                    : color.kBlack,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
