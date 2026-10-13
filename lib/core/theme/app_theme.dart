// Port of ui/theme/Theme.kt — BuildHubTheme(sunlightMode)
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData darkIndustrial() {
    final scheme = const ColorScheme.dark(
      primary: AppColors.accentCyan,
      onPrimary: AppColors.darkBackground,
      primaryContainer: Color(0xFF003847),
      onPrimaryContainer: AppColors.accentCyan,
      secondary: AppColors.accentSky,
      onSecondary: AppColors.darkBackground,
      secondaryContainer: Color(0xFF0A2E46),
      onSecondaryContainer: Color(0xFFBAE6FD),
      tertiary: AppColors.verifiedGreen,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.greenContainer,
      onTertiaryContainer: Color(0xFFA7F3D0),
      surface: AppColors.darkSurface,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.darkCard,
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: AppColors.darkBorder,
      error: AppColors.criticalRed,
      onError: Colors.white,
      errorContainer: AppColors.redContainer,
      onErrorContainer: Color(0xFFFECACA),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
    );
  }

  static ThemeData sunlight() {
    final scheme = const ColorScheme.light(
      primary: AppColors.sunlightPrimary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE0F2FE),
      onPrimaryContainer: Color(0xFF0369A1),
      secondary: Color(0xFF0F172A),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFE2E8F0),
      onSecondaryContainer: Color(0xFF1E293B),
      tertiary: Color(0xFF059669),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFD1FAE5),
      onTertiaryContainer: Color(0xFF065F46),
      surface: AppColors.sunlightSurface,
      onSurface: AppColors.sunlightTextPrimary,
      surfaceContainerHighest: AppColors.sunlightCard,
      onSurfaceVariant: AppColors.sunlightTextSecondary,
      outline: AppColors.sunlightBorder,
      error: Color(0xFFB91C1C),
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF991B1B),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.sunlightBackground,
    );
  }
}
