import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/auth/widget/auth_widgets.dart';
import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/validators.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_text_field.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l = context.l10n;
    final err = await context.read<AuthController>().signIn(
      _email.text,
      _password.text,
    );
    if (!mounted) return;
    err == null
        ? context.pushAndClear(AppRoutes.home)
        : showSnack(context, authErrorText(l, err));
  }

  Future<void> _google() async {
    final l = context.l10n;
    final err = await context.read<AuthController>().signInWithGoogle();
    if (!mounted) return;
    err == null
        ? context.pushAndClear(AppRoutes.home)
        : showSnack(context, authErrorText(l, err));
  }

  void _fillDemo() {
    _email.text = AppConfig.demoEmail;
    _password.text = AppConfig.demoPassword;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final busy = context.select<AuthController, bool>((a) => a.busy);
    return AuthScaffold(
      title: l.welcomeBack,
      subtitle: l.enterDetails,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              label: l.email,
              hint: l.emailHint,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.mail_outline_rounded,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email(l),
            ),
            kHeight15,
            PasswordField(
              label: l.password,
              controller: _password,
              validator: Validators.required(l),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.forgotPassword),
                child: Text(
                  l.forgotPassword,
                  style: ts(14, w: FontWeight.w400, c: color.kGrey),
                ),
              ),
            ),
            PrimaryButton(label: l.signIn, onPressed: _submit, loading: busy),
            kHeight15,
            Row(
              children: [
                Expanded(child: Divider(color: color.kLightGrey)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(l.or, style: ts(13, c: color.kGrey)),
                ),
                Expanded(child: Divider(color: color.kLightGrey)),
              ],
            ),
            kHeight15,
            SecondaryButton(
              label: l.continueWithGoogle,
              icon: Icons.g_mobiledata_rounded,
              onPressed: busy ? null : _google,
            ),
            kHeight10,
            TextButton(
              onPressed: () => context.push(AppRoutes.register),
              child: Text(
                l.noAccount,
                style: ts(15, w: FontWeight.w500, c: color.primaryDarkColor),
              ),
            ),
            TextButton(
              onPressed: busy
                  ? null
                  : () async {
                      await context.read<AuthController>().continueAsGuest();
                      if (context.mounted) context.pushAndClear(AppRoutes.home);
                    },
              child: Text(
                l.continueAsGuest,
                style: ts(14, w: FontWeight.w500, c: color.kGrey),
              ),
            ),
            if (AppConfig.useMock)
              InkWell(
                onTap: _fillDemo,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l.demoHint(AppConfig.demoEmail, AppConfig.demoPassword),
                    textAlign: TextAlign.center,
                    style: ts(12, w: FontWeight.w400),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
