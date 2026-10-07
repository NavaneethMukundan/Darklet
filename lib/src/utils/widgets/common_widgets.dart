import 'dart:io';

import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Soft brand gradient behind main screens (flat colour in dark mode).
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: ColorManager.isDark
            ? LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  color.secondaryColor.withValues(alpha: 0.5),
                  color.background,
                  color.background,
                ],
              )
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0XFFD6F3A2),
                  Color(0XFFF2FDE0),
                  Color(0XFFFEFFFB),
                  Colors.white,
                ],
              ),
      ),
      child: child,
    );
  }
}

/// Centres content and caps its width on tablets / large screens.
class ContentWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ContentWidth({
    super.key,
    required this.child,
    this.maxWidth = Responsive.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

/// Two-tone screen title, e.g. "Wish" + "list".
class TwoToneTitle extends StatelessWidget {
  final String first;
  final String second;
  final double size;
  const TwoToneTitle(this.first, this.second, {super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: first,
            style: ts(size, w: FontWeight.w700, c: color.kGrey),
          ),
          TextSpan(
            text: second,
            style: ts(size, w: FontWeight.w700, c: color.primaryDarkColor),
          ),
        ],
      ),
    );
  }
}

/// Standard app bar: back button, two-tone title and optional actions.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? accent;
  final List<Widget> actions;
  final bool showBack;
  const AppTopBar({
    super.key,
    required this.title,
    this.accent,
    this.actions = const [],
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(
          children: [
            if (showBack) ...[const AppBackButton(), kWidth15],
            Expanded(
              child: FittedBox(
                alignment: AlignmentDirectional.centerStart,
                fit: BoxFit.scaleDown,
                child: accent == null
                    ? Text(title, style: ts(22, w: FontWeight.w700))
                    : TwoToneTitle(accent!, title),
              ),
            ),
            ...actions.expand((a) => [kWidth10, a]),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const SectionHeader(this.title, {super.key, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ts(20, w: FontWeight.w600, c: color.kBlackSecondary),
          ),
        ),
        if (actionLabel != null)
          InkWell(
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Text(
                actionLabel!,
                style: ts(14, w: FontWeight.w400, c: color.primaryDarkColor),
              ),
            ),
          ),
      ],
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  const RatingStars(this.rating, {super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final icon = rating >= i + 1
            ? Icons.star_rounded
            : rating >= i + 0.5
            ? Icons.star_half_rounded
            : Icons.star_outline_rounded;
        return Icon(icon, size: size, color: color.star);
      }),
    );
  }
}

/// `- 2 +` quantity control.
class QuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int max;
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.max = CartController.maxQuantity,
  });

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon, VoidCallback? onTap) => InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap == null
              ? color.kLightGrey.withValues(alpha: 0.15)
              : color.primaryColor,
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? color.kGrey : color.onPrimary,
        ),
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn(Icons.remove_rounded, () => onChanged(value - 1)),
        SizedBox(
          width: 36,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
            child: Text(
              '$value',
              key: ValueKey(value),
              textAlign: TextAlign.center,
              style: ts(16, w: FontWeight.w600),
            ),
          ),
        ),
        btn(
          Icons.add_rounded,
          value >= max ? null : () => onChanged(value + 1),
        ),
      ],
    );
  }
}

/// Cart icon with an item-count badge.
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartController, int>((c) => c.itemCount);
    return SquareIconButton(
      icon: Icons.shopping_bag_outlined,
      onTap: () => context.push(AppRoutes.cart),
      badge: count == 0 ? null : CountBadge(count),
    );
  }
}

class CountBadge extends StatelessWidget {
  final int count;
  const CountBadge(this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color.primaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.background, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: ts(11, w: FontWeight.w700, c: color.onPrimary),
      ),
    );
  }
}

/// Circular avatar: network/local image if available, generic icon otherwise.
class UserAvatar extends StatelessWidget {
  final String? source;
  final double size;
  const UserAvatar({super.key, this.source, this.size = 55});

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (source != null && source!.isNotEmpty) {
      image = source!.startsWith('http')
          ? NetworkImage(source!)
          : (kIsWeb ? null : FileImage(File(source!)));
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.secondaryColor,
        image: image == null
            ? null
            : DecorationImage(image: image, fit: BoxFit.cover),
      ),
      child: image == null
          ? Icon(
              Icons.person_rounded,
              size: size * 0.55,
              color: color.primaryDarkColor,
            )
          : null,
    );
  }
}

void showSnack(
  BuildContext context,
  String message, {
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      action: actionLabel == null
          ? null
          : SnackBarAction(
              label: actionLabel,
              textColor: color.primaryColor,
              onPressed: onAction ?? () {},
            ),
    ),
  );
}

/// Wraps a screen and dismisses the keyboard on outside tap.
class KeyboardDismiss extends StatelessWidget {
  final Widget child;
  const KeyboardDismiss({super.key, required this.child});

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    child: child,
  );
}

/// Returns `true` when a real account is signed in. Guests get a sheet asking
/// them to sign in or register (their cart and wishlist are kept).
Future<bool> ensureSignedIn(BuildContext context) async {
  if (context.read<AuthController>().isLoggedIn) return true;
  final l = context.l10n;
  final go = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 44,
              color: color.primaryDarkColor,
            ),
            kHeight15,
            Text(l.signInRequiredTitle, style: ts(20, w: FontWeight.w700)),
            kHeight10,
            Text(
              l.signInRequiredMessage,
              textAlign: TextAlign.center,
              style: ts(14, w: FontWeight.w400, c: color.kGrey),
            ),
            kHeight25,
            PrimaryButton(
              label: l.signIn,
              onPressed: () => Navigator.pop(ctx, true),
            ),
            kHeight10,
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.notNow),
            ),
          ],
        ),
      ),
    ),
  );
  if (go == true && context.mounted) {
    context.pushAndClear(AppRoutes.login);
  }
  return false;
}
