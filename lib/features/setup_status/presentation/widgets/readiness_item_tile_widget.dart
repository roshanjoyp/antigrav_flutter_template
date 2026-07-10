import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/setup/checklist/checklist_document.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:craft_flutter_template/core/widgets/app_icon_badge.dart';
import 'package:craft_flutter_template/core/widgets/app_text.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/widgets/reference_chip_widget.dart';
import 'package:flutter/material.dart';

/// One production-readiness row: recorded status, what/why, references.
///
/// Renders the state recorded in `checklist.yaml`; auto-checked items
/// carry an AUTO tag reminding that `dart run tool/doctor.dart`
/// verifies them regardless of the recorded status.
class ReadinessItemTileWidget extends StatelessWidget {
  /// Creates a tile for [item] with its recorded [entry].
  const ReadinessItemTileWidget({
    super.key,
    required this.item,
    required this.entry,
  });

  /// The manifest readiness item.
  final ReadinessItem item;

  /// The state recorded for it in `checklist.yaml`.
  final ChecklistEntry entry;

  @override
  Widget build(BuildContext context) {
    final (
      IconData icon,
      Color color,
      Color background,
    ) = switch (entry.status) {
      ChecklistStatus.done => (
        Icons.check_rounded,
        AppColors.success,
        AppColors.successLight,
      ),
      ChecklistStatus.pending => (
        Icons.circle_outlined,
        AppColors.textSecondary,
        AppColors.backgroundTertiary,
      ),
      ChecklistStatus.skipped => (
        Icons.remove_rounded,
        AppColors.textDisabled,
        AppColors.backgroundSecondary,
      ),
    };
    return ListTile(
      leading: AppIconBadge(icon: icon, color: color, background: background),
      title: Text(item.title),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppConstants.spaceXxs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.why),
            if (entry.reason != null) Text('Skipped: ${entry.reason}'),
            if (entry.owner != null) Text('Owner: ${entry.owner}'),
            if (item.link != null || item.docPath != null)
              Padding(
                padding: const EdgeInsets.only(top: AppConstants.spaceXs),
                child: Wrap(
                  spacing: AppConstants.spaceXs,
                  runSpacing: AppConstants.spaceXxs,
                  children: [
                    if (item.link != null)
                      ReferenceChipWidget(icon: Icons.link, label: item.link!),
                    if (item.docPath != null)
                      ReferenceChipWidget(
                        icon: Icons.description_outlined,
                        label: item.docPath!,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      trailing: item.hasAutoCheck
          ? Tooltip(
              message: 'Verified by dart run tool/doctor.dart',
              child: AppText.caption('AUTO', color: AppColors.info),
            )
          : null,
    );
  }
}
