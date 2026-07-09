import 'package:antigrav_flutter_template/core/config/app_env.dart';
import 'package:antigrav_flutter_template/core/config/app_flavor.dart';
import 'package:antigrav_flutter_template/core/services/storage_service/storage_service_impl.dart';
import 'package:antigrav_flutter_template/features/onboarding/data/onboarding_repository_impl.dart';
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

    /// Runs the startup logic against [storage] and returns the
    /// resolved destination.
    Future<String?> destinationWith(InMemoryStorageService storage) async {
      final ProviderContainer container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWith((ref) => storage)],
      );
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

    test('runStartupLogic redirects a first run to onboarding', () async {
      expect(await destinationWith(InMemoryStorageService()), '/onboarding');
    });

    test('runStartupLogic resolves to home once onboarding is seen', () async {
      final InMemoryStorageService storage = InMemoryStorageService();
      await OnboardingRepositoryImpl(storage).markOnboardingSeen();

      expect(await destinationWith(storage), '/');
    });

    test(
      'runStartupLogic falls back to home when storage is unavailable',
      () async {
        // No storage override: the default secure-storage plugin is
        // missing in tests, so the seen check fails — startup must treat
        // that as "seen" rather than trap the user in onboarding.
        final ProviderContainer container = ProviderContainer();
        addTearDown(container.dispose);
        container.listen(startupControllerProvider, (_, _) {});

        await container
            .read(startupControllerProvider.notifier)
            .runStartupLogic();

        expect(container.read(startupControllerProvider).value, '/');
      },
    );
  });
}
