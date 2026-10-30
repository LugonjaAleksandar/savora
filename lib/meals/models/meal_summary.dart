import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_summary.g.dart';

/// Lightweight meal used by lists, favorites and as the hero placeholder
/// while [MealDetail] loads.
@JsonSerializable()
class MealSummary extends Equatable {
  @JsonKey(name: 'idMeal')
  final String id;
  @JsonKey(name: 'strMeal')
  final String name;
  @JsonKey(name: 'strMealThumb')
  final String thumbnailUrl;

  const MealSummary({required this.id, required this.name, required this.thumbnailUrl});

  factory MealSummary.fromJson(Map<String, dynamic> json) => _$MealSummaryFromJson(json);

  @override
  List<Object?> get props => <Object?>[id, name, thumbnailUrl];

  Map<String, dynamic> toJson() => _$MealSummaryToJson(this);

  /// TheMealDB serves resized variants at `/medium` — several times lighter for grids.
  String get previewUrl => '$thumbnailUrl/medium';
}
