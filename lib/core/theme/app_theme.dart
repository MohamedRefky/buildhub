// Port of ui/theme/Theme.kt — BuildHubTheme(sunlightMode).
// Dark Industrial (primary) + Outdoor Sunlight palettes with the
// reference component styling: 12-14dp rounded surface cards with hairline
// outlines, cyan primary actions, cyan navigation indicator.
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static const _radius = 14.0;

  static RoundedRectangleBorder _cardShape(Color outline) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
        side: BorderSide(color: outline.withValues(alpha: 0.35), width: 0.7),
      );

  static ThemeData _base({
    required ColorScheme scheme,
    required Color scaffold,
    required Color glow,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 5),
        shape: _cardShape(scheme.outline),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        elevation: 6,
        indicatorColor: glow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) =>
            TextStyle(
                fontSize: 11,
                fontWeight: states.contains(WidgetState.selected)
                    ? FontWeight.w800
                    : FontWeight.w500,
                color: states.contains(WidgetState.selected)
                    ? glow
                    : scheme.onSurfaceVariant)),
        iconTheme: WidgetStateProperty.resolveWith((states) =>
            IconThemeData(
                size: 22,
                color: states.contains(WidgetState.selected)
                    ? scheme.surface
                    : scheme.onSurfaceVariant)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: glow,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: scheme.onSurface),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: glow.withValues(alpha: 0.2),
        secondarySelectedColor: glow.withValues(alpha: 0.2),
        labelStyle: TextStyle(color: scheme.onSurface, fontSize: 12),
        secondaryLabelStyle: TextStyle(color: scheme.onSurface, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: scheme.outline)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: scheme.outline.withValues(alpha: 0.6))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: glow, width: 1.5)),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: glow,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: glow,
        unselectedLabelColor: scheme.onSurfaceVariant,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(16))),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        contentTextStyle: TextStyle(color: scheme.onSurface),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: glow,
        linearTrackColor: scheme.outline.withValues(alpha: 0.35),
        circularTrackColor: scheme.outline.withValues(alpha: 0.35),
      ),
      dividerTheme: DividerThemeData(
          color: scheme.outline.withValues(alpha: 0.4), thickness: 0.7),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? glow
                : scheme.onSurfaceVariant),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? glow.withValues(alpha: 0.35)
                : scheme.outline.withValues(alpha: 0.5)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? glow
                : Colors.transparent),
        checkColor: WidgetStateProperty.all(scheme.surface),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? glow
                  : scheme.onSurfaceVariant)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: glow,
        foregroundColor: scheme.surface,
      ),
      badgeTheme: BadgeThemeData(
          backgroundColor: glow, textColor: scheme.surface),
      textTheme: Typography.englishLike2021.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
    );
  }

  static ThemeData darkIndustrial() {
    const scheme = ColorScheme.dark(
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
    return _base(
        scheme: scheme,
        scaffold: AppColors.darkBackground,
        glow: AppColors.accentCyan);
  }

  static ThemeData sunlight() {
    const scheme = ColorScheme.light(
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
    return _base(
        scheme: scheme,
        scaffold: AppColors.sunlightBackground,
        glow: AppColors.sunlightPrimary);
  }
}
