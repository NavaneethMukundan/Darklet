import 'package:darklet/src/cards/controller/card_controller.dart';
import 'package:darklet/src/models/saved_card.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/validators.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_text_field.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/card_formatters.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Adds a card to the wallet and pops with the new [SavedCard].
/// The CVC is only validated, never stored.
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _holder = TextEditingController();
  final _expiry = TextEditingController();
  final _cvc = TextEditingController();

  @override
  void dispose() {
    for (final c in [_number, _holder, _expiry, _cvc]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final card = context.read<CardController>().add(
      number: _number.text,
      holder: _holder.text,
      expiry: _expiry.text,
    );
    Navigator.of(context).pop(card);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return KeyboardDismiss(
      child: Scaffold(
        appBar: AppTopBar(title: l.addCard),
        body: ContentWidth(
          maxWidth: 560,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                CardPreview(
                  number: _number.text,
                  holder: _holder.text,
                  expiry: _expiry.text,
                ),
                kHeight25,
                AppTextField(
                  label: l.cardNumber,
                  hint: '4242 4242 4242 4242',
                  controller: _number,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.credit_card_rounded,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(19),
                    CardNumberFormatter(),
                  ],
                  onChanged: (_) => setState(() {}),
                  validator: Validators.cardNumber(l),
                ),
                kHeight15,
                AppTextField(
                  label: l.cardHolder,
                  controller: _holder,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.characters,
                  prefixIcon: Icons.person_outline_rounded,
                  onChanged: (_) => setState(() {}),
                  validator: Validators.required(l),
                ),
                kHeight15,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: l.expiry,
                        hint: 'MM/YY',
                        controller: _expiry,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          ExpiryFormatter(),
                        ],
                        onChanged: (_) => setState(() {}),
                        validator: Validators.expiry(l),
                      ),
                    ),
                    kWidth15,
                    Expanded(
                      child: AppTextField(
                        label: 'CVC',
                        hint: '123',
                        controller: _cvc,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: Validators.cvc(l),
                      ),
                    ),
                  ],
                ),
                kHeight10,
                Text(
                  l.cardSaveNote,
                  textAlign: TextAlign.center,
                  style: ts(12, w: FontWeight.w400, c: color.kGrey),
                ),
                kHeight25,
                PrimaryButton(label: l.saveCard, onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
