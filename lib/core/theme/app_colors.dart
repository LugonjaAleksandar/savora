import 'package:flutter/material.dart';

/// Savora design tokens, themed for light/dark.
///
/// Registered on [ThemeData.extensions] so widgets read colors through
/// [AppColors.of] instead of hard-coded constants.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  static const AppColors light = AppColors(
    background: Color(0xFFFFF7F2),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFEEE5),
    glass: Color(0xB3FFFFFF),
    glassStroke: Color(0x66FFFFFF),
    stroke: Color(0xFFF1DED4),
    textPrimary: Color(0xFF22141F),
    textSecondary: Color(0xFF6E5A66),
    textTertiary: Color(0xFFA8949E),
    primary: Color(0xFFFF5A47),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFFFB13D),
    star: Color(0xFFFFB13D),
    danger: Color(0xFFE5484D),
    shadow: Color(0x1F7A2E1F),
    brandGradient: <Color>[Color(0xFFFF8A3D), Color(0xFFFF4D6D)],
    backgroundGlow: <Color>[Color(0x33FFB13D), Color(0x26FF4D6D)],
  );

  static const AppColors dark = AppColors(
    background: Color(0xFF130E17),
    surface: Color(0xFF1E1724),
    surfaceRaised: Color(0xFF2A2131),
    glass: Color(0x8C1E1724),
    glassStroke: Color(0x1FFFFFFF),
    stroke: Color(0xFF332A3A),
    textPrimary: Color(0xFFFBF3EE),
    textSecondary: Color(0xFFBBAAB6),
    textTertiary: Color(0xFF7D6D79),
    primary: Color(0xFFFF6B57),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFFFC15C),
    star: Color(0xFFFFC15C),
    danger: Color(0xFFFF6369),
    shadow: Color(0x66000000),
    brandGradient: <Color>[Color(0xFFFF8A3D), Color(0xFFFF4D6D)],
    backgroundGlow: <Color>[Color(0x29FF8A3D), Color(0x2E9B5CFF)],
  );

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color glass;
  final Color glassStroke;
  final Color stroke;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color primary;
  final Color onPrimary;
  final Color accent;
  final Color star;
  final Color danger;
  final Color shadow;
  final List<Color> brandGradient;
  final List<Color> backgroundGlow;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.glass,
    required this.glassStroke,
    required this.stroke,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.star,
    required this.danger,
    required this.shadow,
    required this.brandGradient,
    required this.backgroundGlow,
  });

  @override
  AppColors copyWith({Color? background, Color? surface, Color? primary, Color? accent}) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised,
      glass: glass,
      glassStroke: glassStroke,
      stroke: stroke,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      textTertiary: textTertiary,
      primary: primary ?? this.primary,
      onPrimary: onPrimary,
      accent: accent ?? this.accent,
      star: star,
      danger: danger,
      shadow: shadow,
      brandGradient: brandGradient,
      backgroundGlow: backgroundGlow,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) {
      return this;
    }
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    List<Color> mixAll(List<Color> a, List<Color> b) => <Color>[for (int i = 0; i < a.length; i++) mix(a[i], b[i])];
    return AppColors(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceRaised: mix(surfaceRaised, other.surfaceRaised),
      glass: mix(glass, other.glass),
      glassStroke: mix(glassStroke, other.glassStroke),
      stroke: mix(stroke, other.stroke),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textTertiary: mix(textTertiary, other.textTertiary),
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      accent: mix(accent, other.accent),
      star: mix(star, other.star),
      danger: mix(danger, other.danger),
      shadow: mix(shadow, other.shadow),
      brandGradient: mixAll(brandGradient, other.brandGradient),
      backgroundGlow: mixAll(backgroundGlow, other.backgroundGlow),
    );
  }

  static AppColors of(BuildContext context) => Theme.of(context).extension<AppColors>() ?? light;

  LinearGradient get brandLinearGradient => LinearGradient(colors: brandGradient, begin: Alignment.topLeft, end: Alignment.bottomRight);
}
