import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// A small circular badge holding a status or category icon.
///
/// The standard leading element for list tiles that communicate state:
/// the icon sits on a tinted disc of its own color family, giving rows
/// a scannable anchor instead of a floating glyph.
///
/// Example:
/// ```dart
/// AppIconBadge(
///   icon: Icons.check_circle_outline,
///   color: AppColors.success,
///   background: AppColors.successLight,
/// )
/// ```
class AppIconBadge extends StatelessWidget {
  /// Creates an [AppIconBadge].
  const AppIconBadge({
    super.key,
    required this.icon,
    required this.color,
    required this.background,
    this.child,
  });

  /// The glyph shown at the center of the disc.
  final IconData icon;

  /// Foreground color of the icon.
  final Color color;

  /// Fill color of the disc — typically the `*Light` companion of
  /// [color] from `AppColors`.
  final Color background;

  /// Replaces the icon when provided (e.g. a progress indicator while
  /// a check is running).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.iconLg,
      height: AppConstants.iconLg,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child ?? Icon(icon, color: color, size: AppConstants.iconSm),
    );
  }
}
