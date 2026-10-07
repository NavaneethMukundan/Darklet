import 'package:darklet/src/products/controller/product_list_controller.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/load_status.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/widgets/product_card.dart';
import 'package:darklet/src/utils/widgets/skeleton.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Grid for a [ProductListController]: skeleton / error / empty states,
/// pull-to-refresh and infinite scrolling.
class ProductListView extends StatefulWidget {
  final String heroPrefix;
  final EdgeInsets padding;
  const ProductListView({
    super.key,
    this.heroPrefix = 'list',
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 24),
  });

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 320) {
        context.read<ProductListController>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.watch<ProductListController>();
    return LayoutBuilder(
      builder: (context, box) {
        final cols = Responsive.gridColumns(box.maxWidth);
        if (c.status == LoadStatus.loading && c.items.isEmpty ||
            c.status == LoadStatus.idle) {
          return SingleChildScrollView(
            padding: widget.padding,
            child: ProductGridSkeleton(columns: cols, count: cols * 3),
          );
        }
        Widget scrollable(Widget child) => RefreshIndicator(
          color: color.primaryDarkColor,
          onRefresh: c.refresh,
          child: child,
        );
        if (c.status == LoadStatus.error) {
          return scrollable(
            ListView(
              children: [
                SizedBox(
                  height: box.maxHeight,
                  child: ErrorState(onRetry: c.load),
                ),
              ],
            ),
          );
        }
        if (c.items.isEmpty) {
          return scrollable(
            ListView(
              children: [
                SizedBox(
                  height: box.maxHeight,
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    title: l.noProductsTitle,
                    message: l.noProductsMessage,
                  ),
                ),
              ],
            ),
          );
        }
        return scrollable(
          CustomScrollView(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: widget.padding,
                sliver: SliverGrid.builder(
                  itemCount: c.items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (_, i) => ProductCard(
                    product: c.items[i],
                    heroPrefix: widget.heroPrefix,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: c.loadingMore
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: color.primaryDarkColor,
                          ),
                        ),
                      )
                    : kHeight20,
              ),
            ],
          ),
        );
      },
    );
  }
}
