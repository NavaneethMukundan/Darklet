import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/category/view/category.dart';
import 'package:darklet/src/home/view/home.dart';
import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/profile/view/profile.dart';
import 'package:darklet/src/utils/constants/asset_store.dart';
import 'package:darklet/src/wishlist/view/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const WishlistScreen(),
    const CategoryScreen(),
  ];

  final List<String> images = [
    AssetStore().homeIcon,
    AssetStore().profileIcon,
    AssetStore().wishlistIcon,
    AssetStore().categoryIcon,
  ];

  BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(builder: (context, controller, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: Stack(
          children: [
            _screens[controller.selectedIndex],
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white, // ✅ keep it white!
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 0),
                        color: color.kBlackSecondary,
                        blurRadius: 1,
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(images.length, (index) {
                      final isSelected = controller.selectedIndex == index;
                      return GestureDetector(
                        onTap: () => controller.updateIndex(index),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: isSelected
                              ? const BoxDecoration(
                                  color: Colors.lightGreenAccent,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          child: Image.asset(images[index]),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
