import 'package:craft_flutter_template/features/onboarding/onboarding.dart'; // MODULE(onboarding)
import 'package:craft_flutter_template/features/paywall/paywall.dart'; // MODULE(revenuecat)
import 'package:craft_flutter_template/features/profile/profile.dart';
import 'package:craft_flutter_template/features/setup_status/setup_status.dart';
import 'package:craft_flutter_template/features/startup/startup.dart';
import 'package:craft_flutter_template/features/test_control_panel/test_control_panel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/startup',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/startup',
        builder: (context, state) => const StartupView(),
      ),
      // Dev-only routes: compiled out of release builds entirely.
      if (kDebugMode) ...[
        GoRoute(path: '/test', builder: (context, state) => const TestScreen()),
        GoRoute(
          path: '/setup-status',
          builder: (context, state) => const SetupStatusScreen(),
        ),
      ],
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      // MODULE(revenuecat): begin
      GoRoute(
        path: '/paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      // MODULE(revenuecat): end
      // MODULE(onboarding): begin
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // MODULE(onboarding): end
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Home Page Placeholder'))),
      ),
    ],
  );
}
