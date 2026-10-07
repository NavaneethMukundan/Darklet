import 'package:darklet/src/utils/widgets/skeleton.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:flutter/material.dart';

/// Network image with a skeleton while loading and an icon on failure.
class AppNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  const AppNetworkImage(
    this.url, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback();
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : const Skeleton(radius: 0),
      errorBuilder: (_, _, _) => _fallback(),
    );
  }

  Widget _fallback() => Container(
    width: width,
    height: height,
    color: color.kLightGrey.withValues(alpha: 0.2),
    child: Icon(
      Icons.image_not_supported_outlined,
      color: color.kGrey,
      size: 28,
    ),
  );
}
