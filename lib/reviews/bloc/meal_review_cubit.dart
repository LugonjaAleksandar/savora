import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/reviews/models/meal_review.dart';
import 'package:savora/reviews/repository/reviews_repository.dart';

part 'meal_review_state.dart';

class MealReviewCubit extends Cubit<MealReviewState> {
  final ReviewsRepository _reviewsRepository;
  final String mealId;
  final DateTime Function() _now;

  MealReviewCubit({required this._reviewsRepository, required this.mealId, DateTime Function()? now})
    : _now = now ?? DateTime.now,
      super(MealReviewState(review: _reviewsRepository.getReview(mealId)));

  Future<void> save({required int rating, required String comment}) async {
    final MealReview review = MealReview(mealId: mealId, rating: rating, comment: comment.trim(), updatedAt: _now());
    await _reviewsRepository.saveReview(review);
    emit(MealReviewState(review: review));
  }

  Future<void> delete() async {
    await _reviewsRepository.deleteReview(mealId);
    emit(const MealReviewState());
  }
}
