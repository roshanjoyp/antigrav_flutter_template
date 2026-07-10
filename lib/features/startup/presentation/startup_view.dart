import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/features/startup/presentation/startup_controller.dart';
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

    // Note: Auto-navigation to home removed for Test Control Panel
    // purpose — this screen stays up as the template's demo hub. The
    // one exception: a first-run redirect resolved by the startup hook
    // (any route other than home) is followed immediately.
    ref.listen(startupControllerProvider, (previous, next) {
      final String? route = next.value;
      if (route != null && route != '/') context.go(route);
    });

    return AppScaffold(
      useSafeArea: true,
      body: Center(
        // Scrollable so the growing list of example links never
        // overflows on small screens.
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlutterLogo(size: AppConstants.space5xl),
              const SizedBox(height: AppConstants.spaceXl),
              AppText.headingMedium(
                'Craft Template',
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
                onPressed: () => context.push('/test'),
                icon: const Icon(Icons.build),
                label: const Text('Test Services'),
              ),
              const SizedBox(height: AppConstants.spaceMd),
              OutlinedButton.icon(
                onPressed: () => context.push('/profile'),
                icon: const Icon(Icons.person),
                label: const Text('Profile Example'),
              ),
              const SizedBox(height: AppConstants.spaceMd),
              OutlinedButton.icon(
                onPressed: () => context.push('/paywall'),
                icon: const Icon(Icons.workspace_premium),
                label: const Text('Paywall Example'),
              ),
              const SizedBox(height: AppConstants.spaceMd),
              OutlinedButton.icon(
                onPressed: () => context.push('/onboarding'),
                icon: const Icon(Icons.explore),
                label: const Text('Onboarding Example'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
