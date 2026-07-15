import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppTheme {
  // ═══════════════════════════════ الثيم الفاتح ═══════════════════════════════
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      shadowColor: Colors.grey,
      primaryColor: AppColors.primaryTeal,
      scaffoldBackgroundColor: AppColors.backgroundColor,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryTeal,
        secondary: AppColors.primaryTeal,
        error: AppColors.errorRed,
        surface: AppColors.backgroundColor,
        surfaceContainer: AppColors.backgroundColor,
        surfaceContainerLow: AppColors.surfaceContainerLight,
        outlineVariant: AppColors.outlineColor,
        onSurface: AppColors.primaryText,
        onSurfaceVariant: AppColors.secondaryText,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingMedium,
          horizontal: AppSizes.paddingLarge,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.outlineColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.outlineColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2.0),
        ),
        labelStyle: AppStyles.labelStyle.copyWith(
          color: AppColors.secondaryText,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: AppStyles.labelStyle.copyWith(color: AppColors.secondaryText),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          textStyle: AppStyles.buttonTextStyle,
          elevation: 5,
        ),
      ),
    );
  }

  // ═══════════════════════════════ الثيم الغامق ═══════════════════════════════
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimaryTeal,
      scaffoldBackgroundColor: AppColors.darkBackground,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimaryTeal,
        secondary: AppColors.darkPrimaryTeal,
        error: Color(0xFFEF4444), // أحمر أوضح على الخلفية الغامقة
        surface: AppColors.darkBackground,
        surfaceContainer: AppColors.darkSurfaceContainer,
        surfaceContainerLow: AppColors.darkSurface,
        outlineVariant: AppColors.darkOutlineColor,
        onSurface: AppColors.darkPrimaryText,       // نص أساسي مريح مش أبيض خالص
        onSurfaceVariant: AppColors.darkSecondaryText,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkPrimaryText,
        iconTheme: IconThemeData(color: AppColors.darkPrimaryText),
        elevation: 0,
        centerTitle: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingMedium,
          horizontal: AppSizes.paddingLarge,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.darkOutlineColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.darkOutlineColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.darkPrimaryTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2.0),
        ),
        hintStyle: AppStyles.labelStyle.copyWith(color: AppColors.darkSecondaryText),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimaryTeal,
          foregroundColor: AppColors.darkBackground,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          textStyle: AppStyles.buttonTextStyle.copyWith(color: AppColors.darkBackground),
          elevation: 5,
        ),
      ),
    );
  }
}