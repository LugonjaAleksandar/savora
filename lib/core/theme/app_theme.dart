import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savora/core/theme/app_colors.dart';

abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 20;
  static const double lg = 28;
  static const double xl = 36;
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  /// Bottom inset that keeps scrollable content clear of the floating nav bar.
  static const double navBarClearance = 120;
}

abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final TextTheme base = brightness == Brightness.dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    final TextTheme body = GoogleFonts.plusJakartaSansTextTheme(
      base,
    ).apply(bodyColor: colors.textPrimary, displayColor: colors.textPrimary);
    final TextTheme textTheme = body.copyWith(
      displaySmall: GoogleFonts.fraunces(textStyle: body.displaySmall, fontWeight: FontWeight.w600, height: 1.05, letterSpacing: -1),
      headlineMedium: GoogleFonts.fraunces(textStyle: body.headlineMedium, fontWeight: FontWeight.w600, height: 1.1, letterSpacing: -0.5),
      headlineSmall: GoogleFonts.fraunces(textStyle: body.headlineSmall, fontWeight: FontWeight.w600, letterSpacing: -0.3),
      titleLarge: body.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
      titleMedium: body.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      labelLarge: body.labelLarge?.copyWith(fontWeight: FontWeight.w700),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: brightness,
        primary: colors.primary,
        surface: colors.surface,
      ),
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: colors.background, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        showDragHandle: true,
        dragHandleColor: colors.textTertiary,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      extensions: <ThemeExtension<dynamic>>[colors],
    );
  }
}
