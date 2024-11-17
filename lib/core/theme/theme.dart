import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ThemeType {
  lightDarkBlue,
  darkDarkBlue;

  bool get isLight => this == ThemeType.lightDarkBlue;
  bool get isDark => this == ThemeType.darkDarkBlue;
}

class AppTheme {
  static const defaultType = ThemeType.darkDarkBlue;
  static final defaultTheme = AppTheme.fromType(defaultType);

  late ThemeType type;
  bool isDark;

  late Color primaryColor;

  AppTheme({this.isDark = false});

  factory AppTheme.fromType(ThemeType type) {
    switch (type) {
      case ThemeType.lightDarkBlue:
        return AppTheme(isDark: false)
          ..type = type
          ..primaryColor = const Color(0xFFF72055);

      case ThemeType.darkDarkBlue:
        return AppTheme(isDark: true)
          ..type = type
          ..primaryColor = const Color(0xFFF72055);
    }
  }

  ThemeData get themeData {
    var t = ThemeData();

    return t.copyWith(
      primaryColor: primaryColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: t.textTheme.apply(fontFamily: 'SfProDisplay'),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        surface: shift(primaryColor, isDark ? -0.05 : 0.05),
      ).copyWith(),
      appBarTheme: const AppBarTheme(centerTitle: true),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        space: 0,
      ),
      snackBarTheme: SnackBarThemeData(actionTextColor: primaryColor),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.selected)) {
              return primaryColor;
            }

            return null;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.selected)) {
              return primaryColor;
            }

            return null;
          },
        ),
      ),
    );
  }

  Color shift(Color c, double amount) {
    amount *= (isDark ? -1 : 1);

    /// Convert to HSL
    var hslc = HSLColor.fromColor(c);

    /// Add/Remove lightness
    double lightness = (hslc.lightness + amount).clamp(0, 1.0).toDouble();

    /// Convert back to Color
    return hslc.withLightness(lightness).toColor();
  }
}
