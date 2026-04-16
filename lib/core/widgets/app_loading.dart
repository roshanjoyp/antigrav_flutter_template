import 'package:antigrav_flutter_template/core/constants/app_colors.dart';
import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:antigrav_flutter_template/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// A centered loading indicator using the app accent color.
///
/// Use this widget anywhere the app is waiting on an async operation.
/// An optional [message] can be displayed below the spinner to give
/// the user context about what is loading.
///
/// Example:
/// ```dart
/// // Spinner only
/// const AppLoading()
///
/// // Spinner with message
/// const AppLoading(message: 'Signing you in...')
/// ```
class AppLoading extends StatelessWidget {
  /// Creates an [AppLoading] widget.
  ///
  /// [message] is an optional string displayed below the spinner.
  const AppLoading({
    super.key,
    this.message,
  });

  /// An optional message displayed below the loading indicator.
  ///
  /// Keep messages short and present-tense, e.g. `'Loading...'` or
  /// `'Signing you in...'`.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
          if (message != null) ...[
            const SizedBox(height: AppConstants.spaceMd),
            AppText.bodySmall(
              message!,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
