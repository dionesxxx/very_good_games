import 'package:flutter/material.dart';

class FlutterGamesTheme {
  static ThemeData get dark {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: Color(0xFF35383F),
      ),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: const Color(0xFF35383F),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: Colors.white,
      ),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: Colors.white,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
