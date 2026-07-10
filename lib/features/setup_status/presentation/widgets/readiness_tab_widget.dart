import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/core/setup/checklist/checklist_document.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:craft_flutter_template/features/setup_status/domain/module_enablement.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/readiness_controller.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/widgets/readiness_item_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The Readiness tab: production-readiness items for enabled modules
/// plus custom tasks, with state read from the bundled `checklist.yaml`.
class ReadinessTabWidget extends ConsumerWidget {
  /// Creates the Readiness tab body.
  const ReadinessTabWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ChecklistDocument> checklist = ref.watch(
      readinessChecklistProvider,
    );
    final bool showSkipped = ref.watch(showSkippedReadinessProvider);
    return switch (checklist) {
      AsyncData<ChecklistDocument>(value: final ChecklistDocument doc) => _list(
        ref,
        doc,
        showSkipped,
      ),
      AsyncError<ChecklistDocument>(error: final Object error) => AppError(
        message: 'Could not load checklist.yaml: $error',
        onRetry: () => ref.invalidate(readinessChecklistProvider),
      ),
      _ => const AppLoading(),
    };
  }

  Widget _list(WidgetRef ref, ChecklistDocument doc, bool showSkipped) {
    final List<ReadinessItem> items = SetupManifest.allReadinessItems
        .where((ReadinessItem item) => isModuleEnabled(item.module))
        .where(
          (ReadinessItem item) =>
              showSkipped ||
              doc.entryFor(item.id).status != ChecklistStatus.skipped,
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spaceMd),
      children: [
        AppText.bodySmall(
          'State lives in checklist.yaml (git-tracked). Edit the file to '
          'mark items done or skipped, then hot restart.',
          color: AppColors.textSecondary,
        ),
        SwitchListTile(
          title: const Text('Show skipped items'),
          value: showSkipped,
          onChanged: (_) =>
              ref.read(showSkippedReadinessProvider.notifier).toggle(),
        ),
        for (final ReadinessItem item in items)
          ReadinessItemTileWidget(item: item, entry: doc.entryFor(item.id)),
        if (doc.custom.isNotEmpty) ...[
          const AppDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceXs),
            child: AppText.headingSmall('Custom tasks'),
          ),
          for (final CustomChecklistTask task in doc.custom)
            if (showSkipped || task.status != ChecklistStatus.skipped)
              ListTile(
                leading: Icon(
                  task.status == ChecklistStatus.done
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.status == ChecklistStatus.done
                      ? AppColors.success
                      : AppColors.textTertiary,
                  size: AppConstants.iconSm,
                ),
                title: Text(task.title),
                subtitle: task.owner == null
                    ? null
                    : Text('Owner: ${task.owner}'),
              ),
        ],
      ],
    );
  }
}
