import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/network/result.dart';
import 'package:savora/meals/models/meal_detail.dart';
import 'package:savora/meals/repository/meals_repository.dart';

part 'meal_detail_state.dart';

class MealDetailCubit extends Cubit<MealDetailState> {
  final MealsRepository _mealsRepository;
  final String mealId;

  MealDetailCubit({required this._mealsRepository, required this.mealId}) : super(const MealDetailLoading());

  Future<void> load() async {
    emit(const MealDetailLoading());
    final Result<MealDetail> result = await _mealsRepository.getMeal(mealId);
    if (isClosed) {
      return;
    }
    emit(switch (result) {
      Success<MealDetail>(:final MealDetail data) => MealDetailLoaded(data),
      Failure<MealDetail>(:final AppFailure failure) => MealDetailError(failure),
    });
  }
}
