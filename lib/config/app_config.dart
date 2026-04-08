import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryExtra = Color(0xFFFBFDFF);

  // Secondary Colors
  static const Color successDark = Color(0xFF059669);
  static const Color successLight = Color(0xFF10B981);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFEF4444);

  // Neutral Colors
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGray = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color backgroundLight = Color(0xFFF8FAFC);
}

class AppDimensions {
  // Padding & Margin
  static const double paddingXS = 4;
  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
  static const double paddingXL = 32;

  // Border Radius
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXL = 20;

  // Font Sizes
  static const double fontXS = 12;
  static const double fontS = 14;
  static const double fontM = 16;
  static const double fontL = 20;
  static const double fontXL = 24;
  static const double fontXXL = 32;

  // Icon Sizes
  static const double iconS = 20;
  static const double iconM = 24;
  static const double iconL = 32;
  static const double iconXL = 48;
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primaryDark, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [AppColors.successDark, AppColors.successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [AppColors.errorDark, AppColors.errorLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryDark,
      AppColors.primaryLight,
      AppColors.primaryExtra,
    ],
  );
}
