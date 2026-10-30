part of 'meal_review_cubit.dart';

final class MealReviewState extends Equatable {
  final MealReview? review;

  const MealReviewState({this.review});

  @override
  List<Object?> get props => <Object?>[review];

  bool get hasReview => review != null;
}
