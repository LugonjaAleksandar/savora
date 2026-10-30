import 'dart:convert';

import 'package:savora/core/storage/key_value_storage.dart';
import 'package:savora/reviews/models/meal_review.dart';

abstract interface class ReviewsRepository {
  MealReview? getReview(String mealId);

  Future<void> saveReview(MealReview review);

  Future<void> deleteReview(String mealId);
}

/// Reviews live on-device only. Swapping this for a remote implementation
/// would not touch the cubit or the UI.
class LocalReviewsRepository implements ReviewsRepository {
  static const String _keyPrefix = 'review_';

  final KeyValueStorage _storage;

  LocalReviewsRepository({required this._storage});

  @override
  MealReview? getReview(String mealId) {
    final String? raw = _storage.readString('$_keyPrefix$mealId');
    if (raw == null) {
      return null;
    }
    try {
      return MealReview.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  @override
  Future<void> saveReview(MealReview review) {
    return _storage.writeString('$_keyPrefix${review.mealId}', jsonEncode(review.toJson()));
  }

  @override
  Future<void> deleteReview(String mealId) => _storage.remove('$_keyPrefix$mealId');
}
