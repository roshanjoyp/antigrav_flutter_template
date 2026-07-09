import 'package:antigrav_flutter_template/core/config/app_env.dart';
import 'package:antigrav_flutter_template/core/config/app_flavor.dart';
import 'package:antigrav_flutter_template/features/startup/presentation/startup_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StartupController', () {
    // StartupController logs via LogService, whose logger is configured
    // from AppFlavor — initialize it like main.dart does.
    setUp(() => AppFlavor.initialize(AppEnv.development));
    tearDown(AppFlavor.reset);

    test('starts with no destination', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(startupControllerProvider).value, isNull);
    });

    test('runStartupLogic resolves to the home route', () async {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);

      // Riverpod 3 pauses providers nobody listens to — keep the
      // controller alive for the whole test, like a mounted view would.
      container.listen(startupControllerProvider, (_, _) {});

      await container
          .read(startupControllerProvider.notifier)
          .runStartupLogic();

      final AsyncValue<String?> state = container.read(
        startupControllerProvider,
      );
      expect(state.hasError, isFalse);
      expect(state.value, '/');
    });
  });
}
