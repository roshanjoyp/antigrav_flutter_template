import 'package:antigrav_flutter_template/app/theme/app_theme_components.dart';
import 'package:antigrav_flutter_template/core/core.dart';
import 'package:flutter/material.dart';

/// Defines the application's [ThemeData] for dark and light modes.
///
/// All colors reference [AppColors] and all dimensions reference
/// [AppConstants] — no hardcoded values appear in this file or in
/// [AppThemeComponents].
///
/// Component theme configurations live in [AppThemeComponents] to keep
/// this file under the 200 line limit. Custom [ThemeExtension] classes
/// live in `app_theme_extensions.dart`.
///
/// Usage in [MaterialApp]:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   darkTheme: AppTheme.darkTheme,
///   themeMode: ThemeMode.dark,
/// )
/// ```
abstract final class AppTheme {
  // ---------------------------------------------------------------------------
  // Dark Theme
  // ---------------------------------------------------------------------------

  /// The fully configured dark [ThemeData] for the application.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.accent,
        onPrimary: AppColors.textOnAccent,
        primaryContainer: AppColors.accentMuted,
        onPrimaryContainer: AppColors.textPrimary,
        secondary: AppColors.accentLight,
        onSecondary: AppColors.textOnAccent,
        secondaryContainer: AppColors.accentMuted,
        onSecondaryContainer: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textOnAccent,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.border,
        outlineVariant: AppColors.borderSubtle,
        scrim: AppColors.overlayHeavy,
        inverseSurface: AppColors.surfaceInverse,
        onInverseSurface: AppColors.background,
        inversePrimary: AppColors.accentDark,
      ),
      appBarTheme: AppThemeComponents.darkAppBar,
      cardTheme: AppThemeComponents.darkCard,
      elevatedButtonTheme: AppThemeComponents.darkElevatedButton,
      textButtonTheme: AppThemeComponents.darkTextButton,
      outlinedButtonTheme: AppThemeComponents.darkOutlinedButton,
      inputDecorationTheme: AppThemeComponents.darkInputDecoration,
      dividerTheme: AppThemeComponents.darkDivider,
      bottomNavigationBarTheme: AppThemeComponents.darkBottomNav,
      snackBarTheme: AppThemeComponents.darkSnackBar,
      dialogTheme: AppThemeComponents.darkDialog,
      listTileTheme: AppThemeComponents.darkListTile,
    );
  }

  // ---------------------------------------------------------------------------
  // Light Theme
  // ---------------------------------------------------------------------------

  /// Light theme stub — not yet implemented.
  ///
  /// Returns a minimal [ThemeData] to satisfy [MaterialApp.theme].
  /// A full light theme will be built when light mode support is required.
  static ThemeData get lightTheme {
    // TODO: Implement light theme using AppColors light-mode tokens.
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.light,
      ),
    );
  }
}
