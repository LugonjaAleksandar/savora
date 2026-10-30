import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/favorites/repository/favorites_repository.dart';
import 'package:savora/meals/models/meal_summary.dart';

part 'favorites_state.dart';

/// App-wide (provided above the router) because the heart icon appears on
/// grid cards, the detail screen and the Saved tab at the same time.
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesCubit({required this._favoritesRepository}) : super(FavoritesState(favorites: _favoritesRepository.getFavorites()));

  Future<void> toggle(MealSummary meal) {
    return state.isFavorite(meal.id) ? remove(meal.id) : add(meal);
  }

  Future<void> add(MealSummary meal, {int? atIndex}) {
    if (state.isFavorite(meal.id)) {
      return Future<void>.value();
    }
    final List<MealSummary> updated = List<MealSummary>.of(state.favorites);
    updated.insert((atIndex ?? 0).clamp(0, updated.length), meal);
    return _update(updated);
  }

  Future<void> remove(String mealId) {
    return _update(state.favorites.where((MealSummary meal) => meal.id != mealId).toList());
  }

  /// Optimistic: the UI updates immediately, persistence follows.
  Future<void> _update(List<MealSummary> favorites) {
    emit(FavoritesState(favorites: List<MealSummary>.unmodifiable(favorites)));
    return _favoritesRepository.saveFavorites(favorites);
  }
}
