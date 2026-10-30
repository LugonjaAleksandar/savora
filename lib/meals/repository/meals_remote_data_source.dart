import 'package:savora/core/network/api_client.dart';
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/network/result.dart';

/// Raw TheMealDB endpoints. Returns decoded JSON so the repository decides
/// what to cache before mapping it to domain models.
class MealsRemoteDataSource {
  final ApiClient _apiClient;

  MealsRemoteDataSource({required this._apiClient});

  Future<Result<List<Map<String, dynamic>>>> fetchCategories() {
    return _apiClient.get('/categories.php', parser: (Map<String, dynamic> json) => _list(json, 'categories'));
  }

  Future<Result<List<Map<String, dynamic>>>> fetchMealsByCategory(String category) {
    return _apiClient.get(
      '/filter.php',
      query: <String, String>{'c': category},
      parser: (Map<String, dynamic> json) => _list(json, 'meals'),
    );
  }

  Future<Result<List<Map<String, dynamic>>>> searchMeals(String query) {
    return _apiClient.get('/search.php', query: <String, String>{'s': query}, parser: (Map<String, dynamic> json) => _list(json, 'meals'));
  }

  Future<Result<Map<String, dynamic>>> fetchMeal(String id) async {
    final Result<List<Map<String, dynamic>>> result = await _apiClient.get(
      '/lookup.php',
      query: <String, String>{'i': id},
      parser: (Map<String, dynamic> json) => _list(json, 'meals'),
    );
    return _firstOrNotFound(result);
  }

  Future<Result<Map<String, dynamic>>> fetchRandomMeal() async {
    final Result<List<Map<String, dynamic>>> result = await _apiClient.get(
      '/random.php',
      parser: (Map<String, dynamic> json) => _list(json, 'meals'),
    );
    return _firstOrNotFound(result);
  }

  /// TheMealDB answers "no results" with `{"meals": null}` rather than `[]`.
  static List<Map<String, dynamic>> _list(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is! List<dynamic>) {
      return const <Map<String, dynamic>>[];
    }
    return value.cast<Map<String, dynamic>>();
  }

  static Result<Map<String, dynamic>> _firstOrNotFound(Result<List<Map<String, dynamic>>> result) {
    return switch (result) {
      Success<List<Map<String, dynamic>>>(:final List<Map<String, dynamic>> data) when data.isNotEmpty => Success<Map<String, dynamic>>(
        data.first,
      ),
      Success<List<Map<String, dynamic>>>() => const Failure<Map<String, dynamic>>(NotFoundFailure()),
      Failure<List<Map<String, dynamic>>>(:final AppFailure failure) => Failure<Map<String, dynamic>>(failure),
    };
  }
}
