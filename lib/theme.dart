import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppTheme {
  // ☀️ الثيم الفاتح
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryTeal,
      scaffoldBackgroundColor: AppColors.backgroundColor,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryTeal,
        surface: AppColors.backgroundColor,
        surfaceContainer: AppColors.primaryTeal,
        surfaceContainerLow: Colors.white,
        outlineVariant: AppColors.outlineColor,
        onSurface: AppColors.primaryText,
        onSurfaceVariant: AppColors.secondaryText,
        error: AppColors.errorRed,
      ),
    );
  }

  // 🌙 الثيم الداكن
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimaryTeal,
      scaffoldBackgroundColor: AppColors.darkBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimaryTeal,
        surface: AppColors.darkBackground,
        surfaceContainer: Color(0xFF1A1A1A),
        surfaceContainerLow: AppColors.darkSurface,
        outlineVariant: AppColors.darkOutlineColor,
        onSurface: Colors.white,
        onSurfaceVariant: AppColors.darkSecondaryText,
        error: AppColors.errorRed,
      ),
    );
  }
}