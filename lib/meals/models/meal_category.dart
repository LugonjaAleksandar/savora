import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_category.g.dart';

@JsonSerializable()
class MealCategory extends Equatable {
  @JsonKey(name: 'idCategory')
  final String id;
  @JsonKey(name: 'strCategory')
  final String name;
  @JsonKey(name: 'strCategoryThumb')
  final String thumbnailUrl;
  @JsonKey(name: 'strCategoryDescription', defaultValue: '')
  final String description;

  const MealCategory({required this.id, required this.name, required this.thumbnailUrl, required this.description});

  factory MealCategory.fromJson(Map<String, dynamic> json) => _$MealCategoryFromJson(json);

  @override
  List<Object?> get props => <Object?>[id, name, thumbnailUrl, description];

  Map<String, dynamic> toJson() => _$MealCategoryToJson(this);
}
