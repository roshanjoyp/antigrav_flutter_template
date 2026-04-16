import 'package:antigrav_flutter_template/core/constants/app_colors.dart';
import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// A thin horizontal divider using [AppColors.border].
///
/// Use [AppDivider] instead of [Divider] directly to ensure all dividers
/// share the same color token. Accepts optional [horizontalPadding] to
/// inset the line from the edges of its parent.
///
/// Example:
/// ```dart
/// // Full-width divider
/// const AppDivider()
///
/// // Inset divider with 16dp horizontal padding
/// const AppDivider(horizontalPadding: AppConstants.spaceMd)
/// ```
class AppDivider extends StatelessWidget {
  /// Creates an [AppDivider].
  ///
  /// [horizontalPadding] adds equal left and right insets. Defaults to `0`.
  const AppDivider({
    super.key,
    this.horizontalPadding = 0,
  });

  /// The horizontal inset applied equally to both sides of the divider line.
  ///
  /// Use a value from [AppConstants] spacing scale. Defaults to `0` (full width).
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: const Divider(
        color: AppColors.border,
        thickness: 1,
        height: AppConstants.spaceXs,
      ),
    );
  }
}
