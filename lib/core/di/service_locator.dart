import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:savora/core/app_config.dart';
import 'package:savora/core/network/api_client.dart';
import 'package:savora/core/storage/key_value_storage.dart';
import 'package:savora/favorites/repository/favorites_repository.dart';
import 'package:savora/meals/repository/meals_local_data_source.dart';
import 'package:savora/meals/repository/meals_remote_data_source.dart';
import 'package:savora/meals/repository/meals_repository.dart';
import 'package:savora/reviews/repository/reviews_repository.dart';
import 'package:savora/settings/repository/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

/// Composition root — the only place that knows concrete implementations.
///
/// Everything else receives its dependencies through the constructor, so no
/// class calls `GetIt` internally and every class can be built in a test with
/// fakes. Cubits/Blocs are *not* registered here: their lifetime belongs to
/// the widget tree (`BlocProvider`), not to a global container.
Future<void> configureDependencies() async {
  final SharedPreferencesWithCache preferences = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );

  sl
    ..registerSingleton<KeyValueStorage>(SharedPreferencesStorage(preferences))
    ..registerLazySingleton<http.Client>(http.Client.new, dispose: (http.Client client) => client.close())
    ..registerLazySingleton<ApiClient>(() => ApiClient(httpClient: sl(), baseUrl: AppConfig.mealDbBaseUrl))
    ..registerLazySingleton<MealsRepository>(
      () => MealsRepositoryImpl(
        remote: MealsRemoteDataSource(apiClient: sl()),
        local: MealsLocalDataSource(storage: sl()),
      ),
    )
    ..registerLazySingleton<ReviewsRepository>(() => LocalReviewsRepository(storage: sl()))
    ..registerLazySingleton<FavoritesRepository>(() => LocalFavoritesRepository(storage: sl()))
    ..registerLazySingleton<SettingsRepository>(() => LocalSettingsRepository(storage: sl()));
}
