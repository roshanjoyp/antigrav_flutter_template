import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:craft_flutter_template/features/setup_status/domain/runtime_check_entity.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/setup_status_controller.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/widgets/manual_step_tile_widget.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/widgets/runtime_check_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The Setup tab: the manifest's runtime and manual setup steps per
/// module, with live check states from [SetupStatusController].
class SetupChecksTabWidget extends ConsumerWidget {
  /// Creates the Setup tab body.
  const SetupChecksTabWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, RuntimeCheckEntity> checks = ref.watch(
      setupStatusControllerProvider,
    );
    final SetupStatusController controller = ref.read(
      setupStatusControllerProvider.notifier,
    );
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spaceMd),
      children: [
        AppText.bodySmall(
          'Static checks (rename, placeholders, generated files) run '
          'from the CLI: dart run tool/doctor.dart',
          color: AppColors.textSecondary,
        ),
        for (final SetupModule module in SetupModule.values)
          ..._moduleSection(module, checks, controller),
      ],
    );
  }

  /// The header, runtime tiles, and manual tiles for one module, or
  /// nothing when the module declares no in-app steps.
  List<Widget> _moduleSection(
    SetupModule module,
    Map<String, RuntimeCheckEntity> checks,
    SetupStatusController controller,
  ) {
    final List<SetupStep> steps = SetupManifest.stepsForModule(module)
        .where((SetupStep step) => step.kind != SetupCheckKind.staticCheck)
        .toList();
    if (steps.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceXs),
        child: AppText.headingSmall(module.name),
      ),
      for (final SetupStep step in steps)
        step.kind == SetupCheckKind.runtimeCheck
            ? RuntimeCheckTileWidget(
                step: step,
                check: checks[step.id]!,
                onRun: () => controller.run(step.id),
              )
            : ManualStepTileWidget(step: step),
      const AppDivider(),
    ];
  }
}
