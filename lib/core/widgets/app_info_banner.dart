import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// An inline informational banner: tinted rounded panel with an icon
/// and a short message.
///
/// Use for contextual hints at the top of a screen or section — not
/// for errors (use `AppError`) or transient feedback (use a snackbar).
class AppInfoBanner extends StatelessWidget {
  /// Creates an [AppInfoBanner].
  const AppInfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
  });

  /// The hint text.
  final String message;

  /// Leading icon; defaults to an info glyph.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceSm),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.info, size: AppConstants.iconSm),
          const SizedBox(width: AppConstants.spaceSm),
          Expanded(
            child: AppText.bodySmall(message, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
