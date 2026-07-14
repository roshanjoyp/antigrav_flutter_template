import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/widgets/micro_label_widget.dart';
import 'package:craft_configurator/features/configurator/domain/module_catalogue.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/module_row_widget.dart';

/// The grouped module list: hairline rows under micro-caps group labels.
class ModuleListWidget extends StatelessWidget {
  /// Creates the module list from the catalogue.
  const ModuleListWidget({super.key});

  /// Distinct group names in catalogue order.
  static List<String> get _groups {
    final List<String> groups = [];
    for (final module in kModuleCatalogue) {
      if (!groups.contains(module.group)) groups.add(module.group);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> groups = _groups;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final group in groups) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: AppConstants.groupLabelTopGap,
              bottom: AppConstants.groupLabelBottomGap,
            ),
            child: MicroLabelWidget(group, size: 9, trackingEm: 0.34),
          ),
          for (final module in kModuleCatalogue)
            if (module.group == group) ModuleRowWidget(module: module),
          Container(height: 1, color: AppColors.line),
        ],
      ],
    );
  }
}
