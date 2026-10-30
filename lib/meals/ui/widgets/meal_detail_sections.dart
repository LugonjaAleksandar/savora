import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/localization.dart';
import 'package:savora/meals/models/ingredient.dart';
import 'package:savora/meals/ui/widgets/ingredient_tile.dart';

class MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const MetaChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: context.colors.surfaceRaised, borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: context.colors.primary),
          const SizedBox(width: 6),
          Text(label, style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final String? trailing;

  const SectionHeading({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(child: Text(title, style: context.textTheme.headlineSmall)),
        if (trailing != null) Text(trailing!, style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
      ],
    );
  }
}

class IngredientsGrid extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientsGrid({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 72,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
      ),
      itemCount: ingredients.length,
      itemBuilder: (BuildContext context, int index) {
        final Ingredient ingredient = ingredients[index];
        return IngredientTile(ingredient: ingredient).animate(delay: Duration(milliseconds: 30 * index)).fadeIn().slideX(begin: 0.05);
      },
    );
  }
}

class InstructionSteps extends StatelessWidget {
  final List<String> steps;

  const InstructionSteps({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int index = 0; index < steps.length; index++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: context.colors.brandLinearGradient),
                      child: Text('${index + 1}', style: context.textTheme.labelLarge?.copyWith(color: Colors.white)),
                    ),
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[context.colors.primary.withValues(alpha: 0.5), context.colors.stroke],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.detail_step(index + 1),
                          style: context.textTheme.labelMedium?.copyWith(color: context.colors.primary, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(steps[index], style: context.textTheme.bodyLarge?.copyWith(height: 1.55)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
