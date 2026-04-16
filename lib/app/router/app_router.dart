import 'package:antigrav_flutter_template/features/startup/startup.dart';
import 'package:antigrav_flutter_template/features/test_control_panel/test_control_panel.dart';
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
      GoRoute(path: '/test', builder: (context, state) => const TestScreen()),
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Home Page Placeholder'))),
      ),
    ],
  );
}
