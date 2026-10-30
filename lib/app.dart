import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:savora/core/di/service_locator.dart';
import 'package:savora/core/router/app_router.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/favorites/bloc/favorites_cubit.dart';
import 'package:savora/localization.dart';
import 'package:savora/settings/bloc/settings_cubit.dart';

class SavoraApp extends StatefulWidget {
  const SavoraApp({super.key});

  @override
  State<SavoraApp> createState() => _SavoraAppState();
}

class _SavoraAppState extends State<SavoraApp> {
  // Created once so hot reload / rebuilds never reset the navigation stack.
  late final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(settingsRepository: sl())),
        BlocProvider<FavoritesCubit>(create: (_) => FavoritesCubit(favoritesRepository: sl())),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (BuildContext context, SettingsState settings) {
          return MaterialApp.router(
            onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.app_name,
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settings.themeMode,
            locale: settings.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
