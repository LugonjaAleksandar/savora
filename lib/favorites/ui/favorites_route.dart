import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/router/app_router.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/glow_background.dart';
import 'package:savora/core/widgets/state_message.dart';
import 'package:savora/favorites/bloc/favorites_cubit.dart';
import 'package:savora/favorites/ui/widgets/favorite_tile.dart';
import 'package:savora/localization.dart';
import 'package:savora/meals/models/meal_summary.dart';

class FavoritesRoute extends StatelessWidget {
  const FavoritesRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MealSummary> favorites = context.select((FavoritesCubit cubit) => cubit.state.favorites);

    return Scaffold(
      body: GlowBackground(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverSafeArea(
              bottom: false,
              sliver: SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations.of(context)!.favorites_title, style: context.textTheme.displaySmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppLocalizations.of(context)!.favorites_subtitle(favorites.length),
                        style: context.textTheme.titleMedium?.copyWith(color: context.colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (favorites.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.navBarClearance),
                    child: StateMessage(
                      icon: Icons.favorite_rounded,
                      title: AppLocalizations.of(context)!.favorites_empty_title,
                      subtitle: AppLocalizations.of(context)!.favorites_empty_subtitle,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.navBarClearance),
                sliver: SliverList.separated(
                  itemCount: favorites.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (BuildContext context, int index) {
                    final MealSummary meal = favorites[index];
                    return Dismissible(
                      key: ValueKey<String>(meal.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _remove(context, meal, index),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: AppSpacing.lg),
                        decoration: BoxDecoration(color: context.colors.danger, borderRadius: BorderRadius.circular(AppRadius.lg)),
                        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
                      ),
                      child: FavoriteTile(meal: meal, onTap: () => _openMeal(context, meal)),
                    ).animate(delay: Duration(milliseconds: 40 * index.clamp(0, 8))).fadeIn().slideX(begin: 0.08);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openMeal(BuildContext context, MealSummary meal) => context.push(AppRoutes.meal(meal.id), extra: meal);

  void _remove(BuildContext context, MealSummary meal, int index) {
    final FavoritesCubit cubit = context.read<FavoritesCubit>()..remove(meal.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.favorites_removed),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.favorites_undo,
            onPressed: () => cubit.add(meal, atIndex: index),
          ),
        ),
      );
  }
}
