import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/features/configurator/domain/setup_step_entity.dart';

/// Verification tag on a setup step: `doctor` renders solid (machine
/// verified), `guided` renders as a quiet outline (console work).
class SetupTagWidget extends StatelessWidget {
  /// Creates the tag for [kind].
  const SetupTagWidget({super.key, required this.kind});

  /// The step's verification kind.
  final SetupStepKind kind;

  @override
  Widget build(BuildContext context) {
    final bool solid = kind == SetupStepKind.doctor;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 3, 8, 2),
      decoration: BoxDecoration(
        color: solid ? AppColors.fg : Colors.transparent,
        border: solid ? null : Border.all(color: AppColors.line),
      ),
      child: Text(
        solid ? 'DOCTOR' : 'GUIDED',
        style: AppTypography.disp(
          size: 8,
          weight: 500,
          trackingEm: 0.24,
          color: solid ? AppColors.bg : AppColors.muted,
        ),
      ),
    );
  }
}
