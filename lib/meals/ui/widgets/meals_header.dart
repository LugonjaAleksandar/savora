import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/glass_container.dart';
import 'package:savora/localization.dart';
import 'package:savora/meals/bloc/random_meal_cubit.dart';

class MealsHeader extends StatelessWidget {
  /// Fixed so the collapsing sliver header can compute its extents.
  static const double height = 164;

  const MealsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = context.textTheme.displaySmall;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _greeting(context),
                  style: context.textTheme.titleMedium?.copyWith(color: context.colors.textSecondary, fontWeight: FontWeight.w600),
                ),
              ),
              const _SurpriseButton(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text.rich(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            TextSpan(
              children: <InlineSpan>[
                TextSpan(text: '${AppLocalizations.of(context)!.meals_header_title_prefix} '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) => context.colors.brandLinearGradient.createShader(bounds),
                    child: Text(
                      AppLocalizations.of(context)!.meals_header_title_highlight,
                      style: titleStyle?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                TextSpan(text: AppLocalizations.of(context)!.meals_header_title_suffix),
              ],
            ),
            style: titleStyle,
          ),
        ],
      ).animate().fadeIn(duration: const Duration(milliseconds: 500)).slideY(begin: 0.1, curve: Curves.easeOutCubic),
    );
  }

  String _greeting(BuildContext context) {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return AppLocalizations.of(context)!.greeting_morning;
    }
    return hour < 18 ? AppLocalizations.of(context)!.greeting_afternoon : AppLocalizations.of(context)!.greeting_evening;
  }
}

class _SurpriseButton extends StatelessWidget {
  const _SurpriseButton();

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.select((RandomMealCubit cubit) => cubit.state is RandomMealLoading);
    return Tooltip(
      message: AppLocalizations.of(context)!.meals_surprise_me,
      child: PressableScale(
        onTap: isLoading ? null : () => context.read<RandomMealCubit>().pick(),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            gradient: context.colors.brandLinearGradient,
            borderRadius: BorderRadius.circular(100),
            boxShadow: <BoxShadow>[
              BoxShadow(color: context.colors.primary.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isLoading)
                const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
              else
                const Icon(Icons.casino_rounded, color: Colors.white, size: 20)
                    .animate(onPlay: (AnimationController controller) => controller.repeat(reverse: true))
                    .rotate(begin: -0.03, end: 0.03, duration: const Duration(milliseconds: 1200)),
              const SizedBox(width: AppSpacing.sm),
              Text(AppLocalizations.of(context)!.meals_surprise_me, style: context.textTheme.labelLarge?.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
