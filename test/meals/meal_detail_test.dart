import 'package:flutter_test/flutter_test.dart';
import 'package:savora/meals/models/ingredient.dart';
import 'package:savora/meals/models/meal_detail.dart';

import '../helpers/fixtures.dart';

void main() {
  group('MealDetail.fromJson', () {
    final MealDetail meal = MealDetail.fromJson(mealJson());

    test('collects only non-blank numbered ingredients', () {
      expect(meal.ingredients, const <Ingredient>[
        Ingredient(name: 'soy sauce', measure: '3/4 cup'),
        Ingredient(name: 'water', measure: ''),
      ]);
    });

    test('splits instructions into steps and drops "STEP n" headings', () {
      expect(meal.steps, <String>['Preheat oven.', 'Bake for 35 minutes.']);
    });

    test('parses tags and links', () {
      expect(meal.tags, <String>['Meat', 'Casserole']);
      expect(meal.hasVideo, isTrue);
      expect(meal.hasSource, isFalse);
    });
  });
}
