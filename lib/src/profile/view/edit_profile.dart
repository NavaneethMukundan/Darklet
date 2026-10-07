import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/auth/widget/auth_widgets.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/validators.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/widgets/app_text_field.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: context.read<AuthController>().user?.name ?? '',
  );
  late final _phone = TextEditingController(
    text: context.read<AuthController>().user?.phone ?? '',
  );
  String? _avatarPath;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (file != null) setState(() => _avatarPath = file.path);
    } catch (_) {
      if (mounted) showSnack(context, context.l10n.somethingWentWrong);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l = context.l10n;
    final nav = Navigator.of(context);
    final err = await context.read<AuthController>().updateProfile(
      name: _name.text,
      phone: _phone.text,
      avatarPath: _avatarPath,
    );
    if (!mounted) return;
    if (err == null) {
      showSnack(context, l.profileUpdated);
      nav.pop();
    } else {
      showSnack(context, authErrorText(l, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = context.watch<AuthController>();
    return KeyboardDismiss(
      child: Scaffold(
        appBar: AppTopBar(title: l.editProfile),
        body: ContentWidth(
          maxWidth: 560,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Center(
                  child: Stack(
                    children: [
                      UserAvatar(
                        source: _avatarPath ?? auth.user?.avatarUrl,
                        size: 110,
                      ),
                      PositionedDirectional(
                        end: 0,
                        bottom: 0,
                        child: Material(
                          color: color.primaryColor,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: _pickAvatar,
                            child: Padding(
                              padding: const EdgeInsets.all(9),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 20,
                                color: color.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                kHeight30,
                AppTextField(
                  label: l.fullName,
                  controller: _name,
                  prefixIcon: Icons.person_outline_rounded,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: Validators.required(l),
                ),
                kHeight15,
                AppTextField(
                  label: l.email,
                  controller: TextEditingController(
                    text: auth.user?.email ?? '',
                  ),
                  prefixIcon: Icons.mail_outline_rounded,
                  readOnly: true,
                ),
                kHeight15,
                AppTextField(
                  label: l.phone,
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  textInputAction: TextInputAction.done,
                ),
                kHeight30,
                PrimaryButton(
                  label: l.saveChanges,
                  onPressed: _save,
                  loading: auth.busy,
                ),
                kHeight15,
                SecondaryButton(
                  label: l.changePassword,
                  icon: Icons.lock_outline_rounded,
                  onPressed: () => context.push(AppRoutes.changePassword),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
