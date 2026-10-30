import 'package:flutter/material.dart';
import 'package:savora/core/extensions/context_extensions.dart';

/// Soft blurred color blobs behind the content so screens never look flat.
class GlowBackground extends StatelessWidget {
  final Widget child;

  const GlowBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final List<Color> glow = context.colors.backgroundGlow;
    return ColoredBox(
      color: context.colors.background,
      child: Stack(
        children: <Widget>[
          Positioned(top: -120, right: -80, child: _Blob(color: glow.first, size: 320)),
          Positioned(top: 260, left: -140, child: _Blob(color: glow.last, size: 360)),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: <Color>[color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
