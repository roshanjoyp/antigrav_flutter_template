import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/setup/checklist/checklist_document.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:flutter/material.dart';

/// One production-readiness row: recorded status, what/why, references.
///
/// Renders the state recorded in `checklist.yaml`; auto-checked items
/// carry a badge reminding that `dart run tool/doctor.dart` verifies
/// them regardless of the recorded status.
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
    final (IconData icon, Color color) = switch (entry.status) {
      ChecklistStatus.done => (Icons.check_circle, AppColors.success),
      ChecklistStatus.pending => (
        Icons.radio_button_unchecked,
        AppColors.textTertiary,
      ),
      ChecklistStatus.skipped => (
        Icons.remove_circle_outline,
        AppColors.textDisabled,
      ),
    };
    final List<String> lines = [
      item.why,
      if (entry.reason != null) 'Skipped: ${entry.reason}',
      if (entry.owner != null) 'Owner: ${entry.owner}',
      if (item.link != null) item.link!,
      if (item.docPath != null) 'See ${item.docPath}',
    ];
    return ListTile(
      leading: Icon(icon, color: color, size: AppConstants.iconSm),
      title: Text(item.title),
      subtitle: Text(lines.join('\n')),
      isThreeLine: lines.length > 1,
      trailing: item.hasAutoCheck
          ? const Tooltip(
              message: 'Verified by dart run tool/doctor.dart',
              child: Icon(
                Icons.verified_outlined,
                size: AppConstants.iconSm,
                color: AppColors.info,
              ),
            )
          : null,
    );
  }
}
