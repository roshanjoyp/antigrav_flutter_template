import 'package:antigrav_flutter_template/core/core.dart';
import 'package:flutter/material.dart';

/// Provides static component theme configurations for [AppTheme.darkTheme].
///
/// Each getter returns a fully configured Material 3 component theme using
/// only [AppColors] and [AppConstants]. [AppTheme] composes these into the
/// final [ThemeData] to keep individual files under the 200 line limit.
abstract final class AppThemeComponents {
  /// App bar theme for the dark theme.
  static const AppBarTheme darkAppBar = AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    surfaceTintColor: Colors.transparent,
    elevation: AppConstants.elevationNone,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: AppConstants.fontLg,
      fontWeight: FontWeight.w600,
    ),
  );

  /// Card theme for the dark theme.
  static CardThemeData darkCard = CardThemeData(
    color: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    elevation: AppConstants.elevationSm,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
    ),
  );

  /// Elevated button theme for the dark theme.
  static ElevatedButtonThemeData darkElevatedButton = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.textOnAccent,
      elevation: AppConstants.elevationNone,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceLg,
        vertical: AppConstants.spaceMd,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      textStyle: const TextStyle(
        fontSize: AppConstants.fontMd,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  /// Text button theme for the dark theme.
  static TextButtonThemeData darkTextButton = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.accent,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceMd,
        vertical: AppConstants.spaceXs,
      ),
      textStyle: const TextStyle(
        fontSize: AppConstants.fontMd,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  /// Outlined button theme for the dark theme.
  static OutlinedButtonThemeData darkOutlinedButton = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.accent,
      side: const BorderSide(color: AppColors.borderAccent),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceLg,
        vertical: AppConstants.spaceMd,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
    ),
  );

  /// Input decoration theme for the dark theme.
  static InputDecorationTheme darkInputDecoration = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.backgroundSecondary,
    hintStyle: const TextStyle(color: AppColors.textTertiary),
    labelStyle: const TextStyle(color: AppColors.textSecondary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      borderSide: const BorderSide(color: AppColors.borderAccent, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppConstants.spaceMd,
      vertical: AppConstants.spaceMd,
    ),
  );

  /// Divider theme for the dark theme.
  static const DividerThemeData darkDivider = DividerThemeData(
    color: AppColors.border,
    thickness: 1,
    space: AppConstants.spaceXs,
  );

  /// Bottom navigation bar theme for the dark theme.
  static const BottomNavigationBarThemeData darkBottomNav =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.backgroundSecondary,
    selectedItemColor: AppColors.accent,
    unselectedItemColor: AppColors.textTertiary,
    elevation: AppConstants.elevationLg,
    type: BottomNavigationBarType.fixed,
  );

  /// Snack bar theme for the dark theme.
  static SnackBarThemeData darkSnackBar = SnackBarThemeData(
    backgroundColor: AppColors.surfaceElevated,
    contentTextStyle: const TextStyle(color: AppColors.textPrimary),
    actionTextColor: AppColors.accent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
    ),
    behavior: SnackBarBehavior.floating,
  );

  /// Dialog theme for the dark theme.
  static DialogThemeData darkDialog = DialogThemeData(
    backgroundColor: AppColors.backgroundSecondary,
    surfaceTintColor: Colors.transparent,
    elevation: AppConstants.elevationXl,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
    ),
    titleTextStyle: const TextStyle(
      color: AppColors.textPrimary,
      fontSize: AppConstants.fontXl,
      fontWeight: FontWeight.w600,
    ),
    contentTextStyle: const TextStyle(
      color: AppColors.textSecondary,
      fontSize: AppConstants.fontMd,
    ),
  );

  /// List tile theme for the dark theme.
  static const ListTileThemeData darkListTile = ListTileThemeData(
    tileColor: Colors.transparent,
    iconColor: AppColors.textSecondary,
    textColor: AppColors.textPrimary,
    subtitleTextStyle: TextStyle(
      color: AppColors.textSecondary,
      fontSize: AppConstants.fontSm,
    ),
  );
}
