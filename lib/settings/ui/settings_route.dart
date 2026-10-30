import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/glass_container.dart';
import 'package:savora/core/widgets/glow_background.dart';
import 'package:savora/core/widgets/sliding_selector.dart';
import 'package:savora/localization.dart';
import 'package:savora/settings/bloc/settings_cubit.dart';

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsState settings = context.watch<SettingsCubit>().state;
    final SettingsCubit cubit = context.read<SettingsCubit>();

    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.navBarClearance),
            children: <Widget>[
              Text(AppLocalizations.of(context)!.settings_title, style: context.textTheme.displaySmall),
              const SizedBox(height: AppSpacing.xl),
              _SettingsGroup(
                title: AppLocalizations.of(context)!.settings_theme,
                child: _OptionSelector<ThemeMode>(
                  selected: settings.themeMode,
                  onSelected: cubit.setThemeMode,
                  options: <_Option<ThemeMode>>[
                    _Option<ThemeMode>(
                      ThemeMode.system,
                      AppLocalizations.of(context)!.settings_theme_system,
                      Icons.brightness_auto_rounded,
                    ),
                    _Option<ThemeMode>(ThemeMode.light, AppLocalizations.of(context)!.settings_theme_light, Icons.light_mode_rounded),
                    _Option<ThemeMode>(ThemeMode.dark, AppLocalizations.of(context)!.settings_theme_dark, Icons.dark_mode_rounded),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SettingsGroup(
                title: AppLocalizations.of(context)!.settings_language,
                child: _OptionSelector<Locale?>(
                  selected: settings.locale,
                  onSelected: cubit.setLocale,
                  options: <_Option<Locale?>>[
                    _Option<Locale?>(null, AppLocalizations.of(context)!.settings_language_system, Icons.language_rounded),
                    for (final Locale locale in AppLocalizations.supportedLocales)
                      _Option<Locale?>(locale, _languageName(locale), Icons.translate_rounded),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SettingsGroup(
                title: AppLocalizations.of(context)!.settings_about,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    AppLocalizations.of(context)!.settings_about_body,
                    style: context.textTheme.bodyMedium?.copyWith(color: context.colors.textSecondary, height: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Native names on purpose: a language should be recognisable in itself.
  static String _languageName(Locale locale) {
    return switch (locale.languageCode) {
      'sr' => 'Srpski',
      'en' => 'English',
      _ => locale.languageCode,
    };
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsGroup({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(
            title.toUpperCase(),
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colors.textTertiary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        GlassContainer(borderRadius: BorderRadius.circular(AppRadius.lg), padding: const EdgeInsets.all(6), child: child),
      ],
    );
  }
}

class _Option<T> {
  final T value;
  final String label;
  final IconData icon;

  const _Option(this.value, this.label, this.icon);
}

class _OptionSelector<T> extends StatelessWidget {
  final List<_Option<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  const _OptionSelector({required this.options, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SlidingSelector(
      itemCount: options.length,
      selectedIndex: options.indexWhere((_Option<T> option) => option.value == selected),
      onSelected: (int index) => onSelected(options[index].value),
      height: 76,
      thumbRadius: BorderRadius.circular(AppRadius.md),
      itemBuilder: (BuildContext context, int index, double selectedness) {
        final _Option<T> option = options[index];
        final Color color = Color.lerp(context.colors.textSecondary, Colors.white, selectedness)!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.scale(
              scale: 1 + 0.12 * selectedness,
              child: Icon(option.icon, color: color),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelLarge?.copyWith(color: Color.lerp(context.colors.textPrimary, Colors.white, selectedness)),
            ),
          ],
        );
      },
    );
  }
}
