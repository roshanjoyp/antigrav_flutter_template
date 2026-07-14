import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/utils/responsive.dart';
import 'package:craft_configurator/core/widgets/content_wrap_widget.dart';
import 'package:craft_configurator/core/widgets/section_head_widget.dart';

/// Section .02 — the single light band: configure → generate → verify.
class ProcessBandSectionWidget extends StatelessWidget {
  /// Creates the process band.
  const ProcessBandSectionWidget({super.key});

  static const List<(String, String, String)> _steps = [
    (
      '.01',
      'Configure',
      'Toggle modules, name your app. The preview shows exactly what '
          'your zip will contain.',
    ),
    (
      '.02',
      'Generate',
      'We compose the codebase from your selection, rewrite packages and '
          'docs to match, then run flutter analyze before you see it.',
    ),
    (
      '.03',
      'Verify',
      'Run dart tool/doctor.dart. It checks every setup step it can and '
          'gives exact instructions for the console work it can\'t.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool stacked = width <= 800;
    final double padV = clampVw(
      viewportWidth: width,
      min: 100,
      vwFactor: 0.12,
      max: 150,
    );

    return Container(
      color: AppColors.bandBg,
      padding: EdgeInsets.symmetric(vertical: padV),
      child: ContentWrapWidget(
        child: Column(
          children: [
            const SectionHeadWidget(
              number: '.02',
              title: 'Three steps',
              lede:
                  'Generation is the easy part — most templates die at '
                  'setup. Ours verifies it.',
              onBand: true,
            ),
            SizedBox(
              height: clampVw(
                viewportWidth: width,
                min: 64,
                vwFactor: 0.08,
                max: 104,
              ),
            ),
            if (stacked)
              Column(
                children: [
                  for (int i = 0; i < _steps.length; i++) ...[
                    if (i > 0) const SizedBox(height: 56),
                    _step(_steps[i], hairlineLeft: false),
                  ],
                ],
              )
            else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < _steps.length; i++)
                      Expanded(child: _step(_steps[i], hairlineLeft: i > 0)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _step((String, String, String) step, {required bool hairlineLeft}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(44, 10, 44, 10),
      decoration: hairlineLeft
          ? const BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.bandLine)),
            )
          : null,
      child: Column(
        children: [
          Text(
            step.$1,
            style: AppTypography.code(
              size: 11,
              trackingEm: 0.2,
              color: AppColors.bandMuted,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 13 * 0.3),
            child: Text(
              step.$2.toUpperCase(),
              style: AppTypography.disp(
                size: 13,
                weight: 500,
                trackingEm: 0.3,
                color: AppColors.bandFg,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            step.$3,
            textAlign: TextAlign.center,
            style: AppTypography.text(
              size: 14,
              color: AppColors.bandMuted,
              height: 1.75,
            ),
          ),
        ],
      ),
    );
  }
}
