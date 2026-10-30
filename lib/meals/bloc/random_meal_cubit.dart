import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/network/result.dart';
import 'package:savora/meals/models/meal_detail.dart';
import 'package:savora/meals/models/meal_summary.dart';
import 'package:savora/meals/repository/meals_repository.dart';

part 'random_meal_state.dart';

/// Powers "Surprise me". The repository caches the fetched detail, so the
/// detail screen opens instantly from cache after navigation.
class RandomMealCubit extends Cubit<RandomMealState> {
  final MealsRepository _mealsRepository;

  RandomMealCubit({required this._mealsRepository}) : super(const RandomMealIdle());

  Future<void> pick() async {
    if (state is RandomMealLoading) {
      return;
    }
    emit(const RandomMealLoading());
    final Result<MealDetail> result = await _mealsRepository.getRandomMeal();
    if (isClosed) {
      return;
    }
    emit(switch (result) {
      Success<MealDetail>(:final MealDetail data) => RandomMealReady(data.toSummary()),
      Failure<MealDetail>(:final AppFailure failure) => RandomMealError(failure),
    });
    emit(const RandomMealIdle());
  }
}
