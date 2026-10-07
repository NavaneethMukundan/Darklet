import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/auth/widget/auth_widgets.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/validators.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l = context.l10n;
    final nav = Navigator.of(context);
    final err = await context.read<AuthController>().changePassword(
      _current.text,
      _new.text,
    );
    if (!mounted) return;
    if (err == null) {
      showSnack(context, l.passwordChanged);
      nav.pop();
    } else {
      showSnack(context, authErrorText(l, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final busy = context.select<AuthController, bool>((a) => a.busy);
    return KeyboardDismiss(
      child: Scaffold(
        appBar: AppTopBar(title: l.changePassword),
        body: ContentWidth(
          maxWidth: 560,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                PasswordField(
                  label: l.currentPassword,
                  controller: _current,
                  textInputAction: TextInputAction.next,
                  validator: Validators.required(l),
                ),
                kHeight15,
                PasswordField(
                  label: l.newPassword,
                  controller: _new,
                  textInputAction: TextInputAction.next,
                  validator: Validators.password(l),
                ),
                kHeight15,
                PasswordField(
                  label: l.confirmPassword,
                  controller: _confirm,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(),
                  validator: (v) =>
                      v != _new.text ? l.passwordsDontMatch : null,
                ),
                kHeight30,
                PrimaryButton(
                  label: l.updatePassword,
                  onPressed: _save,
                  loading: busy,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
