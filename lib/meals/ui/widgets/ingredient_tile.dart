import 'package:flutter/material.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/app_network_image.dart';
import 'package:savora/meals/models/ingredient.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientTile({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.colors.stroke),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: context.colors.surfaceRaised, borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: AppNetworkImage(url: ingredient.imageUrl, fit: BoxFit.contain, cacheWidth: 150),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(ingredient.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.textTheme.titleSmall),
                if (ingredient.measure.isNotEmpty)
                  Text(
                    ingredient.measure,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(color: context.colors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
