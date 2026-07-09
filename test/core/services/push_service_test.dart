import 'package:craft_flutter_template/core/services/permissions/permission_service.dart';
import 'package:craft_flutter_template/core/services/push_service/firebase_push_service_impl.dart';
import 'package:craft_flutter_template/core/services/push_service/push_service.dart';
import 'package:craft_flutter_template/core/services/push_service/push_service_impl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

import 'debug_services_test.dart' show RecordingLogService;

/// Mocktail mock of the FCM SDK entry point.
class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

/// Mocktail mock of the app's permission service.
class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late RecordingLogService logger;

  setUpAll(() => registerFallbackValue(Permission.notification));
  setUp(() => logger = RecordingLogService());

  group('PushMessage', () {
    test('route reads the "route" data key when it is a string', () {
      const PushMessage withRoute = PushMessage(
        data: <String, Object?>{'route': '/profile'},
      );
      const PushMessage withoutRoute = PushMessage(
        data: <String, Object?>{'other': 1},
      );
      const PushMessage nonString = PushMessage(
        data: <String, Object?>{'route': 42},
      );

      expect(withRoute.route, '/profile');
      expect(withoutRoute.route, isNull);
      expect(nonString.route, isNull);
    });
  });

  group('DebugPushService', () {
    test('grants permission, serves the debug token, accepts topics', () async {
      final DebugPushService service = DebugPushService(logger);

      expect(await service.requestPermission(), isTrue);
      final token = await service.getToken();
      expect(token.getOrNull(), DebugPushService.debugToken);
      expect((await service.subscribeToTopic('news')).isSuccess, isTrue);
      expect((await service.unsubscribeFromTopic('news')).isSuccess, isTrue);
      expect(await service.getInitialMessage(), isNull);
      expect(logger.lines, isNotEmpty);

      service.dispose();
    });

    test('simulated messages reach the corresponding streams', () async {
      final DebugPushService service = DebugPushService(logger);
      final List<PushMessage> foreground = <PushMessage>[];
      final List<PushMessage> opened = <PushMessage>[];
      service.onForegroundMessage.listen(foreground.add);
      service.onMessageOpened.listen(opened.add);

      service.simulateForegroundMessage(const PushMessage(title: 'hi'));
      service.simulateMessageOpened(
        const PushMessage(data: <String, Object?>{'route': '/profile'}),
      );
      await Future<void>.delayed(Duration.zero);

      expect(foreground.single.title, 'hi');
      expect(opened.single.route, '/profile');

      service.dispose();
    });
  });

  group('FirebasePushServiceImpl', () {
    late MockFirebaseMessaging messaging;
    late MockPermissionService permissions;
    late FirebasePushServiceImpl service;

    setUp(() {
      messaging = MockFirebaseMessaging();
      permissions = MockPermissionService();
      service = FirebasePushServiceImpl(
        permissions,
        logger,
        messaging: messaging,
      );
    });

    test('mapRemoteMessage maps notification and data payload', () {
      final PushMessage message = FirebasePushServiceImpl.mapRemoteMessage(
        const RemoteMessage(
          notification: RemoteNotification(title: 'Hello', body: 'World'),
          data: <String, Object?>{'route': '/paywall'},
        ),
      );

      expect(message.title, 'Hello');
      expect(message.body, 'World');
      expect(message.route, '/paywall');
    });

    test('requestPermission goes through PermissionService and enables '
        'foreground presentation when granted', () async {
      when(
        () => permissions.requestPermission(any()),
      ).thenAnswer((_) async => true);
      when(
        () => messaging.setForegroundNotificationPresentationOptions(
          alert: any(named: 'alert'),
          badge: any(named: 'badge'),
          sound: any(named: 'sound'),
        ),
      ).thenAnswer((_) async {});

      expect(await service.requestPermission(), isTrue);
      verify(
        () => permissions.requestPermission(Permission.notification),
      ).called(1);
      verify(
        () => messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        ),
      ).called(1);
    });

    test('requestPermission skips presentation options when denied', () async {
      when(
        () => permissions.requestPermission(any()),
      ).thenAnswer((_) async => false);

      expect(await service.requestPermission(), isFalse);
      verifyNever(
        () => messaging.setForegroundNotificationPresentationOptions(
          alert: any(named: 'alert'),
          badge: any(named: 'badge'),
          sound: any(named: 'sound'),
        ),
      );
    });

    test('getToken returns the token on success', () async {
      when(() => messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      expect((await service.getToken()).getOrNull(), 'fcm-token');
    });

    test('getToken maps failures to push/token-failed and logs', () async {
      when(() => messaging.getToken()).thenThrow(StateError('no apns'));

      final result = await service.getToken();
      expect(result.isFailure, isTrue);
      result.fold(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (exception) => expect(exception.code, 'push/token-failed'),
      );
      expect(logger.lines.single, contains('token'));
    });

    test('getInitialMessage maps the launching notification', () async {
      when(() => messaging.getInitialMessage()).thenAnswer(
        (_) async =>
            const RemoteMessage(data: <String, Object?>{'route': '/profile'}),
      );
      final PushMessage? message = await service.getInitialMessage();
      expect(message?.route, '/profile');
    });

    test('subscribeToTopic maps failures to push/subscribe-failed', () async {
      when(
        () => messaging.subscribeToTopic(any()),
      ).thenThrow(StateError('offline'));

      final result = await service.subscribeToTopic('news');
      result.fold(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (exception) =>
            expect(exception.code, 'push/subscribe-failed'),
      );
    });
  });
}
