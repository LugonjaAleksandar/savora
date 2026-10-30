part of 'meals_bloc.dart';

sealed class MealsEvent extends Equatable {
  const MealsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class MealsStarted extends MealsEvent {
  const MealsStarted();
}

final class MealsCategorySelected extends MealsEvent {
  final MealCategory category;

  const MealsCategorySelected(this.category);

  @override
  List<Object?> get props => <Object?>[category];
}

final class MealsSearchChanged extends MealsEvent {
  final String query;

  const MealsSearchChanged(this.query);

  @override
  List<Object?> get props => <Object?>[query];
}

final class MealsRefreshed extends MealsEvent {
  const MealsRefreshed();
}
