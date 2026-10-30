import 'package:equatable/equatable.dart';
import 'package:savora/meals/models/ingredient.dart';
import 'package:savora/meals/models/meal_summary.dart';

class MealDetail extends Equatable {
  /// TheMealDB flattens ingredients into `strIngredient1..20` / `strMeasure1..20`.
  static const int _maxIngredients = 20;
  static final RegExp _stepHeading = RegExp(r'^(step\s*\d+|\d+\.?)$', caseSensitive: false);

  final String id;
  final String name;
  final String thumbnailUrl;
  final String? category;
  final String? area;
  final String instructions;
  final List<Ingredient> ingredients;
  final List<String> tags;
  final Uri? youtubeUrl;
  final Uri? sourceUrl;

  const MealDetail({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.category,
    required this.area,
    required this.instructions,
    required this.ingredients,
    required this.tags,
    required this.youtubeUrl,
    required this.sourceUrl,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final List<Ingredient> ingredients = <Ingredient>[
      for (int index = 1; index <= _maxIngredients; index++)
        if (_nonBlank(json['strIngredient$index']) case final String name)
          Ingredient(name: name, measure: _nonBlank(json['strMeasure$index']) ?? ''),
    ];

    return MealDetail(
      id: json['idMeal'] as String,
      name: (json['strMeal'] as String).trim(),
      thumbnailUrl: json['strMealThumb'] as String,
      category: _nonBlank(json['strCategory']),
      area: _nonBlank(json['strArea']),
      instructions: _nonBlank(json['strInstructions']) ?? '',
      ingredients: ingredients,
      tags: (_nonBlank(json['strTags']) ?? '').split(',').map((String tag) => tag.trim()).where((String tag) => tag.isNotEmpty).toList(),
      youtubeUrl: Uri.tryParse(_nonBlank(json['strYoutube']) ?? ''),
      sourceUrl: Uri.tryParse(_nonBlank(json['strSource']) ?? ''),
    );
  }

  @override
  List<Object?> get props => <Object?>[id, name, thumbnailUrl, category, area, instructions, ingredients, tags, youtubeUrl, sourceUrl];

  MealSummary toSummary() => MealSummary(id: id, name: name, thumbnailUrl: thumbnailUrl);

  static String? _nonBlank(Object? value) {
    if (value is! String) {
      return null;
    }
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Instructions split into readable steps, dropping the "STEP 1" style
  /// heading lines some recipes include.
  List<String> get steps {
    return instructions.split(RegExp(r'\r?\n')).map((String line) => line.trim()).where((String line) {
      final bool isHeading = _stepHeading.hasMatch(line);
      return line.isNotEmpty && isHeading == false;
    }).toList();
  }

  bool get hasVideo => youtubeUrl?.hasAuthority ?? false;

  bool get hasSource => sourceUrl?.hasAuthority ?? false;
}
