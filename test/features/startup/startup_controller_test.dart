import 'package:craft_flutter_template/core/config/app_env.dart';
import 'package:craft_flutter_template/core/config/app_flavor.dart';
import 'package:craft_flutter_template/features/startup/domain/first_run_redirect.dart';
import 'package:craft_flutter_template/features/startup/presentation/startup_controller.dart';
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

    /// Runs the startup logic in [container] and returns the resolved
    /// destination.
    Future<String?> destinationIn(ProviderContainer container) async {
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
      return state.value;
    }

    test('resolves to home when no first-run hook is installed', () async {
      expect(await destinationIn(ProviderContainer()), '/');
    });

    test('follows the first-run hook when one resolves a route', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          firstRunRedirectProvider.overrideWith((Ref ref) async => '/welcome'),
        ],
      );
      expect(await destinationIn(container), '/welcome');
    });

    test('proceeds to home when the hook resolves null', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          firstRunRedirectProvider.overrideWith((Ref ref) async => null),
        ],
      );
      expect(await destinationIn(container), '/');
    });
  });
}
