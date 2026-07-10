import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:flutter/material.dart';

/// One manual (console/dashboard) setup step on the Setup Status screen.
///
/// Manual steps can't be machine-verified, so the tile shows the
/// step's remediation instructions and its console link / doc path for
/// the developer to follow by hand.
class ManualStepTileWidget extends StatelessWidget {
  /// Creates a tile for the manual [step].
  const ManualStepTileWidget({super.key, required this.step});

  /// The manifest step this tile represents.
  final SetupStep step;

  @override
  Widget build(BuildContext context) {
    final List<String> references = [
      if (step.link != null) step.link!,
      if (step.docPath != null) 'See ${step.docPath}',
    ];
    return ListTile(
      leading: const Icon(
        Icons.touch_app_outlined,
        color: AppColors.warning,
        size: AppConstants.iconSm,
      ),
      title: Text(step.title),
      subtitle: Text([step.remediation, ...references].join('\n')),
      isThreeLine: references.isNotEmpty,
    );
  }
}
