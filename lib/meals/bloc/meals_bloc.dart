import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/network/result.dart';
import 'package:savora/meals/models/meal_category.dart';
import 'package:savora/meals/models/meal_summary.dart';
import 'package:savora/meals/repository/meals_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'meals_event.dart';
part 'meals_state.dart';

/// Bloc (rather than Cubit) because this screen benefits from event
/// transformers: search input is debounced and every load is `restartable`,
/// so a stale response can never overwrite a newer selection.
class MealsBloc extends Bloc<MealsEvent, MealsState> {
  static const Duration searchDebounce = Duration(milliseconds: 350);

  final MealsRepository _mealsRepository;

  MealsBloc({required this._mealsRepository}) : super(const MealsState()) {
    on<MealsStarted>(_onStarted, transformer: droppable());
    on<MealsCategorySelected>(_onCategorySelected, transformer: restartable());
    on<MealsSearchChanged>(_onSearchChanged, transformer: _debounceRestartable(searchDebounce));
    on<MealsRefreshed>(_onRefreshed, transformer: droppable());
  }

  Future<void> _onStarted(MealsStarted event, Emitter<MealsState> emit) async {
    emit(state.copyWith(status: MealsStatus.loading));
    await _loadCategoriesAndMeals(emit, forceRefresh: false);
  }

  Future<void> _onRefreshed(MealsRefreshed event, Emitter<MealsState> emit) async {
    if (state.isSearching) {
      return _search(state.query, emit);
    }
    if (state.categories.isEmpty) {
      emit(state.copyWith(status: MealsStatus.loading));
      return _loadCategoriesAndMeals(emit, forceRefresh: true);
    }
    return _loadCategory(state.selectedCategory!, emit);
  }

  Future<void> _onCategorySelected(MealsCategorySelected event, Emitter<MealsState> emit) async {
    if (event.category == state.selectedCategory && state.isSearching == false && state.status == MealsStatus.success) {
      return;
    }
    emit(state.copyWith(status: MealsStatus.loading, selectedCategory: event.category, query: ''));
    await _loadCategory(event.category, emit);
  }

  Future<void> _onSearchChanged(MealsSearchChanged event, Emitter<MealsState> emit) async {
    final String query = event.query.trim();
    if (query == state.query) {
      return;
    }
    if (query.isEmpty) {
      emit(state.copyWith(status: MealsStatus.loading, query: ''));
      return state.selectedCategory == null ? null : _loadCategory(state.selectedCategory!, emit);
    }
    emit(state.copyWith(status: MealsStatus.loading, query: query));
    await _search(query, emit);
  }

  Future<void> _loadCategoriesAndMeals(Emitter<MealsState> emit, {required bool forceRefresh}) async {
    final Result<List<MealCategory>> result = await _mealsRepository.getCategories(forceRefresh: forceRefresh);
    switch (result) {
      case Success<List<MealCategory>>(:final List<MealCategory> data) when data.isNotEmpty:
        final MealCategory selected = state.selectedCategory ?? data.first;
        emit(state.copyWith(categories: data, selectedCategory: selected));
        await _loadCategory(selected, emit);
      case Success<List<MealCategory>>():
        emit(state.copyWith(status: MealsStatus.success, categories: const <MealCategory>[], meals: const <MealSummary>[]));
      case Failure<List<MealCategory>>(:final AppFailure failure):
        emit(state.copyWith(status: MealsStatus.failure, failure: failure));
    }
  }

  Future<void> _loadCategory(MealCategory category, Emitter<MealsState> emit) async {
    _emitResult(await _mealsRepository.getMealsByCategory(category.name), emit);
  }

  Future<void> _search(String query, Emitter<MealsState> emit) async {
    _emitResult(await _mealsRepository.searchMeals(query), emit);
  }

  void _emitResult(Result<List<MealSummary>> result, Emitter<MealsState> emit) {
    switch (result) {
      case Success<List<MealSummary>>(:final List<MealSummary> data):
        emit(state.copyWith(status: MealsStatus.success, meals: data));
      case Failure<List<MealSummary>>(:final AppFailure failure):
        emit(state.copyWith(status: MealsStatus.failure, failure: failure));
    }
  }

  static EventTransformer<E> _debounceRestartable<E>(Duration duration) {
    return (Stream<E> events, EventMapper<E> mapper) => restartable<E>().call(events.debounce(duration), mapper);
  }
}
