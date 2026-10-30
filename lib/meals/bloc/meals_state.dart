part of 'meals_bloc.dart';

enum MealsStatus { initial, loading, success, failure }

/// Single immutable state with a status enum: the screen always has the
/// categories, the current selection and the last results together, so
/// switching category never blanks out the header.
final class MealsState extends Equatable {
  final MealsStatus status;
  final List<MealCategory> categories;
  final MealCategory? selectedCategory;
  final String query;
  final List<MealSummary> meals;
  final AppFailure? failure;

  const MealsState({
    this.status = MealsStatus.initial,
    this.categories = const <MealCategory>[],
    this.selectedCategory,
    this.query = '',
    this.meals = const <MealSummary>[],
    this.failure,
  });

  @override
  List<Object?> get props => <Object?>[status, categories, selectedCategory, query, meals, failure];

  MealsState copyWith({
    MealsStatus? status,
    List<MealCategory>? categories,
    MealCategory? selectedCategory,
    String? query,
    List<MealSummary>? meals,
    AppFailure? failure,
  }) {
    return MealsState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      query: query ?? this.query,
      meals: meals ?? this.meals,
      failure: status == MealsStatus.failure ? failure ?? this.failure : null,
    );
  }

  bool get isSearching => query.isNotEmpty;
}
