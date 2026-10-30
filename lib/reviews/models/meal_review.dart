import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_review.g.dart';

@JsonSerializable()
class MealReview extends Equatable {
  final String mealId;
  final int rating;
  final String comment;
  final DateTime updatedAt;

  const MealReview({required this.mealId, required this.rating, required this.comment, required this.updatedAt})
    : assert(rating >= 1 && rating <= 5, 'Rating must be between 1 and 5');

  factory MealReview.fromJson(Map<String, dynamic> json) => _$MealReviewFromJson(json);

  @override
  List<Object?> get props => <Object?>[mealId, rating, comment, updatedAt];

  Map<String, dynamic> toJson() => _$MealReviewToJson(this);
}
