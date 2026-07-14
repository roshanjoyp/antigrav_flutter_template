import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/widgets/setup_tag_widget.dart';
import 'package:craft_configurator/features/configurator/domain/preview_derivations.dart';
import 'package:craft_configurator/features/configurator/domain/setup_step_entity.dart';

/// Code-style pane (Files / pubspec tabs): dimmed base lines, added lines
/// emphasized with a `+` marker.
class CodePaneWidget extends StatelessWidget {
  /// Creates the pane from derived [lines].
  const CodePaneWidget({super.key, required this.lines});

  /// Lines to render, in order.
  final List<PreviewLine> lines;

  @override
  Widget build(BuildContext context) {
    final TextStyle dim = AppTypography.code(
      color: AppColors.muted,
      height: 1.95,
    );
    final TextStyle add = AppTypography.code(height: 1.95);
    final TextStyle marker = AppTypography.code(weight: 700, height: 1.95);

    return Text.rich(
      TextSpan(
        children: [
          for (final line in lines) ...[
            if (line.added) TextSpan(text: '+ ', style: marker),
            TextSpan(text: '${line.text}\n', style: line.added ? add : dim),
          ],
        ],
      ),
    );
  }
}

/// Setup-steps pane: hairline rows with a doctor/guided tag each.
class StepsPaneWidget extends StatelessWidget {
  /// Creates the pane from derived [steps].
  const StepsPaneWidget({super.key, required this.steps});

  /// Steps of every enabled module, in catalogue order.
  final List<SetupStepEntity> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < steps.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.stepRowPadV,
            ),
            decoration: BoxDecoration(
              border: i < steps.length - 1
                  ? const Border(bottom: BorderSide(color: AppColors.line))
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i].label,
                        style: AppTypography.text(size: 13, height: 1.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        steps[i].kind == SetupStepKind.doctor
                            ? 'verified by doctor CLI'
                            : 'guided — deep link + confirm',
                        style: AppTypography.text(
                          size: 10.5,
                          color: AppColors.muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                SetupTagWidget(kind: steps[i].kind),
              ],
            ),
          ),
      ],
    );
  }
}
