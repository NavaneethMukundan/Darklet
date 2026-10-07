import 'package:darklet/src/home/controller/navigation_controller.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  void _home(BuildContext context) {
    context.read<NavigationController>().reset();
    context.pushAndClear(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _home(context);
      },
      child: AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ContentWidth(
              maxWidth: 480,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.elasticOut,
                            builder: (_, v, child) =>
                                Transform.scale(scale: v, child: child),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color.primaryColor,
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                size: 78,
                                color: color.onPrimary,
                              ),
                            ),
                          ),
                          kHeight30,
                          Text(
                            l.orderPlacedTitle,
                            textAlign: TextAlign.center,
                            style: ts(26, w: FontWeight.w700),
                          ),
                          kHeight10,
                          Text(
                            l.orderPlacedMessage,
                            textAlign: TextAlign.center,
                            style: ts(14, w: FontWeight.w400, c: color.kGrey),
                          ),
                          kHeight20,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: color.kWhite,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: color.kLightGrey.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              l.orderNumber(orderId),
                              style: ts(15, w: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PrimaryButton(
                      label: l.trackOrder,
                      icon: Icons.local_shipping_outlined,
                      onPressed: () {
                        context.read<NavigationController>().reset();
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.orderDetails, arguments: orderId);
                      },
                    ),
                    kHeight10,
                    SecondaryButton(
                      label: l.continueShopping,
                      onPressed: () => _home(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
