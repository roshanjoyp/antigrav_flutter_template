import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/features/configurator/domain/configuration_entity.dart';
import 'package:craft_configurator/features/configurator/domain/preview_derivations.dart';

/// Head of the preview card: zip name, live summary line, and the tab
/// strip (Files / pubspec.yaml / Setup steps).
class PreviewHeadWidget extends StatelessWidget {
  /// Creates the head for [config] with [activeTab] selected.
  const PreviewHeadWidget({
    super.key,
    required this.config,
    required this.tabs,
    required this.activeTab,
    required this.onTab,
  });

  /// The configuration the summary derives from.
  final ConfigurationEntity config;

  /// Tab captions, in order.
  final List<String> tabs;

  /// Index of the selected tab.
  final int activeTab;

  /// Called with the tapped tab's index.
  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.previewPad,
        28,
        AppConstants.previewPad,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            config.zipName,
            style: AppTypography.code(size: 13, weight: 700),
          ),
          const SizedBox(height: 5),
          Text(
            PreviewDerivations.summary(config),
            style: AppTypography.code(size: 11, color: AppColors.muted),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            // Scrolls instead of overflowing when labels outgrow the card.
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [for (int i = 0; i < tabs.length; i++) _tab(i)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(int index) {
    final bool active = index == activeTab;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTab(index),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 11),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.fg : Colors.transparent,
              ),
            ),
          ),
          child: Text(
            tabs[index].toUpperCase(),
            style: AppTypography.disp(
              size: 9,
              weight: 500,
              trackingEm: 0.26,
              color: active ? AppColors.fg : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
