import 'package:shared_preferences/shared_preferences.dart';

/// Storage abstraction the repositories depend on.
///
/// Repositories never touch [SharedPreferences] directly, so they can be unit
/// tested against `InMemoryKeyValueStorage` and the backend can be swapped
/// (Hive, secure storage, …) without touching feature code.
abstract interface class KeyValueStorage {
  String? readString(String key);

  Future<void> writeString(String key, String value);

  List<String>? readStringList(String key);

  Future<void> writeStringList(String key, List<String> value);

  Future<void> remove(String key);
}

class SharedPreferencesStorage implements KeyValueStorage {
  final SharedPreferencesWithCache _preferences;

  SharedPreferencesStorage(this._preferences);

  @override
  String? readString(String key) => _preferences.getString(key);

  @override
  Future<void> writeString(String key, String value) => _preferences.setString(key, value);

  @override
  List<String>? readStringList(String key) => _preferences.getStringList(key);

  @override
  Future<void> writeStringList(String key, List<String> value) => _preferences.setStringList(key, value);

  @override
  Future<void> remove(String key) => _preferences.remove(key);
}
