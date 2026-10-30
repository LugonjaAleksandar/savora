import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savora/favorites/bloc/favorites_cubit.dart';
import 'package:savora/favorites/repository/favorites_repository.dart';
import 'package:savora/meals/models/meal_summary.dart';

import '../helpers/fixtures.dart';
import '../helpers/in_memory_storage.dart';

void main() {
  late LocalFavoritesRepository repository;

  setUp(() => repository = LocalFavoritesRepository(storage: InMemoryKeyValueStorage()));

  blocTest<FavoritesCubit, FavoritesState>(
    'toggle adds newest first, then removes',
    build: () => FavoritesCubit(favoritesRepository: repository),
    act: (FavoritesCubit cubit) async {
      await cubit.toggle(wellington);
      await cubit.toggle(paella);
      await cubit.toggle(wellington);
    },
    expect: () => <FavoritesState>[
      const FavoritesState(favorites: <MealSummary>[wellington]),
      const FavoritesState(favorites: <MealSummary>[paella, wellington]),
      const FavoritesState(favorites: <MealSummary>[paella]),
    ],
    verify: (_) => expect(repository.getFavorites(), <MealSummary>[paella]),
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'undo re-inserts at the original position',
    setUp: () => repository.saveFavorites(<MealSummary>[paella, wellington]),
    build: () => FavoritesCubit(favoritesRepository: repository),
    act: (FavoritesCubit cubit) async {
      await cubit.remove(paella.id);
      await cubit.add(paella, atIndex: 0);
    },
    expect: () => <FavoritesState>[
      const FavoritesState(favorites: <MealSummary>[wellington]),
      const FavoritesState(favorites: <MealSummary>[paella, wellington]),
    ],
  );
}
