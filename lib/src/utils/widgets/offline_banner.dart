import 'package:darklet/src/services/connectivity_controller.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Slides a bar over the top of the app when the device goes offline.
class OfflineBanner extends StatelessWidget {
  final Widget child;
  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ConnectivityController>();
    final visible = !c.online || c.justReconnected;
    final l = context.l10n;
    return Stack(
      children: [
        child,
        PositionedDirectional(
          top: 0,
          start: 0,
          end: 0,
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: visible ? Offset.zero : const Offset(0, -1),
              child: Material(
                color: c.online ? color.success : const Color(0xFF3A3A3A),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          c.online
                              ? Icons.wifi_rounded
                              : Icons.wifi_off_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          c.online ? l.backOnline : l.offlineBanner,
                          style: ts(12, w: FontWeight.w500, c: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
