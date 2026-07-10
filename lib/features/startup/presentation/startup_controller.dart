import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:craft_flutter_template/features/startup/domain/first_run_redirect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'startup_controller.g.dart';

@Riverpod(keepAlive: true)
class StartupController extends _$StartupController {
  @override
  FutureOr<String?> build() {
    return null; // Initial state: no route determined
  }

  Future<void> runStartupLogic() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final logger = ref.read(logServiceProvider);
      logger.info('Running Startup Logic...');

      // 1. Check for updates? (Handled by UpdateService wrapper usually, but we could enforce it here)
      // 2. Initialize critical services if needed

      // 3. Check Auth State
      final start = DateTime.now();
      // await ref.read(authRepositoryProvider).initialize(); // If needed

      // Artificial delay for splash screen visibility (optional)
      final elapsed = DateTime.now().difference(start);
      if (elapsed < AppConstants.durationSplash) {
        await Future.delayed(AppConstants.durationSplash - elapsed);
      }

      // Determine destination via the first-run hook. Features that
      // want to intercept a fresh launch (onboarding, forced auth, …)
      // override firstRunRedirectProvider — startup doesn't know them.
      final String? redirect = await ref.read(firstRunRedirectProvider.future);
      if (redirect != null) {
        logger.info('Startup Logic Complete. First-run redirect: $redirect.');
        return redirect;
      }

      // Ideally also check if the user is logged in and route to auth
      // when not. The stub template has no persisted session, so home
      // is the default destination.
      logger.info('Startup Logic Complete. Navigating to Home.');
      return '/';
    });
  }
}
