import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/widgets/shimmer.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final int? cacheWidth;

  const AppNetworkImage({super.key, required this.url, this.fit = BoxFit.cover, this.cacheWidth});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      memCacheWidth: cacheWidth,
      fadeInDuration: const Duration(milliseconds: 300),
      placeholder: (BuildContext context, String _) => const ShimmerBox(),
      errorWidget: (BuildContext context, String _, Object _) => ColoredBox(
        color: context.colors.surfaceRaised,
        child: Icon(Icons.restaurant_rounded, color: context.colors.textTertiary),
      ),
    );
  }
}
