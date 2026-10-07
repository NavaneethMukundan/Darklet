import 'package:darklet/src/address/controller/address_controller.dart';
import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/validators.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_text_field.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Add (when [address] is null) or edit an address.
class AddressFormScreen extends StatefulWidget {
  final Address? address;
  const AddressFormScreen({super.key, this.address});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _label = TextEditingController(text: widget.address?.label ?? '');
  late final _name = TextEditingController(
    text:
        widget.address?.fullName ??
        context.read<AuthController>().user?.name ??
        '',
  );
  late final _phone = TextEditingController(
    text:
        widget.address?.phone ??
        context.read<AuthController>().user?.phone ??
        '',
  );
  late final _line1 = TextEditingController(text: widget.address?.line1 ?? '');
  late final _city = TextEditingController(text: widget.address?.city ?? '');
  late final _state = TextEditingController(text: widget.address?.state ?? '');
  late final _zip = TextEditingController(text: widget.address?.zip ?? '');
  late final _country = TextEditingController(
    text: widget.address?.country ?? '',
  );
  late bool _default = widget.address?.isDefault ?? false;

  @override
  void dispose() {
    for (final c in [
      _label,
      _name,
      _phone,
      _line1,
      _city,
      _state,
      _zip,
      _country,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final a = Address(
      id: widget.address?.id ?? 'a${DateTime.now().millisecondsSinceEpoch}',
      label: _label.text.trim(),
      fullName: _name.text.trim(),
      phone: _phone.text.trim(),
      line1: _line1.text.trim(),
      city: _city.text.trim(),
      state: _state.text.trim(),
      zip: _zip.text.trim(),
      country: _country.text.trim(),
      isDefault: _default,
    );
    context.read<AddressController>().save(a);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final req = Validators.required(l);
    return KeyboardDismiss(
      child: Scaffold(
        appBar: AppTopBar(
          title: widget.address == null ? l.addAddress : l.editAddress,
        ),
        body: ContentWidth(
          maxWidth: 600,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                AppTextField(
                  label: l.addressLabel,
                  hint: l.addressLabelHint,
                  controller: _label,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.label_outline_rounded,
                  validator: req,
                ),
                kHeight15,
                AppTextField(
                  label: l.fullName,
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: req,
                ),
                kHeight15,
                AppTextField(
                  label: l.phone,
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.phone_outlined,
                  validator: req,
                ),
                kHeight15,
                AppTextField(
                  label: l.streetAddress,
                  controller: _line1,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  prefixIcon: Icons.home_outlined,
                  validator: req,
                ),
                kHeight15,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: l.city,
                        controller: _city,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        validator: req,
                      ),
                    ),
                    kWidth15,
                    Expanded(
                      child: AppTextField(
                        label: l.stateRegion,
                        controller: _state,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        validator: req,
                      ),
                    ),
                  ],
                ),
                kHeight15,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: l.zipCode,
                        controller: _zip,
                        textInputAction: TextInputAction.next,
                        validator: req,
                      ),
                    ),
                    kWidth15,
                    Expanded(
                      child: AppTextField(
                        label: l.country,
                        controller: _country,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.words,
                        validator: req,
                      ),
                    ),
                  ],
                ),
                kHeight10,
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.setAsDefault, style: ts(15)),
                  value: _default,
                  onChanged: (v) => setState(() => _default = v),
                ),
                kHeight15,
                PrimaryButton(label: l.saveAddress, onPressed: _save),
                kHeight10,
                Center(
                  child: Text(
                    l.addressPrivacy,
                    textAlign: TextAlign.center,
                    style: ts(11, w: FontWeight.w400, c: color.kGrey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
