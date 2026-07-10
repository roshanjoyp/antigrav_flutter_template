import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:craft_flutter_template/features/setup_status/domain/runtime_check_entity.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/setup_status_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('manifest ↔ controller binding', () {
    test('every runtime step declared in the manifest is implemented', () {
      final Set<String> declared = SetupManifest.stepsOfKind(
        SetupCheckKind.runtimeCheck,
      ).map((SetupStep step) => step.id).toSet();
      expect(SetupStatusController.handledStepIds, declared);
    });
  });

  group('SetupStatusController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('starts with one state per runtime step in the manifest', () {
      final Map<String, RuntimeCheckEntity> state = container.read(
        setupStatusControllerProvider,
      );
      expect(
        state.keys.toSet(),
        SetupManifest.stepsOfKind(
          SetupCheckKind.runtimeCheck,
        ).map((SetupStep step) => step.id).toSet(),
      );
    });

    test('marks disabled modules skipped in the stub template', () {
      // The template ships with FirebaseConfig.enabled = false, so every
      // Firebase/push runtime check must start skipped, never failed.
      final Map<String, RuntimeCheckEntity> state = container.read(
        setupStatusControllerProvider,
      );
      for (final RuntimeCheckEntity check in state.values) {
        expect(
          check.status,
          RuntimeCheckStatus.skipped,
          reason: '${check.stepId} should be skipped while modules are off',
        );
      }
    });

    test('run() leaves a skipped check untouched', () async {
      final SetupStatusController controller = container.read(
        setupStatusControllerProvider.notifier,
      );
      await controller.run('firebase.initializes');
      expect(
        container
            .read(setupStatusControllerProvider)['firebase.initializes']!
            .status,
        RuntimeCheckStatus.skipped,
      );
    });

    test('runAll() completes without touching skipped checks', () async {
      final SetupStatusController controller = container.read(
        setupStatusControllerProvider.notifier,
      );
      await controller.runAll();
      final Map<String, RuntimeCheckEntity> state = container.read(
        setupStatusControllerProvider,
      );
      for (final RuntimeCheckEntity check in state.values) {
        expect(check.status, RuntimeCheckStatus.skipped);
      }
    });
  });
}
