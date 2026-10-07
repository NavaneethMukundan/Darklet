import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/auth/widget/auth_widgets.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l = context.l10n;
    final err = await context.read<AuthController>().register(
      _name.text,
      _email.text,
      _password.text,
    );
    if (!mounted) return;
    err == null
        ? context.pushAndClear(AppRoutes.home)
        : showSnack(context, authErrorText(l, err));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final busy = context.select<AuthController, bool>((a) => a.busy);
    return AuthScaffold(
      title: l.createAccount,
      subtitle: l.registerSubtitle,
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              label: l.fullName,
              controller: _name,
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              validator: Validators.required(l),
            ),
            kHeight15,
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
              textInputAction: TextInputAction.next,
              validator: Validators.password(l),
            ),
            kHeight15,
            PasswordField(
              label: l.confirmPassword,
              controller: _confirm,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              validator: (v) =>
                  v != _password.text ? l.passwordsDontMatch : null,
            ),
            kHeight25,
            PrimaryButton(label: l.signUp, onPressed: _submit, loading: busy),
            kHeight10,
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(
                l.haveAccount,
                style: ts(15, w: FontWeight.w500, c: color.primaryDarkColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
