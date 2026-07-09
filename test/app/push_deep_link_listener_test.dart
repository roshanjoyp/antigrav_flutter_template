import 'package:antigrav_flutter_template/app/config/push_deep_link_listener.dart';
import 'package:antigrav_flutter_template/app/router/app_router.dart';
import 'package:antigrav_flutter_template/core/config/app_env.dart';
import 'package:antigrav_flutter_template/core/config/app_flavor.dart';
import 'package:antigrav_flutter_template/core/services/push_service/push_service.dart';
import 'package:antigrav_flutter_template/core/services/push_service/push_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

/// Mocktail mock of the app router.
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGoRouter router;
  late ProviderContainer container;

  setUp(() {
    // LoggerLogService reads the active flavor on construction.
    AppFlavor.initialize(AppEnv.development);
    router = MockGoRouter();
    container = ProviderContainer(
      overrides: [goRouterProvider.overrideWith((ref) => router)],
    );
    // Activate the listener the way the App widget does (a watch);
    // a bare read could leave the provider paused in Riverpod 3.
    container.listen(pushDeepLinkListenerProvider, (_, _) {});
  });

  tearDown(() {
    container.dispose();
    AppFlavor.reset();
  });

  DebugPushService pushService() =>
      container.read(pushServiceProvider) as DebugPushService;

  group('pushDeepLinkListener', () {
    test('navigates to the route of a tapped notification', () async {
      when(() => router.go(any())).thenReturn(null);

      pushService().simulateMessageOpened(
        const PushMessage(data: <String, Object?>{'route': '/profile'}),
      );
      await Future<void>.delayed(Duration.zero);

      verify(() => router.go('/profile')).called(1);
    });

    test('ignores tapped notifications without a route', () async {
      pushService().simulateMessageOpened(
        const PushMessage(title: 'No route here'),
      );
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => router.go(any()));
    });

    test('foreground messages do not navigate', () async {
      pushService().simulateForegroundMessage(
        const PushMessage(data: <String, Object?>{'route': '/profile'}),
      );
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => router.go(any()));
    });
  });
}
