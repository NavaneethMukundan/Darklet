import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/products/controller/product_list_controller.dart';
import 'package:darklet/src/products/widget/filter_sheet.dart';
import 'package:darklet/src/products/widget/product_list_view.dart';
import 'package:darklet/src/repositories/product_repository.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Products of one category, with filters, sorting and pagination.
class ProductScreen extends StatelessWidget {
  final ProductListArgs args;
  const ProductScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ChangeNotifierProvider(
      create: (ctx) => ProductListController(
        ctx.read<AppDependencies>().products,
        initial: ProductQuery(categoryId: args.categoryId),
      )..load(),
      child: Builder(
        builder: (context) {
          final list = context.watch<ProductListController>();
          return AppBackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppTopBar(
                title: l.sectionTitle(args.title),
                actions: [
                  SquareIconButton(
                    icon: Icons.tune_rounded,
                    tooltip: l.filters,
                    onTap: () =>
                        showFilterSheet(context, list, lockCategory: true),
                    badge: list.query.activeFilters == 0
                        ? null
                        : CountBadge(list.query.activeFilters),
                  ),
                  const CartIconButton(),
                ],
              ),
              body: const ContentWidth(child: ProductListView()),
            ),
          );
        },
      ),
    );
  }
}
