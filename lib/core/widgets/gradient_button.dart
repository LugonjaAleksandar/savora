import 'package:flutter/material.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/glass_container.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool expand;

  const GradientButton({super.key, required this.label, required this.onPressed, this.icon, this.expand = false});

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;
    return PressableScale(
      onTap: onPressed,
      child: AnimatedOpacity(
        opacity: isEnabled ? 1 : 0.45,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 54,
          width: expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: context.colors.brandLinearGradient,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: isEnabled
                ? <BoxShadow>[BoxShadow(color: context.colors.primary.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 10))]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null) ...<Widget>[Icon(icon, color: Colors.white, size: 20), const SizedBox(width: AppSpacing.sm)],
              Text(label, style: context.textTheme.labelLarge?.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
