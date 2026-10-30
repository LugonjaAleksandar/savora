import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/network/result.dart';
import 'package:savora/meals/bloc/meals_bloc.dart';
import 'package:savora/meals/models/meal_category.dart';
import 'package:savora/meals/models/meal_summary.dart';
import 'package:savora/meals/repository/meals_repository.dart';

import '../helpers/fixtures.dart';

class MockMealsRepository extends Mock implements MealsRepository {}

void main() {
  late MockMealsRepository repository;

  setUp(() {
    repository = MockMealsRepository();
    when(
      () => repository.getCategories(forceRefresh: any(named: 'forceRefresh')),
    ).thenAnswer((_) async => const Success<List<MealCategory>>(<MealCategory>[beef, seafood]));
    when(() => repository.getMealsByCategory('Beef')).thenAnswer((_) async => const Success<List<MealSummary>>(<MealSummary>[wellington]));
    when(() => repository.getMealsByCategory('Seafood')).thenAnswer((_) async => const Success<List<MealSummary>>(<MealSummary>[paella]));
  });

  const MealsState loaded = MealsState(
    status: MealsStatus.success,
    categories: <MealCategory>[beef, seafood],
    selectedCategory: beef,
    meals: <MealSummary>[wellington],
  );

  blocTest<MealsBloc, MealsState>(
    'loads categories, selects the first one and fetches its meals',
    build: () => MealsBloc(mealsRepository: repository),
    act: (MealsBloc bloc) => bloc.add(const MealsStarted()),
    expect: () => <MealsState>[
      const MealsState(status: MealsStatus.loading),
      const MealsState(status: MealsStatus.loading, categories: <MealCategory>[beef, seafood], selectedCategory: beef),
      loaded,
    ],
  );

  blocTest<MealsBloc, MealsState>(
    'switching category keeps categories visible while loading',
    build: () => MealsBloc(mealsRepository: repository),
    seed: () => loaded,
    act: (MealsBloc bloc) => bloc.add(const MealsCategorySelected(seafood)),
    expect: () => <MealsState>[
      loaded.copyWith(status: MealsStatus.loading, selectedCategory: seafood),
      loaded.copyWith(status: MealsStatus.success, selectedCategory: seafood, meals: <MealSummary>[paella]),
    ],
  );

  blocTest<MealsBloc, MealsState>(
    'debounces search so only the last query hits the repository',
    build: () {
      when(() => repository.searchMeals(any())).thenAnswer((_) async => const Success<List<MealSummary>>(<MealSummary>[paella]));
      return MealsBloc(mealsRepository: repository);
    },
    seed: () => loaded,
    act: (MealsBloc bloc) => bloc
      ..add(const MealsSearchChanged('p'))
      ..add(const MealsSearchChanged('pa'))
      ..add(const MealsSearchChanged('paella')),
    wait: MealsBloc.searchDebounce * 2,
    expect: () => <MealsState>[
      loaded.copyWith(status: MealsStatus.loading, query: 'paella'),
      loaded.copyWith(status: MealsStatus.success, query: 'paella', meals: <MealSummary>[paella]),
    ],
    verify: (_) {
      verify(() => repository.searchMeals('paella')).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  blocTest<MealsBloc, MealsState>(
    'emits failure when categories cannot be loaded',
    build: () {
      when(
        () => repository.getCategories(forceRefresh: any(named: 'forceRefresh')),
      ).thenAnswer((_) async => const Failure<List<MealCategory>>(NetworkFailure()));
      return MealsBloc(mealsRepository: repository);
    },
    act: (MealsBloc bloc) => bloc.add(const MealsStarted()),
    expect: () => <MealsState>[
      const MealsState(status: MealsStatus.loading),
      const MealsState(status: MealsStatus.failure, failure: NetworkFailure()),
    ],
  );
}
