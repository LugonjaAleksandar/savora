import 'package:savora/meals/models/meal_category.dart';
import 'package:savora/meals/models/meal_summary.dart';

const MealCategory beef = MealCategory(id: '1', name: 'Beef', thumbnailUrl: 'https://img/beef.png', description: '');
const MealCategory seafood = MealCategory(id: '2', name: 'Seafood', thumbnailUrl: 'https://img/seafood.png', description: '');

const MealSummary wellington = MealSummary(id: '52803', name: 'Beef Wellington', thumbnailUrl: 'https://img/wellington.jpg');
const MealSummary paella = MealSummary(id: '52836', name: 'Seafood Paella', thumbnailUrl: 'https://img/paella.jpg');

Map<String, dynamic> mealJson({String id = '52772', String name = 'Teriyaki Chicken Casserole'}) {
  return <String, dynamic>{
    'idMeal': id,
    'strMeal': name,
    'strMealThumb': 'https://img/$id.jpg',
    'strCategory': 'Chicken',
    'strArea': 'Japanese',
    'strInstructions': 'STEP 1\r\nPreheat oven.\r\n\r\nSTEP 2\r\nBake for 35 minutes.',
    'strTags': 'Meat, Casserole',
    'strYoutube': 'https://www.youtube.com/watch?v=4aZr5hZXP_s',
    'strSource': '',
    'strIngredient1': 'soy sauce',
    'strMeasure1': '3/4 cup',
    'strIngredient2': 'water',
    'strMeasure2': ' ',
    'strIngredient3': '',
    'strMeasure3': '',
    'strIngredient4': null,
  };
}
