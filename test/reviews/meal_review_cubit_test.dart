import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savora/reviews/bloc/meal_review_cubit.dart';
import 'package:savora/reviews/models/meal_review.dart';
import 'package:savora/reviews/repository/reviews_repository.dart';

import '../helpers/in_memory_storage.dart';

void main() {
  final DateTime now = DateTime(2026, 10, 30, 19);
  late LocalReviewsRepository repository;

  setUp(() => repository = LocalReviewsRepository(storage: InMemoryKeyValueStorage()));

  MealReviewCubit buildCubit() => MealReviewCubit(reviewsRepository: repository, mealId: '1', now: () => now);

  blocTest<MealReviewCubit, MealReviewState>(
    'saves a trimmed review and persists it',
    build: buildCubit,
    act: (MealReviewCubit cubit) => cubit.save(rating: 5, comment: '  Add more garlic  '),
    expect: () => <MealReviewState>[
      MealReviewState(
        review: MealReview(mealId: '1', rating: 5, comment: 'Add more garlic', updatedAt: now),
      ),
    ],
    verify: (_) => expect(repository.getReview('1')?.rating, 5),
  );

  test('restores a persisted review on creation', () async {
    await repository.saveReview(MealReview(mealId: '1', rating: 3, comment: '', updatedAt: now));
    expect(buildCubit().state.review?.rating, 3);
  });

  blocTest<MealReviewCubit, MealReviewState>(
    'delete clears state and storage',
    setUp: () => repository.saveReview(MealReview(mealId: '1', rating: 4, comment: 'ok', updatedAt: now)),
    build: buildCubit,
    act: (MealReviewCubit cubit) => cubit.delete(),
    expect: () => <MealReviewState>[const MealReviewState()],
    verify: (_) => expect(repository.getReview('1'), isNull),
  );
}
