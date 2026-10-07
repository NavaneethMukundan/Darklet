import 'package:darklet/src/services/push_service.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Wraps a screen and, once, asks permission for order notifications
/// (a short explanation first, then the system prompt). Does nothing in mock
/// mode or after the user has already been asked.
class PushPermissionPrompt extends StatefulWidget {
  final Widget child;
  const PushPermissionPrompt({super.key, required this.child});

  @override
  State<PushPermissionPrompt> createState() => _PushPermissionPromptState();
}

class _PushPermissionPromptState extends State<PushPermissionPrompt> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ask());
  }

  Future<void> _ask() async {
    PushService? push;
    try {
      push = context.read<PushService?>();
    } catch (_) {
      return; // provider not present (tests)
    }
    if (push == null || !push.shouldAsk || !mounted) return;
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.notifications_active_outlined, size: 36),
        title: Text(l.pushAskTitle),
        content: Text(l.pushAskMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.notNow),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.enableNotifications),
          ),
        ],
      ),
    );
    if (ok == true) {
      await push.requestPermission();
    } else {
      await push.markAsked();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
