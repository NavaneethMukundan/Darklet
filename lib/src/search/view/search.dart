import 'dart:async';

import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/search/controller/search_history.dart';
import 'package:darklet/src/products/controller/product_list_controller.dart';
import 'package:darklet/src/products/widget/filter_sheet.dart';
import 'package:darklet/src/products/widget/product_list_view.dart';
import 'package:darklet/src/utils/constants/app_constants.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Search with live results, filters (category, brand, price) and sorting.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          ProductListController(ctx.read<AppDependencies>().products)..load(),
      child: const _SearchBody(),
    );
  }
}

class _SearchBody extends StatefulWidget {
  const _SearchBody();

  @override
  State<_SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<_SearchBody> {
  final _text = TextEditingController();
  Timer? _debounce;
  late final SearchHistory _history = SearchHistory(
    context.read<AppDependencies>().prefs,
  );
  late List<String> _recent = _history.items;

  @override
  void dispose() {
    _debounce?.cancel();
    _text.dispose();
    super.dispose();
  }

  /// Runs [term] immediately (chip tap or keyboard search) and remembers it.
  Future<void> _search(String term) async {
    _debounce?.cancel();
    _text.text = term;
    _text.selection = TextSelection.collapsed(offset: term.length);
    FocusManager.instance.primaryFocus?.unfocus();
    final recent = await _history.add(term);
    if (!mounted) return;
    setState(() => _recent = recent);
    context.read<ProductListController>().setText(term);
  }

  void _onChanged(String v) {
    setState(() {}); // refresh the clear button
    _debounce?.cancel();
    _debounce = Timer(
      AppConstants.searchDebounce,
      () => context.read<ProductListController>().setText(v),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final list = context.watch<ProductListController>();
    final filters = list.query.activeFilters;
    // Nothing typed and no filters: show history + suggestions instead of results.
    final browsing = _text.text.trim().isEmpty && filters == 0;
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ContentWidth(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      const AppBackButton(),
                      kWidth10,
                      Expanded(
                        child: TextField(
                          controller: _text,
                          autofocus: true,
                          onChanged: _onChanged,
                          textInputAction: TextInputAction.search,
                          onSubmitted: _search,
                          style: ts(14, w: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: l.searchProducts,
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: color.kBlackSecondary,
                            ),
                            suffixIcon: _text.text.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () {
                                      _text.clear();
                                      list.setText('');
                                      setState(() {});
                                    },
                                  ),
                          ),
                        ),
                      ),
                      kWidth10,
                      SquareIconButton(
                        icon: Icons.tune_rounded,
                        tooltip: l.filters,
                        onTap: () => showFilterSheet(context, list),
                        badge: filters == 0 ? null : CountBadge(filters),
                      ),
                    ],
                  ),
                ),
                if (!browsing &&
                    (list.items.isNotEmpty || list.query.query.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        l.resultsCount(
                          list.items.length,
                          list.hasMore ? '+' : '',
                        ),
                        style: ts(13, w: FontWeight.w400, c: color.kGrey),
                      ),
                    ),
                  ),
                Expanded(
                  child: browsing
                      ? _Suggestions(
                          recent: _recent,
                          brands: list.brands,
                          onPick: _search,
                          onClear: () async {
                            await _history.clear();
                            setState(() => _recent = []);
                          },
                        )
                      : const ProductListView(heroPrefix: 'search'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  final List<String> recent;
  final List<String> brands;
  final ValueChanged<String> onPick;
  final VoidCallback onClear;
  const _Suggestions({
    required this.recent,
    required this.brands,
    required this.onPick,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final popular = [
      l.catPhones,
      l.catLaptops,
      l.catConsoles,
      l.catAudio,
      ...brands.take(4),
    ];
    Widget chip(String t, IconData icon) => ActionChip(
      avatar: Icon(icon, size: 16, color: color.kGrey),
      label: Text(t),
      onPressed: () => onPick(t),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (recent.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  l.recentSearches,
                  style: ts(16, w: FontWeight.w600),
                ),
              ),
              TextButton(onPressed: onClear, child: Text(l.clearAll)),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final r in recent) chip(r, Icons.history_rounded)],
          ),
          kHeight25,
        ],
        Text(l.popularSearches, style: ts(16, w: FontWeight.w600)),
        kHeight10,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final p in popular) chip(p, Icons.trending_up_rounded),
          ],
        ),
      ],
    );
  }
}
