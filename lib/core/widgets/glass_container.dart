import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:savora/core/extensions/context_extensions.dart';

/// Frosted-glass surface used by the nav bar, chips and floating buttons.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final Color? tint;

  const GlassContainer({super.key, required this.child, required this.borderRadius, this.padding, this.blur = 18, this.tint});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tint ?? context.colors.glass,
            borderRadius: borderRadius,
            border: Border.all(color: context.colors.glassStroke),
          ),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final String? tooltip;

  const GlassIconButton({super.key, required this.icon, required this.onPressed, this.iconColor, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: PressableScale(
        onTap: onPressed,
        child: GlassContainer(
          borderRadius: BorderRadius.circular(100),
          tint: Colors.black.withValues(alpha: 0.25),
          child: SizedBox.square(
            dimension: 44,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) => ScaleTransition(scale: animation, child: child),
              child: Icon(icon, key: ValueKey<IconData>(icon), color: iconColor ?? Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

/// Gives any tappable a subtle press-down scale, which reads far more
/// "native" than a flat ink splash on image-heavy cards.
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

  const PressableScale({super.key, required this.child, required this.onTap, this.pressedScale = 0.96});

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: widget.onTap == null ? null : (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() => _isPressed = value);
    }
  }
}
