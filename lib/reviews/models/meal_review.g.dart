// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealReview _$MealReviewFromJson(Map<String, dynamic> json) => MealReview(
  mealId: json['mealId'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MealReviewToJson(MealReview instance) => <String, dynamic>{
  'mealId': instance.mealId,
  'rating': instance.rating,
  'comment': instance.comment,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
