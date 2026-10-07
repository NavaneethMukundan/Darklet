import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/home/controller/navigation_controller.dart';
import 'package:darklet/src/notifications/controller/notification_controller.dart';
import 'package:darklet/src/settings/controller/theme_controller.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/bottom_navigation.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.logOut, style: ts(18, w: FontWeight.w600)),
        content: Text(l.logOutConfirm, style: ts(14, w: FontWeight.w400)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.logOut, style: TextStyle(color: color.error)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final nav = context.read<NavigationController>();
    await context.read<AuthController>().signOut();
    nav.reset();
    if (context.mounted) context.pushAndClear(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = context.watch<AuthController>();
    final user = auth.user;
    final guest = user == null;
    final unread = context.select<NotificationController, int>(
      (n) => n.unreadCount,
    );
    final theme = context.watch<ThemeController>();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentWidth(
          maxWidth: 640,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              16,
              24,
              16,
              BottomNavigation.barClearance,
            ),
            children: [
              Row(
                children: [
                  UserAvatar(source: user?.avatarUrl, size: 92),
                  kWidth15,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? l.guest,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: ts(24, w: FontWeight.w700),
                        ),
                        Text(
                          user?.email ?? l.guestProfileMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ts(14, w: FontWeight.w400, c: color.kGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              kHeight30,
              if (guest) ...[
                PrimaryButton(
                  label: l.signIn,
                  onPressed: () => context.pushAndClear(AppRoutes.login),
                ),
                kHeight10,
                SecondaryButton(
                  label: l.createAccount,
                  onPressed: () => context.push(AppRoutes.register),
                ),
              ] else ...[
                _Label(l.account),
                _Tile(
                  Icons.person_outline_rounded,
                  const Color(0XFFE7F7CB),
                  l.editProfile,
                  () => context.push(AppRoutes.editProfile),
                ),
                _Tile(
                  Icons.receipt_long_outlined,
                  const Color(0XFFFFE3B3),
                  l.myOrders,
                  () => context.push(AppRoutes.orders),
                ),
                _Tile(
                  Icons.location_on_outlined,
                  const Color(0XFFBFE3F5),
                  l.myAddresses,
                  () => context.push(AppRoutes.addresses),
                ),
                _Tile(
                  Icons.credit_card_rounded,
                  const Color(0XFFD7CCF5),
                  l.paymentMethods,
                  () => context.push(AppRoutes.cards),
                ),
              ],
              kHeight15,
              _Label(l.settings),
              _Tile(
                Icons.notifications_none_rounded,
                const Color(0XFFE5BEF9),
                l.notifications,
                () => context.push(AppRoutes.notifications),
                trailing: unread == 0 ? null : CountBadge(unread),
              ),
              _Tile(
                Icons.dark_mode_outlined,
                const Color(0XFF88ABB7),
                l.darkMode,
                () => theme.setMode(
                  theme.isDark ? ThemeMode.light : ThemeMode.dark,
                ),
                trailing: Switch(
                  value: theme.isDark,
                  onChanged: (v) =>
                      theme.setMode(v ? ThemeMode.dark : ThemeMode.light),
                ),
              ),
              _Tile(
                Icons.settings_outlined,
                const Color(0XFFD9D9D9),
                l.settings,
                () => context.push(AppRoutes.settings),
              ),
              if (!guest)
                _Tile(
                  Icons.logout_rounded,
                  const Color(0XFFFFC9C9),
                  l.logOut,
                  () => _logout(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(text, style: ts(18, w: FontWeight.w600)),
  );
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  const _Tile(this.icon, this.tint, this.title, this.onTap, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(shape: BoxShape.circle, color: tint),
              child: Icon(icon, color: const Color(0xff1E1E1E), size: 24),
            ),
            kWidth15,
            Expanded(
              child: Text(title, style: ts(16, c: color.kBlackSecondary)),
            ),
            if (trailing != null) ...[trailing!, kWidth10],
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              color: color.kGrey,
            ),
          ],
        ),
      ),
    );
  }
}
