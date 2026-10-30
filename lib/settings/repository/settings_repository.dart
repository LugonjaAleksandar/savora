import 'package:flutter/material.dart';
import 'package:savora/core/storage/key_value_storage.dart';

abstract interface class SettingsRepository {
  Future<void> setThemeMode(ThemeMode mode);

  Future<void> setLocale(Locale? locale);

  ThemeMode get themeMode;

  /// `null` means "follow the system language". Defaults to English until the
  /// user picks something, so the first launch looks the same on every device.
  Locale? get locale;
}

class LocalSettingsRepository implements SettingsRepository {
  static const String _themeModeKey = 'settings_theme_mode';
  static const String _localeKey = 'settings_locale';
  static const String _systemLocale = 'system';
  static const Locale _defaultLocale = Locale('en');

  final KeyValueStorage _storage;

  LocalSettingsRepository({required this._storage});

  @override
  Future<void> setThemeMode(ThemeMode mode) => _storage.writeString(_themeModeKey, mode.name);

  @override
  Future<void> setLocale(Locale? locale) {
    return _storage.writeString(_localeKey, locale?.languageCode ?? _systemLocale);
  }

  @override
  ThemeMode get themeMode {
    final String? stored = _storage.readString(_themeModeKey);
    return ThemeMode.values.firstWhere((ThemeMode mode) => mode.name == stored, orElse: () => ThemeMode.system);
  }

  @override
  Locale? get locale {
    return switch (_storage.readString(_localeKey)) {
      null => _defaultLocale,
      _systemLocale => null,
      final String code => Locale(code),
    };
  }
}
