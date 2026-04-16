import 'package:antigrav_flutter_template/core/constants/app_colors.dart';
import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// A primary action button that enforces app-wide styling via [AppColors]
/// and [AppConstants].
///
/// Handles loading, disabled, full-width, and normal states consistently
/// across the app. Use this instead of [ElevatedButton] or [FilledButton]
/// directly so all primary actions share the same visual language.
///
/// Example:
/// ```dart
/// AppButton(
///   label: 'Continue',
///   onPressed: _handleContinue,
///   isFullWidth: true,
/// )
/// ```
class AppButton extends StatelessWidget {
  /// Creates an [AppButton].
  ///
  /// [label] is the text displayed on the button.
  /// [onPressed] is the callback triggered on tap. Pass `null` to disable.
  /// [isLoading] replaces the label with a [CircularProgressIndicator] and
  ///   disables interaction while `true`.
  /// [isFullWidth] stretches the button to fill its parent's width when `true`.
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  /// The text label displayed inside the button.
  final String label;

  /// Called when the button is tapped.
  ///
  /// Set to `null` to render the button in its disabled state.
  final VoidCallback? onPressed;

  /// Whether to show a loading spinner in place of [label].
  ///
  /// Disables interaction while `true`. Defaults to `false`.
  final bool isLoading;

  /// Whether the button should stretch to the full width of its parent.
  ///
  /// Defaults to `false`.
  final bool isFullWidth;

  /// Whether the button is currently interactive.
  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: _isDisabled ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor:
            _isDisabled ? AppColors.accentMuted : AppColors.accent,
        foregroundColor: AppColors.textOnAccent,
        disabledBackgroundColor: AppColors.accentMuted,
        disabledForegroundColor:
            AppColors.textOnAccent.withValues(alpha: AppConstants.opacityDim),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceLg,
          vertical: AppConstants.spaceMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppConstants.radiusMd),
        ),
        minimumSize: isFullWidth
            ? const Size(double.infinity, AppConstants.space4xl)
            : const Size(AppConstants.space5xl, AppConstants.space4xl),
      ),
      child: isLoading ? _buildLoader() : _buildLabel(),
    );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Widget _buildLabel() {
    return Text(
      label,
      style: const TextStyle(
        fontSize: AppConstants.fontMd,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnAccent,
      ),
    );
  }

  Widget _buildLoader() {
    return SizedBox(
      width: AppConstants.iconSm,
      height: AppConstants.iconSm,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.textOnAccent
              .withValues(alpha: AppConstants.opacityStrong),
        ),
      ),
    );
  }
}
