import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:flutter/material.dart';

/// Pulsing placeholder box used while content loads.
class Skeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double radius;
  const Skeleton({super.key, this.width, this.height, this.radius = 12});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: color.kLightGrey.withValues(alpha: 0.15 + 0.2 * _c.value),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

/// Grid of product-card skeletons.
class ProductGridSkeleton extends StatelessWidget {
  final int count;
  final int columns;
  const ProductGridSkeleton({super.key, this.count = 6, this.columns = 2});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, _) => const Skeleton(radius: 22),
    );
  }
}

/// Vertical list of row skeletons.
class ListSkeleton extends StatelessWidget {
  final int count;
  final double itemHeight;
  const ListSkeleton({super.key, this.count = 5, this.itemHeight = 100});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (_, _) => Skeleton(height: itemHeight, radius: 16),
    );
  }
}
