import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/utils/responsive.dart';
import 'package:craft_configurator/core/widgets/content_wrap_widget.dart';
import 'package:craft_configurator/core/widgets/section_head_widget.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/identity_form_widget.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/module_list_widget.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/preview_panel_widget.dart';

/// Section .01 — the configurator itself: identity + module list on the
/// left, the live preview card on the right (stacked when narrow).
class ConfigureSectionWidget extends StatelessWidget {
  /// Creates the configure section.
  const ConfigureSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool stacked = width <= AppConstants.configStackBreakpoint;
    final double gap = clampVw(
      viewportWidth: width,
      min: AppConstants.configGridGapMin,
      vwFactor: AppConstants.configGridGapVw,
      max: AppConstants.configGridGapMax,
    );

    const Widget form = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [IdentityFormWidget(), ModuleListWidget()],
    );

    return ContentWrapWidget(
      child: Column(
        children: [
          const SectionHeadWidget(
            number: '.01',
            title: 'Choose what ships',
            lede:
                'Every module sits behind the same interfaces, so they '
                'compose cleanly. The panel follows your selection — files, '
                'dependencies, setup steps.',
          ),
          SizedBox(
            height: clampVw(
              viewportWidth: width,
              min: AppConstants.secHeadGapMin,
              vwFactor: AppConstants.secHeadGapVw,
              max: AppConstants.secHeadGapMax,
            ),
          ),
          if (stacked)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                form,
                SizedBox(height: gap),
                const PreviewPanelWidget(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: form),
                SizedBox(width: gap),
                const SizedBox(
                  width: AppConstants.previewWidth,
                  child: PreviewPanelWidget(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
