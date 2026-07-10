import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// A titled module section on the Setup Status screen: a heading above
/// a rounded surface panel holding the section's tiles.
///
/// Grouping tiles on an elevated surface (instead of full-bleed rows on
/// the page background) is what visually separates one module from the
/// next.
class ModuleSectionWidget extends StatelessWidget {
  /// Creates a section titled [title] containing [children] tiles.
  const ModuleSectionWidget({
    super.key,
    required this.title,
    required this.children,
  });

  /// The section heading (module display name).
  final String title;

  /// The tiles to stack inside the panel.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppConstants.spaceXs,
              bottom: AppConstants.spaceXs,
            ),
            child: AppText.headingSmall(title),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    const Divider(
                      height: 1,
                      indent: AppConstants.spaceMd,
                      endIndent: AppConstants.spaceMd,
                    ),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
