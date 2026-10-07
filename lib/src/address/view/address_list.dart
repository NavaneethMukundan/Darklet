import 'package:darklet/src/address/controller/address_controller.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Address book. With [selectMode] a tap returns the chosen address.
class AddressListScreen extends StatelessWidget {
  final bool selectMode;
  const AddressListScreen({super.key, this.selectMode = false});

  Future<void> _delete(BuildContext context, Address a) async {
    final l = context.l10n;
    final controller = context.read<AddressController>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteAddress),
        content: Text(l.deleteAddressConfirm),
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
    if (ok == true) controller.delete(a.id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.watch<AddressController>();
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppTopBar(title: selectMode ? l.selectAddress : l.myAddresses),
        body: ContentWidth(
          maxWidth: 700,
          child: Column(
            children: [
              Expanded(
                child: c.items.isEmpty
                    ? EmptyState(
                        icon: Icons.location_off_outlined,
                        title: l.addressesEmptyTitle,
                        message: l.addressesEmptyMessage,
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: c.items.length,
                        separatorBuilder: (_, _) => kHeight10,
                        itemBuilder: (_, i) {
                          final a = c.items[i];
                          return _AddressTile(
                            address: a,
                            onTap: selectMode
                                ? () => Navigator.pop(context, a)
                                : null,
                            onEdit: () =>
                                context.push(AppRoutes.addressForm, args: a),
                            onDelete: () => _delete(context, a),
                            onDefault: a.isDefault
                                ? null
                                : () => c.setDefault(a.id),
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: PrimaryButton(
                    label: l.addAddress,
                    icon: Icons.add_location_alt_outlined,
                    onPressed: () => context.push(AppRoutes.addressForm),
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

class _AddressTile extends StatelessWidget {
  final Address address;
  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onDefault;
  const _AddressTile({
    required this.address,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onDefault,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Material(
      color: color.kWhite,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: address.isDefault
                  ? color.primaryDarkColor
                  : color.kLightGrey.withValues(alpha: 0.4),
              width: address.isDefault ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: color.primaryDarkColor,
                  ),
                  kWidth10,
                  Expanded(
                    child: Text(
                      address.label,
                      style: ts(16, w: FontWeight.w600),
                    ),
                  ),
                  if (address.isDefault)
                    Container(
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
                    ),
                ],
              ),
              kHeight10,
              Text(address.fullName, style: ts(14, w: FontWeight.w500)),
              Text(
                address.oneLine,
                style: ts(13, w: FontWeight.w400, c: color.kGrey),
              ),
              if (address.phone.isNotEmpty)
                Text(
                  address.phone,
                  textDirection: TextDirection.ltr,
                  style: ts(13, w: FontWeight.w400, c: color.kGrey),
                ),
              kHeight5,
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(l.edit),
                  ),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: color.error,
                    ),
                    label: Text(l.delete, style: TextStyle(color: color.error)),
                  ),
                  const Spacer(),
                  if (onDefault != null)
                    TextButton(
                      onPressed: onDefault,
                      child: Text(l.setAsDefault),
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
