import 'dart:convert';

import 'package:savora/core/storage/key_value_storage.dart';

/// JSON cache with per-entry timestamps, backed by [KeyValueStorage].
class MealsLocalDataSource {
  static const String _prefix = 'meals_cache_';

  final KeyValueStorage _storage;
  final DateTime Function() _now;

  MealsLocalDataSource({required this._storage, DateTime Function()? now}) : _now = now ?? DateTime.now;

  Future<void> write(String key, Object json) {
    final String encoded = jsonEncode(<String, Object>{'savedAt': _now().millisecondsSinceEpoch, 'data': json});
    return _storage.writeString('$_prefix$key', encoded);
  }

  /// Returns cached data, or `null` when missing, corrupt or older than [maxAge].
  /// Pass `maxAge: null` to accept stale data (offline fallback).
  T? read<T>(String key, {Duration? maxAge}) {
    final String? raw = _storage.readString('$_prefix$key');
    if (raw == null) {
      return null;
    }
    try {
      final Map<String, dynamic> entry = jsonDecode(raw) as Map<String, dynamic>;
      final DateTime savedAt = DateTime.fromMillisecondsSinceEpoch(entry['savedAt'] as int);
      if (maxAge != null && _now().difference(savedAt) > maxAge) {
        return null;
      }
      return entry['data'] as T;
    } on Object {
      _storage.remove('$_prefix$key');
      return null;
    }
  }
}
