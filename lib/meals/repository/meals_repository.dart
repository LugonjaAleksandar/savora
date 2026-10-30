import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/network/result.dart';
import 'package:savora/meals/models/meal_category.dart';
import 'package:savora/meals/models/meal_detail.dart';
import 'package:savora/meals/models/meal_summary.dart';
import 'package:savora/meals/repository/meals_local_data_source.dart';
import 'package:savora/meals/repository/meals_remote_data_source.dart';

abstract interface class MealsRepository {
  Future<Result<List<MealCategory>>> getCategories({bool forceRefresh = false});

  Future<Result<List<MealSummary>>> getMealsByCategory(String category);

  Future<Result<List<MealSummary>>> searchMeals(String query);

  Future<Result<MealDetail>> getMeal(String id);

  Future<Result<MealDetail>> getRandomMeal();
}

/// Caching strategy:
/// * categories and meal details change rarely → **cache-first** with a TTL;
/// * category listings → **network-first**, falling back to the last cached copy when offline;
/// * search → network only (results are cheap and query-specific).
class MealsRepositoryImpl implements MealsRepository {
  static const Duration categoriesTtl = Duration(days: 1);
  static const Duration mealDetailTtl = Duration(days: 7);

  final MealsRemoteDataSource _remote;
  final MealsLocalDataSource _local;

  MealsRepositoryImpl({required this._remote, required this._local});

  @override
  Future<Result<List<MealCategory>>> getCategories({bool forceRefresh = false}) async {
    const String key = 'categories';
    if (forceRefresh == false) {
      final List<dynamic>? cached = _local.read<List<dynamic>>(key, maxAge: categoriesTtl);
      if (cached != null) {
        return Success<List<MealCategory>>(_mapCategories(cached));
      }
    }
    final Result<List<Map<String, dynamic>>> result = await _remote.fetchCategories();
    return _cacheOrFallback(key, result, _mapCategories);
  }

  @override
  Future<Result<List<MealSummary>>> getMealsByCategory(String category) async {
    final Result<List<Map<String, dynamic>>> result = await _remote.fetchMealsByCategory(category);
    return _cacheOrFallback('category_$category', result, _mapSummaries);
  }

  @override
  Future<Result<List<MealSummary>>> searchMeals(String query) async {
    final Result<List<Map<String, dynamic>>> result = await _remote.searchMeals(query);
    return result.map(_mapSummaries);
  }

  @override
  Future<Result<MealDetail>> getMeal(String id) async {
    final String key = 'meal_$id';
    final Map<String, dynamic>? cached = _local.read<Map<String, dynamic>>(key, maxAge: mealDetailTtl);
    if (cached != null) {
      return Success<MealDetail>(MealDetail.fromJson(cached));
    }
    final Result<Map<String, dynamic>> result = await _remote.fetchMeal(id);
    return _cacheOrFallback(key, result, _mapDetail);
  }

  @override
  Future<Result<MealDetail>> getRandomMeal() async {
    final Result<Map<String, dynamic>> result = await _remote.fetchRandomMeal();
    if (result case Success<Map<String, dynamic>>(:final Map<String, dynamic> data)) {
      await _local.write('meal_${data['idMeal']}', data);
    }
    return result.map(_mapDetail);
  }

  /// On success persists the raw JSON; on a network failure serves whatever
  /// is cached (ignoring TTL) so the app stays usable offline.
  Future<Result<T>> _cacheOrFallback<T>(String key, Result<Object> result, T Function(Object json) mapper) async {
    switch (result) {
      case Success<Object>(:final Object data):
        await _local.write(key, data);
        return Success<T>(mapper(data));
      case Failure<Object>(:final AppFailure failure):
        final Object? stale = failure is NetworkFailure ? _local.read<Object>(key) : null;
        return stale != null ? Success<T>(mapper(stale)) : Failure<T>(failure);
    }
  }

  static List<MealCategory> _mapCategories(Object json) {
    return (json as List<dynamic>).cast<Map<String, dynamic>>().map(MealCategory.fromJson).toList();
  }

  static List<MealSummary> _mapSummaries(Object json) {
    return (json as List<dynamic>).cast<Map<String, dynamic>>().map(MealSummary.fromJson).toList();
  }

  static MealDetail _mapDetail(Object json) => MealDetail.fromJson(json as Map<String, dynamic>);
}
