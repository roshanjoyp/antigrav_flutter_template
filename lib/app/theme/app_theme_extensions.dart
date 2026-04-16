import 'package:antigrav_flutter_template/core/core.dart';
import 'package:flutter/material.dart';

/// Custom [ThemeExtension] classes for app-specific design tokens that fall
/// outside standard Material 3 component themes.
///
/// Add [ThemeExtension] subclasses here when a feature needs theme-aware
/// values that don't map to an existing Material component theme property.
///
/// Register extensions in [AppTheme.darkTheme] and [AppTheme.lightTheme]
/// via [ThemeData.extensions]:
/// ```dart
/// ThemeData(
///   extensions: const [
///     AppStatusColors(),
///   ],
/// )
/// ```
///
/// Retrieve in widget code via:
/// ```dart
/// final statusColors = Theme.of(context).extension<AppStatusColors>()!;
/// ```

// ---------------------------------------------------------------------------
// AppStatusColors
// ---------------------------------------------------------------------------

/// A [ThemeExtension] that surfaces the app's status color palette through
/// the standard [ThemeData.extension] mechanism.
///
/// Allows widgets to retrieve status colors via [Theme.of(context)] without
/// importing [AppColors] directly.
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  /// Creates an [AppStatusColors] extension with dark-mode defaults.
  const AppStatusColors({
    this.error = AppColors.error,
    this.errorLight = AppColors.errorLight,
    this.success = AppColors.success,
    this.successLight = AppColors.successLight,
    this.warning = AppColors.warning,
    this.warningLight = AppColors.warningLight,
    this.info = AppColors.info,
    this.infoLight = AppColors.infoLight,
  });

  /// Error state color.
  final Color error;

  /// Light tint of [error], for error background surfaces.
  final Color errorLight;

  /// Success state color.
  final Color success;

  /// Light tint of [success], for success background surfaces.
  final Color successLight;

  /// Warning state color.
  final Color warning;

  /// Light tint of [warning], for warning background surfaces.
  final Color warningLight;

  /// Info state color.
  final Color info;

  /// Light tint of [info], for info background surfaces.
  final Color infoLight;

  @override
  AppStatusColors copyWith({
    Color? error,
    Color? errorLight,
    Color? success,
    Color? successLight,
    Color? warning,
    Color? warningLight,
    Color? info,
    Color? infoLight,
  }) {
    return AppStatusColors(
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      info: info ?? this.info,
      infoLight: infoLight ?? this.infoLight,
    );
  }

  @override
  AppStatusColors lerp(AppStatusColors? other, double t) {
    if (other == null) return this;
    return AppStatusColors(
      error: Color.lerp(error, other.error, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      success: Color.lerp(success, other.success, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
    );
  }
}
