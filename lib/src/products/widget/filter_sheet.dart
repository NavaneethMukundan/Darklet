import 'package:darklet/src/home/controller/home_controller.dart';
import 'package:darklet/src/products/controller/product_list_controller.dart';
import 'package:darklet/src/repositories/product_repository.dart';
import 'package:darklet/src/utils/constants/app_constants.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/category_helpers.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Opens the filter & sort sheet for [list]. When [lockCategory] is true the
/// category chips are hidden (used on a category's own page).
Future<void> showFilterSheet(
  BuildContext context,
  ProductListController list, {
  bool lockCategory = false,
}) {
  final categories = context.read<HomeController>().categories;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _FilterSheet(
      list: list,
      categories: categories,
      lockCategory: lockCategory,
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  final ProductListController list;
  final List categories;
  final bool lockCategory;
  const _FilterSheet({
    required this.list,
    required this.categories,
    required this.lockCategory,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late ProductQuery q = widget.list.query;
  late RangeValues _range = RangeValues(
    q.minPrice ?? 0,
    q.maxPrice ?? AppConstants.priceFilterMax,
  );

  bool get _rangeActive =>
      _range.start > 0 || _range.end < AppConstants.priceFilterMax;

  void _apply() {
    widget.list.setQuery(
      q.copyWith(
        minPrice: _range.start > 0 ? _range.start : null,
        maxPrice: _range.end < AppConstants.priceFilterMax ? _range.end : null,
      ),
    );
    Navigator.pop(context);
  }

  void _reset() => setState(() {
    q = ProductQuery(
      query: q.query,
      categoryId: widget.lockCategory ? q.categoryId : null,
    );
    _range = const RangeValues(0, AppConstants.priceFilterMax);
  });

  Widget _title(String t) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 10),
    child: Text(t, style: ts(16, w: FontWeight.w600)),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sortLabels = {
      ProductSort.relevance: l.sortRelevance,
      ProductSort.priceLowHigh: l.sortPriceLow,
      ProductSort.priceHighLow: l.sortPriceHigh,
      ProductSort.topRated: l.sortTopRated,
    };
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.filters,
                            style: ts(22, w: FontWeight.w700),
                          ),
                        ),
                        TextButton(onPressed: _reset, child: Text(l.reset)),
                      ],
                    ),
                    if (!widget.lockCategory) ...[
                      _title(l.category),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text(l.all),
                            selected: q.categoryId == null,
                            onSelected: (_) => setState(
                              () => q = q.copyWith(categoryId: null),
                            ),
                          ),
                          for (final c in widget.categories)
                            ChoiceChip(
                              label: Text(categoryLabel(l, c.id, c.name)),
                              selected: q.categoryId == c.id,
                              onSelected: (_) => setState(
                                () => q = q.copyWith(categoryId: c.id),
                              ),
                            ),
                        ],
                      ),
                    ],
                    if (widget.list.brands.isNotEmpty) ...[
                      _title(l.brand),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final b in widget.list.brands)
                            FilterChip(
                              label: Text(b),
                              selected: q.brands.contains(b),
                              onSelected: (on) => setState(() {
                                final s = {...q.brands};
                                on ? s.add(b) : s.remove(b);
                                q = q.copyWith(brands: s);
                              }),
                            ),
                        ],
                      ),
                    ],
                    _title(l.priceRange),
                    RangeSlider(
                      values: _range,
                      min: 0,
                      max: AppConstants.priceFilterMax,
                      divisions: 40,
                      activeColor: color.primaryDarkColor,
                      labels: RangeLabels(
                        money(_range.start),
                        money(_range.end),
                      ),
                      onChanged: (v) => setState(() => _range = v),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          money(_range.start),
                          style: ts(13, c: color.kGrey),
                        ),
                        Text(
                          _rangeActive &&
                                  _range.end >= AppConstants.priceFilterMax
                              ? '${money(_range.end)}+'
                              : money(_range.end),
                          style: ts(13, c: color.kGrey),
                        ),
                      ],
                    ),
                    _title(l.sortBy),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final e in sortLabels.entries)
                          ChoiceChip(
                            label: Text(e.value),
                            selected: q.sort == e.key,
                            onSelected: (_) =>
                                setState(() => q = q.copyWith(sort: e.key)),
                          ),
                      ],
                    ),
                    kHeight10,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: PrimaryButton(label: l.applyFilters, onPressed: _apply),
            ),
          ],
        ),
      ),
    );
  }
}
