import 'package:antigrav_flutter_template/core/constants/app_colors.dart';
import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:antigrav_flutter_template/core/widgets/app_button.dart';
import 'package:antigrav_flutter_template/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// A centered error display widget used when an operation fails.
///
/// Shows an error icon, a [message] describing what went wrong, and an
/// optional retry button. Use this as the error state in async screens
/// rather than rolling custom error UI.
///
/// Example:
/// ```dart
/// // Error without retry
/// AppError(message: 'Something went wrong.')
///
/// // Error with retry
/// AppError(
///   message: 'Failed to load data.',
///   onRetry: _loadData,
/// )
/// ```
class AppError extends StatelessWidget {
  /// Creates an [AppError] widget.
  ///
  /// [message] describes what went wrong. Keep it user-friendly.
  /// [onRetry] is an optional callback invoked when the user taps 'Retry'.
  const AppError({
    super.key,
    required this.message,
    this.onRetry,
  });

  /// A user-facing description of the error.
  final String message;

  /// An optional callback invoked when the user taps the retry button.
  ///
  /// When `null`, the retry button is not rendered.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: AppConstants.iconXl,
            ),
            const SizedBox(height: AppConstants.spaceMd),
            AppText.bodyMedium(
              message,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.spaceXl),
              AppButton(
                label: 'Retry',
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
