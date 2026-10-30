import 'dart:convert';

import 'package:savora/core/storage/key_value_storage.dart';
import 'package:savora/meals/models/meal_summary.dart';

abstract interface class FavoritesRepository {
  List<MealSummary> getFavorites();

  Future<void> saveFavorites(List<MealSummary> favorites);
}

/// Stores the full [MealSummary] (not just the id) so the Saved tab renders
/// instantly and offline, without a network round-trip per item.
class LocalFavoritesRepository implements FavoritesRepository {
  static const String _key = 'favorites';

  final KeyValueStorage _storage;

  LocalFavoritesRepository({required this._storage});

  @override
  List<MealSummary> getFavorites() {
    final List<String> raw = _storage.readStringList(_key) ?? const <String>[];
    return <MealSummary>[
      for (final String item in raw)
        if (_decode(item) case final MealSummary meal) meal,
    ];
  }

  @override
  Future<void> saveFavorites(List<MealSummary> favorites) {
    return _storage.writeStringList(_key, favorites.map((MealSummary meal) => jsonEncode(meal.toJson())).toList());
  }

  static MealSummary? _decode(String raw) {
    try {
      return MealSummary.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }
}
