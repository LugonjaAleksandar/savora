part of 'random_meal_cubit.dart';

sealed class RandomMealState extends Equatable {
  const RandomMealState();

  @override
  List<Object?> get props => <Object?>[];
}

final class RandomMealIdle extends RandomMealState {
  const RandomMealIdle();
}

final class RandomMealLoading extends RandomMealState {
  const RandomMealLoading();
}

/// One-shot: the UI navigates on this state via a `BlocListener`.
final class RandomMealReady extends RandomMealState {
  final MealSummary meal;

  const RandomMealReady(this.meal);

  @override
  List<Object?> get props => <Object?>[meal];
}

final class RandomMealError extends RandomMealState {
  final AppFailure failure;

  const RandomMealError(this.failure);

  @override
  List<Object?> get props => <Object?>[failure];
}
