import 'package:flutter/material.dart';

class AppColors {
  // Turquoise primary color requested by user
  static const Color primary = Color(0xFF40E0D0);
  static const Color primaryDark = Color(0xFF2BB8A7);
  static const Color primaryLight = Color(0xFF8FF2E8);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      fontFamily: 'Cairo',
    );
  }
}
