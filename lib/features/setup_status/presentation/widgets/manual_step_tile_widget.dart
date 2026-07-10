import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:craft_flutter_template/core/widgets/app_icon_badge.dart';
import 'package:craft_flutter_template/core/widgets/app_text.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/widgets/reference_chip_widget.dart';
import 'package:flutter/material.dart';

/// One manual (console/dashboard) setup step on the Setup Status screen.
///
/// Manual steps can't be machine-verified, so the tile shows the
/// step's instructions plus its console link and doc path as reference
/// chips for the developer to follow by hand.
class ManualStepTileWidget extends StatelessWidget {
  /// Creates a tile for the manual [step].
  const ManualStepTileWidget({super.key, required this.step});

  /// The manifest step this tile represents.
  final SetupStep step;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const AppIconBadge(
        icon: Icons.front_hand_outlined,
        color: AppColors.warning,
        background: AppColors.warningLight,
      ),
      title: Text(step.title),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppConstants.spaceXxs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(step.remediation),
            if (step.link != null || step.docPath != null)
              Padding(
                padding: const EdgeInsets.only(top: AppConstants.spaceXs),
                child: Wrap(
                  spacing: AppConstants.spaceXs,
                  runSpacing: AppConstants.spaceXxs,
                  children: [
                    if (step.link != null)
                      ReferenceChipWidget(icon: Icons.link, label: step.link!),
                    if (step.docPath != null)
                      ReferenceChipWidget(
                        icon: Icons.description_outlined,
                        label: step.docPath!,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      trailing: AppText.caption('MANUAL', color: AppColors.warning),
    );
  }
}
