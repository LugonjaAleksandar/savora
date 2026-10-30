import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/network/result.dart';
import 'package:savora/meals/models/meal_category.dart';
import 'package:savora/meals/models/meal_detail.dart';
import 'package:savora/meals/models/meal_summary.dart';
import 'package:savora/meals/repository/meals_local_data_source.dart';
import 'package:savora/meals/repository/meals_remote_data_source.dart';
import 'package:savora/meals/repository/meals_repository.dart';

import '../helpers/fixtures.dart';
import '../helpers/in_memory_storage.dart';

class MockRemote extends Mock implements MealsRemoteDataSource {}

void main() {
  late MockRemote remote;
  late DateTime now;
  late MealsRepositoryImpl repository;

  setUp(() {
    remote = MockRemote();
    now = DateTime(2026, 10, 30);
    repository = MealsRepositoryImpl(
      remote: remote,
      local: MealsLocalDataSource(storage: InMemoryKeyValueStorage(), now: () => now),
    );
  });

  group('getCategories (cache-first)', () {
    setUp(() {
      when(
        () => remote.fetchCategories(),
      ).thenAnswer((_) async => Success<List<Map<String, dynamic>>>(<Map<String, dynamic>>[beef.toJson()]));
    });

    test('serves the cached copy within the TTL', () async {
      await repository.getCategories();
      final Result<List<MealCategory>> second = await repository.getCategories();

      expect((second as Success<List<MealCategory>>).data, <MealCategory>[beef]);
      verify(() => remote.fetchCategories()).called(1);
    });

    test('refetches once the TTL expires', () async {
      await repository.getCategories();
      now = now.add(MealsRepositoryImpl.categoriesTtl + const Duration(minutes: 1));
      await repository.getCategories();

      verify(() => remote.fetchCategories()).called(2);
    });
  });

  group('getMealsByCategory (network-first)', () {
    test('falls back to stale cache when offline', () async {
      when(
        () => remote.fetchMealsByCategory('Beef'),
      ).thenAnswer((_) async => Success<List<Map<String, dynamic>>>(<Map<String, dynamic>>[wellington.toJson()]));
      await repository.getMealsByCategory('Beef');

      when(() => remote.fetchMealsByCategory('Beef')).thenAnswer((_) async => const Failure<List<Map<String, dynamic>>>(NetworkFailure()));
      final Result<List<MealSummary>> offline = await repository.getMealsByCategory('Beef');

      expect((offline as Success<List<MealSummary>>).data, <MealSummary>[wellington]);
    });

    test('surfaces non-network failures even when cached', () async {
      when(
        () => remote.fetchMealsByCategory('Beef'),
      ).thenAnswer((_) async => Success<List<Map<String, dynamic>>>(<Map<String, dynamic>>[wellington.toJson()]));
      await repository.getMealsByCategory('Beef');
      when(
        () => remote.fetchMealsByCategory('Beef'),
      ).thenAnswer((_) async => const Failure<List<Map<String, dynamic>>>(ServerFailure(500)));

      expect(await repository.getMealsByCategory('Beef'), isA<Failure<List<MealSummary>>>());
    });
  });

  test('getRandomMeal warms the detail cache', () async {
    when(() => remote.fetchRandomMeal()).thenAnswer((_) async => Success<Map<String, dynamic>>(mealJson(id: '42')));

    await repository.getRandomMeal();
    final Result<MealDetail> detail = await repository.getMeal('42');

    expect((detail as Success<MealDetail>).data.id, '42');
    verifyNever(() => remote.fetchMeal(any()));
  });
}
