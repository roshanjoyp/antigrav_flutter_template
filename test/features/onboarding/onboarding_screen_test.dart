import 'package:antigrav_flutter_template/core/services/storage_service/storage_service_impl.dart';
import 'package:antigrav_flutter_template/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:antigrav_flutter_template/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  late InMemoryStorageService storage;

  setUp(() => storage = InMemoryStorageService());

  Widget buildApp() => ProviderScope(
    overrides: [storageServiceProvider.overrideWith((ref) => storage)],
    child: MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/onboarding',
        routes: [
          GoRoute(
            path: '/onboarding',
            builder: (context, state) => const OnboardingScreen(),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('HOME')),
          ),
        ],
      ),
    ),
  );

  Future<bool> seenFlag() async {
    final repository = OnboardingRepositoryImpl(storage);
    return (await repository.hasSeenOnboarding()).getOrElse(false);
  }

  group('OnboardingScreen', () {
    testWidgets('pages advance with Next until Get started', (tester) async {
      await tester.pumpWidget(buildApp());

      expect(find.text('Welcome aboard'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Stub-first services'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Ready when you are'), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
      expect(find.text('Next'), findsNothing);
    });

    testWidgets('Get started persists the flag and goes home', (tester) async {
      await tester.pumpWidget(buildApp());

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();

      expect(find.text('HOME'), findsOneWidget);
      expect(await seenFlag(), isTrue);
    });

    testWidgets('Skip persists the flag and goes home', (tester) async {
      await tester.pumpWidget(buildApp());

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.text('HOME'), findsOneWidget);
      expect(await seenFlag(), isTrue);
    });
  });
}
