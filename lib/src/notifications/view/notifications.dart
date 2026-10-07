import 'package:darklet/src/models/app_notification.dart';
import 'package:darklet/src/notifications/controller/notification_controller.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/skeleton.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.watch<NotificationController>();
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppTopBar(
          title: l.notifications,
          actions: [
            if (c.unreadCount > 0)
              TextButton(onPressed: c.markAllRead, child: Text(l.markAllRead)),
          ],
        ),
        body: ContentWidth(
          maxWidth: 700,
          child: c.loading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: ListSkeleton(count: 5, itemHeight: 84),
                )
              : c.items.isEmpty
              ? EmptyState(
                  icon: Icons.notifications_off_outlined,
                  title: l.notificationsEmptyTitle,
                  message: l.notificationsEmptyMessage,
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: c.items.length,
                  separatorBuilder: (_, _) => kHeight10,
                  itemBuilder: (_, i) => _Tile(item: c.items[i]),
                ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final AppNotification item;
  const _Tile({required this.item});

  IconData get _icon => switch (item.type) {
    'order' => Icons.local_shipping_outlined,
    'promo' => Icons.local_offer_outlined,
    _ => Icons.info_outline_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.kWhite,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.read<NotificationController>().markRead(item.id),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.read
                  ? color.kLightGrey.withValues(alpha: 0.4)
                  : color.primaryDarkColor.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.secondaryColor,
                ),
                child: Icon(_icon, color: color.primaryDarkColor, size: 22),
              ),
              kWidth15,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: ts(
                              14,
                              w: item.read ? FontWeight.w500 : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!item.read)
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.primaryDarkColor,
                            ),
                          ),
                      ],
                    ),
                    kHeight5,
                    Text(
                      item.body,
                      style: ts(
                        13,
                        w: FontWeight.w400,
                        c: color.kBlackSecondary,
                      ),
                    ),
                    kHeight5,
                    Text(
                      dateTime(item.createdAt),
                      style: ts(11, w: FontWeight.w400, c: color.kGrey),
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
