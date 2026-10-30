import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:savora/core/extensions/app_failure_l10n.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/router/app_router.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/glow_background.dart';
import 'package:savora/core/widgets/shimmer.dart';
import 'package:savora/core/widgets/state_message.dart';
import 'package:savora/localization.dart';
import 'package:savora/meals/bloc/meals_bloc.dart';
import 'package:savora/meals/bloc/random_meal_cubit.dart';
import 'package:savora/meals/models/meal_category.dart';
import 'package:savora/meals/models/meal_summary.dart';
import 'package:savora/meals/ui/widgets/category_chips.dart';
import 'package:savora/meals/ui/widgets/meal_card.dart';
import 'package:savora/meals/ui/widgets/meals_header.dart';
import 'package:savora/meals/ui/widgets/meals_search_field.dart';

class MealsRoute extends StatefulWidget {
  const MealsRoute({super.key});

  @override
  State<MealsRoute> createState() => _MealsRouteState();
}

class _MealsRouteState extends State<MealsRoute> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RandomMealCubit, RandomMealState>(
      listener: (BuildContext context, RandomMealState state) {
        switch (state) {
          case RandomMealReady(:final MealSummary meal):
            _openMeal(meal);
          case RandomMealError(:final AppFailure failure):
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.localizedMessage(context))));
          case RandomMealIdle() || RandomMealLoading():
            break;
        }
      },
      child: Scaffold(
        body: GlowBackground(
          child: RefreshIndicator.adaptive(
            edgeOffset: MediaQuery.paddingOf(context).top,
            onRefresh: () async {
              final MealsBloc bloc = context.read<MealsBloc>()..add(const MealsRefreshed());
              await bloc.stream.firstWhere((MealsState state) => state.status != MealsStatus.loading);
            },
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _CollapsingHeaderDelegate(
                    topPadding: MediaQuery.paddingOf(context).top,
                    header: const MealsHeader(),
                    search: MealsSearchField(
                      controller: _searchController,
                      onChanged: (String query) => context.read<MealsBloc>().add(MealsSearchChanged(query)),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<MealsBloc, MealsState>(
                    buildWhen: (MealsState previous, MealsState current) =>
                        previous.categories != current.categories ||
                        previous.selectedCategory != current.selectedCategory ||
                        previous.isSearching != current.isSearching,
                    builder: (BuildContext context, MealsState state) {
                      return Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.md),
                        child: CategoryChips(
                          categories: state.categories,
                          selected: state.selectedCategory,
                          isDimmed: state.isSearching,
                          onSelected: _selectCategory,
                        ),
                      );
                    },
                  ),
                ),
                const _MealsSectionTitle(),
                _MealsContent(onMealTap: _openMeal),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.navBarClearance)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openMeal(MealSummary meal) => context.push(AppRoutes.meal(meal.id), extra: meal);

  void _selectCategory(MealCategory category) {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    context.read<MealsBloc>().add(MealsCategorySelected(category));
  }
}

/// Greeting + title collapse (fade & drift up) while the search field
/// stays pinned below the status bar.
class _CollapsingHeaderDelegate extends SliverPersistentHeaderDelegate {
  static const double _searchBlockHeight = 76;

  final double topPadding;
  final Widget header;
  final Widget search;

  const _CollapsingHeaderDelegate({required this.topPadding, required this.header, required this.search});

  @override
  double get minExtent => topPadding + _searchBlockHeight;

  @override
  double get maxExtent => topPadding + MealsHeader.height + _searchBlockHeight;

  @override
  bool shouldRebuild(_CollapsingHeaderDelegate oldDelegate) {
    return oldDelegate.topPadding != topPadding || oldDelegate.header != header || oldDelegate.search != search;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0, 1);
    final bool isCollapsed = progress >= 1;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: context.colors.background.withValues(alpha: Curves.easeIn.transform(progress) * 0.94),
        boxShadow: isCollapsed ? <BoxShadow>[BoxShadow(color: context.colors.shadow, blurRadius: 16)] : null,
      ),
      child: ClipRect(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: topPadding - shrinkOffset * 0.6,
              left: 0,
              right: 0,
              height: MealsHeader.height,
              child: Opacity(opacity: (1 - progress * 1.6).clamp(0, 1), child: header),
            ),
            Positioned(left: AppSpacing.lg, right: AppSpacing.lg, bottom: AppSpacing.sm, child: search),
          ],
        ),
      ),
    );
  }
}

class _MealsSectionTitle extends StatelessWidget {
  const _MealsSectionTitle();

  @override
  Widget build(BuildContext context) {
    final MealsState state = context.watch<MealsBloc>().state;
    final String title = state.isSearching
        ? AppLocalizations.of(context)!.meals_section_search(state.query)
        : AppLocalizations.of(context)!.meals_section_category(state.selectedCategory?.name ?? '');
    final bool showCount = state.status == MealsStatus.success;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: <Widget>[
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                layoutBuilder: (Widget? current, List<Widget> previous) =>
                    Stack(alignment: Alignment.centerLeft, children: <Widget>[...previous, ?current]),
                child: Text(
                  title,
                  key: ValueKey<String>(title),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.headlineSmall,
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: showCount ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: context.colors.surfaceRaised, borderRadius: BorderRadius.circular(100)),
                child: Text(
                  AppLocalizations.of(context)!.meals_count(state.meals.length),
                  style: context.textTheme.labelMedium?.copyWith(color: context.colors.primary, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealsContent extends StatelessWidget {
  static const SliverGridDelegate _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: AppSpacing.md,
    crossAxisSpacing: AppSpacing.md,
    childAspectRatio: 0.74,
  );

  final ValueChanged<MealSummary> onMealTap;

  const _MealsContent({required this.onMealTap});

  @override
  Widget build(BuildContext context) {
    final MealsState state = context.watch<MealsBloc>().state;

    final Widget sliver = switch (state.status) {
      MealsStatus.initial || MealsStatus.loading => SliverGrid.builder(
        gridDelegate: _gridDelegate,
        itemCount: 6,
        itemBuilder: (_, _) => ShimmerBox(borderRadius: BorderRadius.circular(AppRadius.lg)),
      ),
      MealsStatus.failure => SliverToBoxAdapter(
        child: StateMessage(
          icon: Icons.wifi_off_rounded,
          title: state.failure?.localizedMessage(context) ?? AppLocalizations.of(context)!.error_unknown,
          actionLabel: AppLocalizations.of(context)!.action_retry,
          onAction: () => context.read<MealsBloc>().add(const MealsRefreshed()),
        ),
      ),
      MealsStatus.success when state.meals.isEmpty => SliverToBoxAdapter(
        child: StateMessage(
          icon: Icons.ramen_dining_rounded,
          title: AppLocalizations.of(context)!.meals_empty_title,
          subtitle: AppLocalizations.of(context)!.meals_empty_subtitle,
        ),
      ),
      MealsStatus.success => SliverGrid.builder(
        // Re-key per result set so the staggered entrance replays on category change.
        key: ValueKey<String>('${state.selectedCategory?.id}-${state.query}'),
        gridDelegate: _gridDelegate,
        itemCount: state.meals.length,
        itemBuilder: (BuildContext context, int index) {
          final MealSummary meal = state.meals[index];
          return MealCard(meal: meal, onTap: () => onMealTap(meal))
              .animate(delay: Duration(milliseconds: 50 * (index % 8)))
              .fadeIn(duration: const Duration(milliseconds: 350))
              .slideY(begin: 0.12, curve: Curves.easeOutCubic)
              .scaleXY(begin: 0.96, curve: Curves.easeOutCubic);
        },
      ),
    };

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      sliver: sliver,
    );
  }
}
