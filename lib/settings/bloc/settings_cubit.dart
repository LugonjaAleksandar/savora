import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/settings/repository/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsCubit({required this._settingsRepository})
    : super(SettingsState(themeMode: _settingsRepository.themeMode, locale: _settingsRepository.locale));

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(SettingsState(themeMode: mode, locale: state.locale));
    await _settingsRepository.setThemeMode(mode);
  }

  Future<void> setLocale(Locale? locale) async {
    emit(SettingsState(themeMode: state.themeMode, locale: locale));
    await _settingsRepository.setLocale(locale);
  }
}
