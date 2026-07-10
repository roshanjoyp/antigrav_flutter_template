import 'package:craft_flutter_template/app/config/onboarding_overrides.dart';
import 'package:craft_flutter_template/core/config/app_env.dart';
import 'package:craft_flutter_template/core/config/app_flavor.dart';
import 'package:craft_flutter_template/core/services/storage_service/storage_service_impl.dart';
import 'package:craft_flutter_template/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:craft_flutter_template/features/startup/presentation/startup_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Onboarding's first-run behavior through the startup hook, wired the
/// same way `main.dart` does it ([onboardingOverrides]).
void main() {
  group('onboarding first-run redirect', () {
    setUp(() => AppFlavor.initialize(AppEnv.development));
    tearDown(AppFlavor.reset);

    /// Runs startup with onboarding wired in against [storage] (or the
    /// default storage when null) and returns the destination.
    Future<String?> destinationWith(InMemoryStorageService? storage) async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          ...onboardingOverrides(),
          if (storage != null)
            storageServiceProvider.overrideWith((ref) => storage),
        ],
      );
      addTearDown(container.dispose);
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

    test('redirects a first run to onboarding', () async {
      expect(await destinationWith(InMemoryStorageService()), '/onboarding');
    });

    test('resolves to home once onboarding is seen', () async {
      final InMemoryStorageService storage = InMemoryStorageService();
      await OnboardingRepositoryImpl(storage).markOnboardingSeen();

      expect(await destinationWith(storage), '/');
    });

    test('falls back to home when storage is unavailable', () async {
      // No storage override: the default secure-storage plugin is
      // missing in tests, so the seen check fails — the redirect must
      // treat that as "seen" rather than trap the user in onboarding.
      expect(await destinationWith(null), '/');
    });
  });
}
