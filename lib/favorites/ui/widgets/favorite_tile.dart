import 'package:flutter/material.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/app_network_image.dart';
import 'package:savora/core/widgets/glass_container.dart';
import 'package:savora/meals/models/meal_summary.dart';
import 'package:savora/meals/ui/widgets/meal_hero.dart';

class FavoriteTile extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;

  const FavoriteTile({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: <BoxShadow>[BoxShadow(color: context.colors.shadow, blurRadius: 18, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox.square(
                dimension: 84,
                child: MealHero(
                  mealId: meal.id,
                  borderRadius: AppRadius.md,
                  child: AppNetworkImage(url: meal.previewUrl, cacheWidth: mealPreviewCacheWidth),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(meal.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.textTheme.titleMedium),
            ),
            Icon(Icons.chevron_right_rounded, color: context.colors.textTertiary),
          ],
        ),
      ),
    );
  }
}
