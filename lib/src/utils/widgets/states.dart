import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:flutter/material.dart';

/// Friendly empty-list placeholder with an optional action.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.secondaryColor,
              ),
              child: Icon(icon, size: 52, color: color.primaryDarkColor),
            ),
            kHeight25,
            Text(
              title,
              textAlign: TextAlign.center,
              style: ts(18, w: FontWeight.w600),
            ),
            if (message != null) ...[
              kHeight10,
              Text(
                message!,
                textAlign: TextAlign.center,
                style: ts(14, w: FontWeight.w400, c: color.kGrey),
              ),
            ],
            if (actionLabel != null) ...[
              kHeight25,
              SizedBox(
                width: 220,
                child: PrimaryButton(label: actionLabel!, onPressed: onAction),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error placeholder with a retry button.
class ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;
  const ErrorState({super.key, required this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return EmptyState(
      icon: Icons.wifi_off_rounded,
      title: l.somethingWentWrong,
      message: message ?? l.tryAgainMessage,
      actionLabel: l.retry,
      onAction: onRetry,
    );
  }
}
