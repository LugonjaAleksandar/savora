part of 'favorites_cubit.dart';

final class FavoritesState extends Equatable {
  final List<MealSummary> favorites;

  const FavoritesState({this.favorites = const <MealSummary>[]});

  @override
  List<Object?> get props => <Object?>[favorites];

  bool isFavorite(String mealId) => favorites.any((MealSummary meal) => meal.id == mealId);
}
