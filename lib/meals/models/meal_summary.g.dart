// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealSummary _$MealSummaryFromJson(Map<String, dynamic> json) =>
    MealSummary(id: json['idMeal'] as String, name: json['strMeal'] as String, thumbnailUrl: json['strMealThumb'] as String);

Map<String, dynamic> _$MealSummaryToJson(MealSummary instance) => <String, dynamic>{
  'idMeal': instance.id,
  'strMeal': instance.name,
  'strMealThumb': instance.thumbnailUrl,
};
