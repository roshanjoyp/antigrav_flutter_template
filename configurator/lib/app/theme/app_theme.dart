import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';

/// Builds the single dark theme of the configurator.
///
/// The design is dark-first and single-theme by design (one light band
/// section provides the counterpoint), so there is no light [ThemeData].
abstract final class AppTheme {
  /// The one and only theme.
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      fontFamily: AppTypography.body,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.bg,
        onSurface: AppColors.fg,
        primary: AppColors.fg,
        onPrimary: AppColors.bg,
        secondary: AppColors.muted,
        outline: AppColors.line,
      ),
      textTheme: TextTheme(
        bodyMedium: AppTypography.text(),
        bodySmall: AppTypography.text(size: 14, color: AppColors.muted),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.fg,
        selectionColor: AppColors.line,
        selectionHandleColor: AppColors.fg,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.line),
      ),
      splashFactory: NoSplash.splashFactory,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
