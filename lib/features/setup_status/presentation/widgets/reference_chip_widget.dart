import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// A compact reference tag (console URL or doc path) shown under a
/// setup step or readiness item.
///
/// Renders as a small pill with a leading glyph so references scan as
/// metadata instead of raw text mixed into the description.
class ReferenceChipWidget extends StatelessWidget {
  /// Creates a reference chip.
  const ReferenceChipWidget({
    super.key,
    required this.icon,
    required this.label,
  });

  /// Leading glyph (e.g. link or document icon).
  final IconData icon;

  /// The reference text (URL or repo-relative path).
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceXs,
        vertical: AppConstants.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(AppConstants.radiusXs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppConstants.iconXs, color: AppColors.accentLight),
          const SizedBox(width: AppConstants.spaceXxs),
          Flexible(
            child: AppText.caption(
              label,
              color: AppColors.textSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
