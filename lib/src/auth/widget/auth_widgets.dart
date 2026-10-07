import 'dart:math' as math;

import 'package:darklet/l10n/app_localizations.dart';
import 'package:darklet/src/repositories/auth_repository.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_text_field.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

String authErrorText(AppLocalizations l, AuthError e) => switch (e) {
  AuthError.invalidCredentials => l.errInvalidCredentials,
  AuthError.emailInUse => l.errEmailInUse,
  AuthError.weakPassword => l.errWeakPassword,
  AuthError.userNotFound => l.errUserNotFound,
  AuthError.requiresRecentLogin => l.errRequiresRecentLogin,
  AuthError.cancelled => l.errCancelled,
  AuthError.network => l.errNetwork,
  AuthError.unknown => l.somethingWentWrong,
};

/// Original generative background: layered sine "contour" lines.
class ContourPainter extends CustomPainter {
  final Color lineColor;
  const ContourPainter(this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    const rows = 16;
    for (var r = 0; r < rows; r++) {
      final path = Path();
      final baseY = size.height * r / rows;
      for (var x = 0.0; x <= size.width; x += 6) {
        final y =
            baseY +
            math.sin(x / 38 + r * 0.7) * 16 +
            math.sin(x / 90 - r * 0.4) * 22;
        x == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(ContourPainter old) => old.lineColor != lineColor;
}

/// Brand-coloured page with a patterned header and a rounded sheet.
class AuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool showBack;
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.primaryColor,
      resizeToAvoidBottomInset: true,
      body: KeyboardDismiss(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: ContourPainter(Colors.black.withValues(alpha: 0.18)),
              ),
            ),
            if (showBack)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: BackButton(color: color.onPrimary),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 560,
                  maxHeight: MediaQuery.sizeOf(context).height * 0.86,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: color.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(44),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: ts(30, w: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: ts(15, w: FontWeight.w400, c: color.kGrey),
                          ),
                          const SizedBox(height: 28),
                          child,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Password field with a local show/hide toggle.
class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscure,
      prefixIcon: Icons.lock_outline_rounded,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      autofillHints: const [AutofillHints.password],
      suffix: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: color.kGrey,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
