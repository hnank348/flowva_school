import 'package:flutter/material.dart';

class AppColors {
  // ═══════════ Light ═══════════
  static const Color primaryTeal = Color(0xFF008081);
  static const Color backgroundColor = Colors.white;
  static const Color surfaceContainerLight = Color(0xFFF8FAFC);
  static const Color outlineColor = Color(0xFFCCCCCC);
  static const Color secondaryText = Color(0xFF808080);
  static const Color primaryText = Colors.black87;
  static const Color errorRed = Colors.red;

  // ═══════════ Dark (Slate palette - مريحة للعين) ═══════════
  static const Color darkPrimaryTeal = Color(0xFF2DD4BF);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF16213A);
  static const Color darkSurfaceContainer = Color(0xFF1E293B);
  static const Color darkOutlineColor = Color(0xFF334155);
  static const Color darkSecondaryText = Color(0xFF94A3B8);
  static const Color darkPrimaryText = Color(0xFFF1F5F9);
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusExtraLarge = 32.0;

  static const double buttonHeight = 56.0;

  static const double fontSizeTitle = 28.0;
  static const double fontSizeSubtitle = 18.0;
  static const double fontSizeLabel = 14.0;
  static const double fontSizeButton = 18.0;
}

class AppStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: AppSizes.fontSizeTitle,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: AppSizes.fontSizeLabel,
    color: AppColors.primaryText,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: AppSizes.fontSizeButton,
    fontWeight: FontWeight.bold,
  );
}