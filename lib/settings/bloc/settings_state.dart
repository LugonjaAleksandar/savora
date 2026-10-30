part of 'settings_cubit.dart';

final class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale? locale;

  const SettingsState({required this.themeMode, required this.locale});

  @override
  List<Object?> get props => <Object?>[themeMode, locale];
}
