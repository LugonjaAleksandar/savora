part of 'meal_detail_cubit.dart';

sealed class MealDetailState extends Equatable {
  const MealDetailState();

  @override
  List<Object?> get props => <Object?>[];
}

final class MealDetailLoading extends MealDetailState {
  const MealDetailLoading();
}

final class MealDetailLoaded extends MealDetailState {
  final MealDetail meal;

  const MealDetailLoaded(this.meal);

  @override
  List<Object?> get props => <Object?>[meal];
}

final class MealDetailError extends MealDetailState {
  final AppFailure failure;

  const MealDetailError(this.failure);

  @override
  List<Object?> get props => <Object?>[failure];
}
