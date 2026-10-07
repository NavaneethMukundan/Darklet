import 'package:darklet/src/cards/controller/card_controller.dart';
import 'package:darklet/src/models/saved_card.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/card_formatters.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Wallet: list, add, delete and choose the default card.
class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  Future<void> _delete(BuildContext context, SavedCard c) async {
    final l = context.l10n;
    final cards = context.read<CardController>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteCard),
        content: Text(l.deleteCardConfirm(c.last4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete, style: TextStyle(color: color.error)),
          ),
        ],
      ),
    );
    if (ok == true) cards.remove(c.id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cards = context.watch<CardController>();
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppTopBar(title: l.paymentMethods),
        body: ContentWidth(
          maxWidth: 600,
          child: Column(
            children: [
              Expanded(
                child: cards.isEmpty
                    ? EmptyState(
                        icon: Icons.credit_card_off_outlined,
                        title: l.noCardsTitle,
                        message: l.cardsEmptyMessage,
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: cards.items.length,
                        separatorBuilder: (_, _) => kHeight20,
                        itemBuilder: (_, i) {
                          final c = cards.items[i];
                          return Column(
                            children: [
                              CardPreview.saved(c),
                              kHeight5,
                              Row(
                                children: [
                                  if (c.isDefault)
                                    Container(
                                      margin: const EdgeInsetsDirectional.only(
                                        start: 4,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.secondaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        l.defaultLabel,
                                        style: ts(
                                          11,
                                          w: FontWeight.w600,
                                          c: color.primaryDarkColor,
                                        ),
                                      ),
                                    )
                                  else
                                    TextButton(
                                      onPressed: () => cards.setDefault(c.id),
                                      child: Text(l.setAsDefault),
                                    ),
                                  const Spacer(),
                                  TextButton.icon(
                                    onPressed: () => _delete(context, c),
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                      color: color.error,
                                    ),
                                    label: Text(
                                      l.delete,
                                      style: TextStyle(color: color.error),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: PrimaryButton(
                    label: l.addCard,
                    icon: Icons.add_card_rounded,
                    onPressed: () => context.push(AppRoutes.addCard),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
