import 'package:darklet/src/models/saved_card.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Groups digits as `1234 5678 9012 3456`.
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue value,
  ) {
    final d = value.text.replaceAll(' ', '');
    final b = StringBuffer();
    for (var i = 0; i < d.length; i++) {
      if (i > 0 && i % 4 == 0) b.write(' ');
      b.write(d[i]);
    }
    final t = b.toString();
    return TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
  }
}

/// Turns `1230` into `12/30`.
class ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue value,
  ) {
    final d = value.text.replaceAll('/', '');
    final t = d.length > 2 ? '${d.substring(0, 2)}/${d.substring(2)}' : d;
    return TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
  }
}

String brandLabel(String brand) => switch (brand) {
  'visa' => 'VISA',
  'mastercard' => 'Mastercard',
  'amex' => 'Amex',
  _ => 'Card',
};

/// Decorative card. Pass [number] while typing, or [last4] for a saved card.
class CardPreview extends StatelessWidget {
  final String number;
  final String? last4;
  final String holder;
  final String expiry;
  const CardPreview({
    super.key,
    this.number = '',
    this.last4,
    required this.holder,
    required this.expiry,
  });

  factory CardPreview.saved(SavedCard c) =>
      CardPreview(last4: c.last4, holder: c.holder, expiry: c.expiry);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final String grouped;
    if (last4 != null) {
      grouped = '••••  ••••  ••••  $last4';
    } else {
      final digits = number.replaceAll(' ', '').padRight(16, '•');
      grouped = [
        for (var i = 0; i < 16; i += 4) digits.substring(i, i + 4),
      ].join('  ');
    }
    return AspectRatio(
      aspectRatio: 1.65,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2B2B2B), Color(0xFF0E0E0E)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.contactless_outlined,
                    color: color.primaryColor,
                    size: 30,
                  ),
                  const Spacer(),
                  Text(
                    last4 != null || number.isNotEmpty
                        ? brandLabel(
                            SavedCard.detectBrand(
                              number.isEmpty ? '0' : number,
                            ),
                          )
                        : 'Darklet',
                    style: ts(16, w: FontWeight.w900, c: color.primaryColor),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                grouped,
                style: ts(
                  19,
                  w: FontWeight.w500,
                  c: Colors.white,
                ).copyWith(letterSpacing: 1.5),
              ),
              kHeight15,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      holder.isEmpty
                          ? l.cardHolder.toUpperCase()
                          : holder.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ts(12, w: FontWeight.w400, c: Colors.white70),
                    ),
                  ),
                  Text(
                    expiry.isEmpty ? 'MM/YY' : expiry,
                    style: ts(12, w: FontWeight.w400, c: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
