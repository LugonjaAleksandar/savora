import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:savora/core/extensions/context_extensions.dart';

/// Skeleton placeholder with a moving highlight.
class ShimmerBox extends StatelessWidget {
  final BorderRadius borderRadius;
  final double? width;
  final double? height;

  const ShimmerBox({super.key, this.borderRadius = BorderRadius.zero, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: context.colors.surfaceRaised, borderRadius: borderRadius),
        )
        .animate(onPlay: (AnimationController controller) => controller.repeat())
        .shimmer(duration: const Duration(milliseconds: 1400), color: context.colors.surface.withValues(alpha: 0.6));
  }
}
