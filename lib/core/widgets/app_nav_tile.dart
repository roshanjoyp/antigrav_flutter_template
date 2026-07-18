import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/widgets/app_icon_badge.dart';
import 'package:craft_flutter_template/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// A fixed-geometry navigation row for hub and menu screens.
///
/// Every tile shares identical height, padding, and visual weight, so a
/// stack of them reads as one calm, scannable list — use it wherever a
/// screen offers a set of destinations instead of mixing ad-hoc buttons
/// of varying sizes.
///
/// Example:
/// ```dart
/// AppNavTile(
///   icon: Icons.person_outlined,
///   label: 'Profile',
///   sublabel: 'Full clean-architecture example',
///   onTap: () => context.push('/profile'),
/// )
/// ```
class AppNavTile extends StatelessWidget {
  /// Creates an [AppNavTile].
  const AppNavTile({
    super.key,
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  /// The glyph anchoring the row, shown in an [AppIconBadge] disc.
  final IconData icon;

  /// The destination's name.
  final String label;

  /// One short line describing what the destination shows.
  final String sublabel;

  /// Called when the tile is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(AppConstants.radiusMd);
    return Material(
      color: AppColors.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            children: [
              AppIconBadge(
                icon: icon,
                color: AppColors.accentLight,
                background: AppColors.accentMuted,
              ),
              const SizedBox(width: AppConstants.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Explicit color: the tile surface is always dark, so
                    // the label must not follow the ambient theme (which
                    // would render dark-on-dark in light mode).
                    AppText.bodyMedium(label, color: AppColors.textPrimary),
                    const SizedBox(height: AppConstants.spaceXxs),
                    AppText.caption(sublabel, color: AppColors.textTertiary),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.spaceXs),
              const Icon(
                Icons.chevron_right,
                size: AppConstants.iconSm,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
