import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savora/settings/repository/settings_repository.dart';

import '../helpers/in_memory_storage.dart';

void main() {
  late LocalSettingsRepository repository;

  setUp(() => repository = LocalSettingsRepository(storage: InMemoryKeyValueStorage()));

  test('first launch defaults to English', () {
    expect(repository.locale, const Locale('en'));
  });

  test('choosing "System" is remembered instead of falling back to English', () async {
    await repository.setLocale(null);
    expect(repository.locale, isNull);
  });

  test('a chosen language is persisted', () async {
    await repository.setLocale(const Locale('sr'));
    expect(repository.locale, const Locale('sr'));
  });
}
