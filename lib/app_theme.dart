import 'package:flutter/material.dart';

class AppColors {
<<<<<<< HEAD
  // ==================== Light Mode Colors ====================
=======
  // ═══════════ Light ═══════════
>>>>>>> 1b465efd2918a95bb900fa00348a56898b6b9f0d
  static const Color primaryTeal = Color(0xFF008081);
  static const Color backgroundColor = Colors.white;
  static const Color surfaceContainerLight = Color(0xFFF8FAFC);
  static const Color outlineColor = Color(0xFFCCCCCC);
  static const Color secondaryText = Color(0xFF808081);
  static const Color primaryText = Colors.black87;
  static const Color errorRed = Colors.red;

<<<<<<< HEAD
  // ألوان الحضور للوضع الفاتح (Light Mode)
  static const Color attendancePresent = Colors.green;
  static const Color attendanceLateOrExcused = Colors.orange;
  static const Color attendanceUnexcused = Colors.red;
  static const Color attendanceRate = Colors.blue;

  // ==================== Dark Mode Colors ====================
  static const Color darkPrimaryTeal = Color(0xFF4D9B9C);
  static const Color darkBackground = Color.fromARGB(255, 32, 32, 32);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOutlineColor = Color(0xFF424242);
  static const Color darkSecondaryText = Color(0xFFAAAAAA);
  
  // ألوان الحضور للوضع المظلم (Dark Mode - مريحة ومناسبة للعين خلف الخلفيات الداكنة)
  static const Color darkAttendancePresent = Colors.greenAccent;
  static const Color darkAttendanceLateOrExcused = Colors.amber;
  static const Color darkAttendanceUnexcused = Color(0xFFFF6B6B);
  static const Color darkAttendanceRate = Color(0xFF64B5F6);

  // ==================== الدالة الذكية لجلب الألوان ديناميكياً ====================
  /// دالة ذكية لإرجاع لون نسبة الحضور المناسب تلقائياً حسب وضع الشاشة (فاتح / مظلم)
  static Color getAttendanceRateColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkAttendanceRate : attendanceRate;
  }

  /// ميزة إضافية: دالة ذكية مدمجة لبقية ألوان الحضور لتوحيد وتسهيل العمل في الشاشات
  static Color getAttendanceStatusColor(BuildContext context, String status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (status) {
      case 'present':
      case 'حاضر':
        return isDark ? darkAttendancePresent : attendancePresent;
      case 'late':
      case 'absent_excused':
      case 'متأخر':
      case 'غائب بعذر':
      case 'بعذر':
        return isDark ? darkAttendanceLateOrExcused : attendanceLateOrExcused;
      case 'absent_unexcused':
      case 'غائب':
      case 'بدون عذر':
        return isDark ? darkAttendanceUnexcused : attendanceUnexcused;
      default:
        return isDark ? Colors.white : primaryText;
    }
  }
=======
  // ═══════════ Dark (Slate palette - مريحة للعين) ═══════════
  static const Color darkPrimaryTeal = Color(0xFF2DD4BF);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF16213A);
  static const Color darkSurfaceContainer = Color(0xFF1E293B);
  static const Color darkOutlineColor = Color(0xFF334155);
  static const Color darkSecondaryText = Color(0xFF94A3B8);
  static const Color darkPrimaryText = Color(0xFFF1F5F9);
>>>>>>> 1b465efd2918a95bb900fa00348a56898b6b9f0d
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
<<<<<<< HEAD
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Cairo', // تثبيت الخط للتطبيق بأكمله
      shadowColor: Colors.grey,
      primaryColor: AppColors.primaryTeal,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryTeal,
        secondary: AppColors.primaryTeal,
        error: AppColors.errorRed,
        surface: AppColors.backgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryText),
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
          borderSide: const BorderSide(
            color: AppColors.outlineColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(
            color: AppColors.outlineColor,
            width: 1.5,
          ),
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
        hintStyle: AppStyles.labelStyle.copyWith(
          color: AppColors.secondaryText,
        ),
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
          elevation: 2,
        ),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Cairo', 
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.darkPrimaryTeal,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimaryTeal,
        secondary: AppColors.darkPrimaryTeal,
        surface: AppColors.darkSurface,
        onSurface: Colors.white,
        onSurfaceVariant: AppColors.darkSecondaryText,
        error: AppColors.errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
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
          borderSide: const BorderSide(
            color: AppColors.darkOutlineColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(
            color: AppColors.darkOutlineColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(
            color: AppColors.darkPrimaryTeal,
            width: 2,
          ),
        ),
        hintStyle: AppStyles.labelStyle.copyWith(
          color: AppColors.darkSecondaryText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimaryTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          textStyle: AppStyles.buttonTextStyle,
          elevation: 2,
        ),
      ),
      useMaterial3: true,
    );
  }
}
=======
}
>>>>>>> 1b465efd2918a95bb900fa00348a56898b6b9f0d
