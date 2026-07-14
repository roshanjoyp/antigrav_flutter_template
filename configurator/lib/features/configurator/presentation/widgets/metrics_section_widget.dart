import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/utils/responsive.dart';
import 'package:craft_configurator/core/widgets/content_wrap_widget.dart';
import 'package:craft_configurator/core/widgets/micro_label_widget.dart';

/// Hairline-divided metrics row under the hero (4-up, 2-up on narrow).
class MetricsSectionWidget extends StatelessWidget {
  /// Creates the metrics row.
  const MetricsSectionWidget({super.key});

  static const List<(String, String)> _metrics = [
    ('04', 'Configurable modules'),
    ('81%', 'Line test coverage'),
    ('01', 'Command to running app'),
    ('00', 'Unused code shipped'),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final int columns = width > 720 ? 4 : 2;
    final double numSize = clampVw(
      viewportWidth: width,
      min: 25.6,
      vwFactor: 0.03,
      max: 36.8,
    );

    return ContentWrapWidget(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.line),
            bottom: BorderSide(color: AppColors.line),
          ),
        ),
        child: Column(
          children: [
            for (int row = 0; row < _metrics.length / columns; row++)
              Container(
                decoration: row > 0
                    ? const BoxDecoration(
                        border: Border(top: BorderSide(color: AppColors.line)),
                      )
                    : null,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int col = 0; col < columns; col++)
                        Expanded(
                          child: _cell(
                            _metrics[row * columns + col],
                            numSize: numSize,
                            hairlineLeft: col > 0,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _cell(
    (String, String) metric, {
    required double numSize,
    required bool hairlineLeft,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 46, 20, 42),
      decoration: hairlineLeft
          ? const BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.line)),
            )
          : null,
      child: Column(
        children: [
          Text(
            metric.$1,
            style: AppTypography.disp(
              size: numSize,
              weight: 500,
              trackingEm: 0.06,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          MicroLabelWidget(metric.$2, size: 9, trackingEm: 0.3),
        ],
      ),
    );
  }
}
