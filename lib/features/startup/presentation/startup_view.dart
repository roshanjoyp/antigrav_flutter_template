import 'package:antigrav_flutter_template/features/startup/presentation/startup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StartupView extends ConsumerStatefulWidget {
  const StartupView({super.key});

  @override
  ConsumerState<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends ConsumerState<StartupView> {
  @override
  void initState() {
    super.initState();
    // Trigger startup logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(startupControllerProvider.notifier).runStartupLogic();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keep the controller alive while this view is mounted.
    // Without this, the autoDispose provider disposes immediately after initState, causing a crash.
    ref.watch(startupControllerProvider);

    // Note: Auto-navigation removed for Test Control Panel purpose.

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 24),
            const Text(
              'AntiGrav Template',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home),
              label: const Text('Go to Home'),
            ),
            const SizedBox(height: 16),
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
