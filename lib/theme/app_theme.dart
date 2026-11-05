import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0B1C2C);
  static const Color surface = Color(0xFF132F4C);
  static const Color surfaceGlass = Color(0x1FFFFFFF);
  static const Color surfaceGlassBorder = Color(0x33D4AF37);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color red = Color(0xFFC8102E);
  static const Color redLight = Color(0xFFE53935);
  static const Color green = Color(0xFF2E7D32);
  static const Color greenLight = Color(0xFF4CAF50);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFF94A3B8);
  static const Color textGrayLight = Color(0xFFCBD5E1);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.red,
        surface: AppColors.surface,
        error: AppColors.red,
      ),
      textTheme: GoogleFonts.cairoTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: AppColors.textWhite,
        displayColor: AppColors.textWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.gold),
      ),
    );
  }
}
