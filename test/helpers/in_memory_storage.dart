import 'package:savora/core/storage/key_value_storage.dart';

class InMemoryKeyValueStorage implements KeyValueStorage {
  final Map<String, Object> values = <String, Object>{};

  @override
  String? readString(String key) => values[key] as String?;

  @override
  Future<void> writeString(String key, String value) async => values[key] = value;

  @override
  List<String>? readStringList(String key) => values[key] as List<String>?;

  @override
  Future<void> writeStringList(String key, List<String> value) async => values[key] = value;

  @override
  Future<void> remove(String key) async => values.remove(key);
}
