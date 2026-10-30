import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/gradient_button.dart';

/// Shared empty / error view: gradient icon badge, title, subtitle, optional action.
class StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateMessage({super.key, required this.icon, required this.title, this.subtitle, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: context.colors.brandLinearGradient,
              boxShadow: <BoxShadow>[
                BoxShadow(color: context.colors.primary.withValues(alpha: 0.35), blurRadius: 32, offset: const Offset(0, 12)),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ).animate().scale(begin: const Offset(0.6, 0.6), curve: Curves.elasticOut, duration: const Duration(milliseconds: 900)).fadeIn(),
          const SizedBox(height: AppSpacing.lg),
          Text(title, textAlign: TextAlign.center, style: context.textTheme.headlineSmall),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(color: context.colors.textSecondary),
            ),
          ],
          if (actionLabel != null && onAction != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            GradientButton(label: actionLabel!, icon: Icons.refresh_rounded, onPressed: onAction),
          ],
        ],
      ).animate().fadeIn(duration: const Duration(milliseconds: 300)).slideY(begin: 0.08),
    );
  }
}
