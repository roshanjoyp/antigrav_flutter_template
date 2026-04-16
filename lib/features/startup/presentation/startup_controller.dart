import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
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

      // Determine destination
      // Ideally check if user is logged in.
      // For now, let's assume we go to Home if logged in, or Auth if not.
      // Since we don't have a persisted session implementation yet in the stub,
      // we'll default to Home '/' for now to show the app works.

      logger.info('Startup Logic Complete. Navigating to Home.');
      return '/';
    });
  }
}
