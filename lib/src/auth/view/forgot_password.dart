import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/auth/widget/auth_widgets.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/validators.dart';
import 'package:darklet/src/utils/widgets/app_text_field.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l = context.l10n;
    final nav = Navigator.of(context);
    final err = await context.read<AuthController>().sendPasswordReset(
      _email.text,
    );
    if (!mounted) return;
    if (err == null) {
      showSnack(context, l.resetLinkSent);
      nav.maybePop();
    } else {
      showSnack(context, authErrorText(l, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final busy = context.select<AuthController, bool>((a) => a.busy);
    return AuthScaffold(
      title: l.forgotPasswordTitle,
      subtitle: l.forgotPasswordSubtitle,
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              label: l.email,
              hint: l.emailHint,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.mail_outline_rounded,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              validator: Validators.email(l),
            ),
            kHeight25,
            PrimaryButton(
              label: l.sendResetLink,
              onPressed: _submit,
              loading: busy,
            ),
            kHeight15,
          ],
        ),
      ),
    );
  }
}
