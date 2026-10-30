import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:savora/core/extensions/app_failure_l10n.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/router/app_router.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/app_network_image.dart';
import 'package:savora/core/widgets/glass_container.dart';
import 'package:savora/core/widgets/shimmer.dart';
import 'package:savora/core/widgets/state_message.dart';
import 'package:savora/favorites/bloc/favorites_cubit.dart';
import 'package:savora/localization.dart';
import 'package:savora/meals/bloc/meal_detail_cubit.dart';
import 'package:savora/meals/models/meal_detail.dart';
import 'package:savora/meals/models/meal_summary.dart';
import 'package:savora/meals/ui/widgets/meal_detail_sections.dart';
import 'package:savora/meals/ui/widgets/meal_hero.dart';
import 'package:savora/reviews/ui/review_section.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailRoute extends StatelessWidget {
  static const double _imageHeight = 380;
  static const double _sheetOverlap = 32;

  final String mealId;
  final MealSummary? preview;

  const MealDetailRoute({super.key, required this.mealId, this.preview});

  @override
  Widget build(BuildContext context) {
    final MealDetailState state = context.watch<MealDetailCubit>().state;
    final MealSummary? summary = switch (state) {
      MealDetailLoaded(:final MealDetail meal) => meal.toSummary(),
      _ => preview,
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: _imageHeight,
              backgroundColor: context.colors.background,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: Center(
                  child: GlassIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.discover),
                  ),
                ),
              ),
              actions: <Widget>[
                if (summary != null) _FavoriteAction(meal: summary),
                const SizedBox(width: AppSpacing.md),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const <StretchMode>[StretchMode.zoomBackground],
                background: MealHero(
                  mealId: mealId,
                  sheetOverlap: _sheetOverlap,
                  child: _HeaderImage(meal: summary),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(_sheetOverlap),
                child: Container(
                  height: _sheetOverlap,
                  decoration: BoxDecoration(
                    color: context.colors.background,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(_sheetOverlap)),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
              sliver: SliverToBoxAdapter(
                child: _SheetEntrance(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutCubic,
                    // Keep skeleton and content pinned to the top while they
                    // cross-fade; the default centering makes the taller one jump.
                    layoutBuilder: (Widget? current, List<Widget> previous) =>
                        Stack(alignment: Alignment.topCenter, children: <Widget>[...previous, ?current]),
                    child: switch (state) {
                      MealDetailLoading() => _DetailSkeleton(title: preview?.name),
                      MealDetailError(:final AppFailure failure) => StateMessage(
                        icon: Icons.no_meals_rounded,
                        title: failure.localizedMessage(context),
                        actionLabel: AppLocalizations.of(context)!.action_retry,
                        onAction: context.read<MealDetailCubit>().load,
                      ),
                      MealDetailLoaded(:final MealDetail meal) => _DetailContent(meal: meal, onOpenLink: _openLink),
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLink(Uri uri) => launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Header image layered so the hero never lands on an empty frame: the preview
/// the grid already decoded sits underneath and the full-resolution image
/// fades in over it once downloaded.
class _HeaderImage extends StatelessWidget {
  final MealSummary? meal;

  const _HeaderImage({required this.meal});

  @override
  Widget build(BuildContext context) {
    final MealSummary? meal = this.meal;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (meal == null) const ShimmerBox() else AppNetworkImage(url: meal.previewUrl, cacheWidth: mealPreviewCacheWidth),
        if (meal != null)
          CachedNetworkImage(
            imageUrl: meal.thumbnailUrl,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 250),
            placeholder: (BuildContext context, String _) => const SizedBox.shrink(),
            errorWidget: (BuildContext context, String _, Object _) => const SizedBox.shrink(),
          ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: <double>[0, 0.3, 0.7, 1],
              colors: <Color>[Color(0x99000000), Colors.transparent, Colors.transparent, Color(0x66000000)],
            ),
          ),
        ),
      ],
    );
  }
}

/// Rises the sheet content in step with the route animation, trailing the hero
/// slightly, and sinks it first thing on pop, before the page fades. Driving it from the route (not from
/// the load state) means it animates the same whether data is cached or not.
class _SheetEntrance extends StatelessWidget {
  static const double _distance = 96;

  final Widget child;

  const _SheetEntrance({required this.child});

  @override
  Widget build(BuildContext context) {
    final Animation<double>? routeAnimation = ModalRoute.of(context)?.animation;
    if (routeAnimation == null) {
      return child;
    }
    final Animation<double> progress = CurvedAnimation(
      parent: routeAnimation,
      curve: const Interval(0.3, 1, curve: Curves.easeOutCubic),
      reverseCurve: const Interval(0.5, 1, curve: Curves.easeInCubic),
    );
    return AnimatedBuilder(
      animation: progress,
      builder: (BuildContext context, Widget? child) => Opacity(
        opacity: progress.value,
        child: Transform.translate(offset: Offset(0, _distance * (1 - progress.value)), child: child),
      ),
      child: child,
    );
  }
}

class _FavoriteAction extends StatelessWidget {
  final MealSummary meal;

  const _FavoriteAction({required this.meal});

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = context.select((FavoritesCubit cubit) => cubit.state.isFavorite(meal.id));
    return GlassIconButton(
      icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
      iconColor: isFavorite ? context.colors.primary : Colors.white,
      onPressed: () {
        HapticFeedback.mediumImpact();
        context.read<FavoritesCubit>().toggle(meal);
      },
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  final String? title;

  const _DetailSkeleton({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Text(title!, style: context.textTheme.headlineMedium)
        else
          ShimmerBox(height: 36, width: 240, borderRadius: BorderRadius.circular(AppRadius.sm)),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            for (int index = 0; index < 3; index++) ...<Widget>[
              ShimmerBox(height: 34, width: 96, borderRadius: BorderRadius.circular(100)),
              const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ShimmerBox(height: 140, borderRadius: BorderRadius.circular(AppRadius.lg)),
        const SizedBox(height: AppSpacing.lg),
        for (int index = 0; index < 4; index++) ...<Widget>[
          ShimmerBox(height: 64, borderRadius: BorderRadius.circular(AppRadius.md)),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _DetailContent extends StatelessWidget {
  final MealDetail meal;
  final ValueChanged<Uri> onOpenLink;

  const _DetailContent({required this.meal, required this.onOpenLink});

  @override
  Widget build(BuildContext context) {
    final List<String> steps = meal.steps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(meal.name, style: context.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: <Widget>[
            if (meal.category != null) MetaChip(icon: Icons.restaurant_menu_rounded, label: meal.category!),
            if (meal.area != null) MetaChip(icon: Icons.public_rounded, label: meal.area!),
            MetaChip(
              icon: Icons.shopping_basket_rounded,
              label: AppLocalizations.of(context)!.detail_ingredients_count(meal.ingredients.length),
            ),
            for (final String tag in meal.tags) MetaChip(icon: Icons.tag_rounded, label: tag),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const ReviewSection(),
        const SizedBox(height: AppSpacing.xl),
        SectionHeading(title: AppLocalizations.of(context)!.detail_ingredients, trailing: '${meal.ingredients.length}'),
        const SizedBox(height: AppSpacing.md),
        IngredientsGrid(ingredients: meal.ingredients),
        const SizedBox(height: AppSpacing.xl),
        SectionHeading(title: AppLocalizations.of(context)!.detail_instructions),
        const SizedBox(height: AppSpacing.md),
        InstructionSteps(steps: steps),
        if (meal.hasVideo || meal.hasSource) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              if (meal.hasVideo)
                FilledButton.icon(
                  onPressed: () => onOpenLink(meal.youtubeUrl!),
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF0033), padding: const EdgeInsets.all(AppSpacing.md)),
                  icon: const Icon(Icons.play_circle_fill_rounded),
                  label: Text(AppLocalizations.of(context)!.detail_watch_video),
                ),
              if (meal.hasSource)
                OutlinedButton.icon(
                  onPressed: () => onOpenLink(meal.sourceUrl!),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(AppSpacing.md)),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(AppLocalizations.of(context)!.detail_source),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
