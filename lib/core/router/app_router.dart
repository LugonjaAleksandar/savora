import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:savora/core/di/service_locator.dart';
import 'package:savora/favorites/ui/favorites_route.dart';
import 'package:savora/meals/bloc/meal_detail_cubit.dart';
import 'package:savora/meals/bloc/meals_bloc.dart';
import 'package:savora/meals/bloc/random_meal_cubit.dart';
import 'package:savora/meals/models/meal_summary.dart';
import 'package:savora/meals/ui/meal_detail_route.dart';
import 'package:savora/meals/ui/meals_route.dart';
import 'package:savora/reviews/bloc/meal_review_cubit.dart';
import 'package:savora/settings/ui/settings_route.dart';
import 'package:savora/shell/ui/app_shell.dart';

abstract final class AppRoutes {
  static const String discover = '/discover';
  static const String favorites = '/favorites';
  static const String settings = '/settings';

  static String meal(String id) => '/meal/$id';
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.discover,
    // Always open on Discover, even if the platform hands over its own route.
    overridePlatformDefaultLocation: true,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell shell) => AppShell(navigationShell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.discover,
                builder: (BuildContext context, GoRouterState state) => MultiBlocProvider(
                  providers: <BlocProvider<dynamic>>[
                    BlocProvider<MealsBloc>(create: (_) => MealsBloc(mealsRepository: sl())..add(const MealsStarted())),
                    BlocProvider<RandomMealCubit>(create: (_) => RandomMealCubit(mealsRepository: sl())),
                  ],
                  child: const MealsRoute(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[GoRoute(path: AppRoutes.favorites, builder: (_, _) => const FavoritesRoute())],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[GoRoute(path: AppRoutes.settings, builder: (_, _) => const SettingsRoute())],
          ),
        ],
      ),
      GoRoute(
        path: '/meal/:id',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String id = state.pathParameters['id']!;
          // `extra` is only a hint for the hero/preview; deep links work without it.
          final MealSummary? preview = state.extra is MealSummary ? state.extra! as MealSummary : null;
          // Fade instead of the platform slide: the hero carries the motion, and
          // a sliding page underneath would fight it.
          return CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 550),
            reverseTransitionDuration: const Duration(milliseconds: 450),
            // The page turns opaque in the first half, so the grid and the detail
            // never sit half-transparent on top of each other; on pop it stays
            // opaque until the sheet content has gone.
            transitionsBuilder: (_, Animation<double> animation, _, Widget child) => FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: const Interval(0, 0.5, curve: Curves.easeOut),
              ),
              child: child,
            ),
            child: MultiBlocProvider(
              providers: <BlocProvider<dynamic>>[
                BlocProvider<MealDetailCubit>(
                  create: (_) => MealDetailCubit(mealsRepository: sl(), mealId: id)..load(),
                ),
                BlocProvider<MealReviewCubit>(
                  create: (_) => MealReviewCubit(reviewsRepository: sl(), mealId: id),
                ),
              ],
              child: MealDetailRoute(mealId: id, preview: preview),
            ),
          );
        },
      ),
    ],
  );
}
