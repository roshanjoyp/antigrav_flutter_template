import 'package:antigrav_flutter_template/core/core.dart';
import 'package:antigrav_flutter_template/features/startup/presentation/startup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The startup/splash screen shown while the app initialises.
///
/// Triggers [StartupController.runStartupLogic] on mount and presents
/// navigation options to the home screen and the service test panel.
class StartupView extends ConsumerStatefulWidget {
  /// Creates a [StartupView].
  const StartupView({super.key});

  @override
  ConsumerState<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends ConsumerState<StartupView> {
  @override
  void initState() {
    super.initState();
    // Trigger startup logic after the first frame so the widget tree is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(startupControllerProvider.notifier).runStartupLogic();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keep the controller alive while this view is mounted.
    // Without this, the autoDispose provider disposes immediately after
    // initState, causing a crash.
    ref.watch(startupControllerProvider);

    // Note: Auto-navigation removed for Test Control Panel purpose.

    return AppScaffold(
      useSafeArea: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: AppConstants.space5xl),
            const SizedBox(height: AppConstants.spaceXl),
            AppText.headingMedium(
              'AntiGrav Template',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.space4xl),
            const AppLoading(message: 'Starting up...'),
            const SizedBox(height: AppConstants.space4xl),
            AppButton(
              label: 'Go to Home',
              onPressed: () => context.go('/'),
              isFullWidth: false,
            ),
            const SizedBox(height: AppConstants.spaceMd),
            OutlinedButton.icon(
              onPressed: () => context.go('/test'),
              icon: const Icon(Icons.build),
              label: const Text('Test Services'),
            ),
          ],
        ),
      ),
    );
  }
}
