import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/app_network_image.dart';
import 'package:savora/core/widgets/glass_container.dart';
import 'package:savora/favorites/bloc/favorites_cubit.dart';
import 'package:savora/meals/models/meal_summary.dart';
import 'package:savora/meals/ui/widgets/meal_hero.dart';

class MealCard extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;

  const MealCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = context.select((FavoritesCubit cubit) => cubit.state.isFavorite(meal.id));
    final BorderRadius radius = BorderRadius.circular(AppRadius.lg);

    return PressableScale(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: <BoxShadow>[BoxShadow(color: context.colors.shadow, blurRadius: 24, offset: const Offset(0, 10))],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Gradient and title fly with the image so they can cross-fade
              // into the detail header instead of staying behind on the grid.
              MealHero(
                mealId: meal.id,
                borderRadius: AppRadius.lg,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    AppNetworkImage(url: meal.previewUrl, cacheWidth: mealPreviewCacheWidth),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: <double>[0.45, 1],
                          colors: <Color>[Colors.transparent, Color(0xD9000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                      bottom: AppSpacing.md,
                      child: Text(
                        meal.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium?.copyWith(color: Colors.white, height: 1.2),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: GlassIconButton(
                  icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  iconColor: isFavorite ? context.colors.primary : Colors.white,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.read<FavoritesCubit>().toggle(meal);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
