abstract final class AppConfig {
  /// Free public test key (`1`) — TheMealDB needs no sign-up for it.
  static const String mealDbBaseUrl = String.fromEnvironment('MEALDB_BASE_URL', defaultValue: 'https://www.themealdb.com/api/json/v1/1');
}
