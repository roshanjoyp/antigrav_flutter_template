import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/core/setup/checklist/checklist_document.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:craft_flutter_template/features/setup_status/domain/module_enablement.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/readiness_controller.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/widgets/module_section_widget.dart';
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
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spaceMd),
      children: [
        const AppInfoBanner(
          message:
              'State lives in checklist.yaml (git-tracked). Edit the file '
              'to mark items done or skipped, then hot restart.',
          icon: Icons.edit_note,
        ),
        SwitchListTile(
          title: const Text('Show skipped items'),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceXs,
          ),
          value: showSkipped,
          onChanged: (_) =>
              ref.read(showSkippedReadinessProvider.notifier).toggle(),
        ),
        for (final SetupModule module in SetupModule.values)
          ?_moduleSection(module, doc, showSkipped),
        ?_customSection(doc, showSkipped),
      ],
    );
  }

  /// The readiness panel for one module, or `null` when the module is
  /// disabled, declares no items, or everything is filtered out.
  Widget? _moduleSection(
    SetupModule module,
    ChecklistDocument doc,
    bool showSkipped,
  ) {
    if (!isModuleEnabled(module)) return null;
    final List<ReadinessItem> items = SetupManifest.readinessForModule(module)
        .where(
          (ReadinessItem item) =>
              showSkipped ||
              doc.entryFor(item.id).status != ChecklistStatus.skipped,
        )
        .toList();
    if (items.isEmpty) return null;
    return ModuleSectionWidget(
      title: module.displayName,
      children: [
        for (final ReadinessItem item in items)
          ReadinessItemTileWidget(item: item, entry: doc.entryFor(item.id)),
      ],
    );
  }

  /// The custom-tasks panel, or `null` when there is nothing to show.
  Widget? _customSection(ChecklistDocument doc, bool showSkipped) {
    final List<CustomChecklistTask> tasks = doc.custom
        .where(
          (CustomChecklistTask task) =>
              showSkipped || task.status != ChecklistStatus.skipped,
        )
        .toList();
    if (tasks.isEmpty) return null;
    return ModuleSectionWidget(
      title: 'Custom tasks',
      children: [
        for (final CustomChecklistTask task in tasks)
          ListTile(
            leading: AppIconBadge(
              icon: task.status == ChecklistStatus.done
                  ? Icons.check_rounded
                  : Icons.circle_outlined,
              color: task.status == ChecklistStatus.done
                  ? AppColors.success
                  : AppColors.textSecondary,
              background: task.status == ChecklistStatus.done
                  ? AppColors.successLight
                  : AppColors.backgroundTertiary,
            ),
            title: Text(task.title),
            subtitle: task.owner == null ? null : Text('Owner: ${task.owner}'),
          ),
      ],
    );
  }
}
