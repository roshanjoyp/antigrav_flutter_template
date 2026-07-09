import 'package:craft_flutter_template/core/services/analytics_service/firebase_analytics_service_impl.dart';
import 'package:craft_flutter_template/core/services/crash_service/firebase_crash_service_impl.dart';
import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'debug_services_test.dart' show RecordingLogService;

/// Mocktail mock of the Crashlytics SDK.
class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

/// Mocktail mock of the Firebase Analytics SDK.
class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late RecordingLogService logger;

  setUpAll(() => registerFallbackValue(StackTrace.empty));
  setUp(() => logger = RecordingLogService());

  group('FirebaseCrashServiceImpl', () {
    late MockFirebaseCrashlytics crashlytics;
    late FirebaseCrashServiceImpl service;

    setUp(() {
      crashlytics = MockFirebaseCrashlytics();
      service = FirebaseCrashServiceImpl(logger, crashlytics: crashlytics);
    });

    test('delegates to Crashlytics', () async {
      when(
        () => crashlytics.recordError(
          any<dynamic>(),
          any(),
          reason: any<dynamic>(named: 'reason'),
          fatal: any(named: 'fatal'),
        ),
      ).thenAnswer((_) async {});
      when(() => crashlytics.log(any())).thenAnswer((_) async {});
      when(() => crashlytics.setUserIdentifier(any())).thenAnswer((_) async {});

      await service.recordError(StateError('boom'), null, fatal: true);
      await service.log('breadcrumb');
      await service.setUserIdentifier('user-1');

      verify(
        () => crashlytics.recordError(
          any<dynamic>(),
          any(),
          reason: any<dynamic>(named: 'reason'),
          fatal: true,
        ),
      ).called(1);
      verify(() => crashlytics.log('breadcrumb')).called(1);
      verify(() => crashlytics.setUserIdentifier('user-1')).called(1);
    });

    test('never throws when Crashlytics fails — logs instead', () async {
      when(
        () => crashlytics.recordError(
          any<dynamic>(),
          any(),
          reason: any<dynamic>(named: 'reason'),
          fatal: any(named: 'fatal'),
        ),
      ).thenThrow(StateError('crashlytics down'));

      await service.recordError(StateError('boom'), null);
      expect(logger.lines.single, contains('recordError failed'));
    });
  });

  group('FirebaseAnalyticsServiceImpl', () {
    late MockFirebaseAnalytics analytics;
    late FirebaseAnalyticsServiceImpl service;

    setUp(() {
      analytics = MockFirebaseAnalytics();
      service = FirebaseAnalyticsServiceImpl(logger, analytics: analytics);
    });

    test('delegates to Firebase Analytics', () async {
      when(
        () => analytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => analytics.logScreenView(screenName: any(named: 'screenName')),
      ).thenAnswer((_) async {});
      when(
        () => analytics.setUserProperty(
          name: any(named: 'name'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await service.logEvent('tapped');
      await service.logScreenView('home');
      await service.setUserProperty('tier', 'gold');

      verify(() => analytics.logEvent(name: 'tapped')).called(1);
      verify(() => analytics.logScreenView(screenName: 'home')).called(1);
      verify(
        () => analytics.setUserProperty(name: 'tier', value: 'gold'),
      ).called(1);
    });

    test('logs then throws AppException when Analytics fails', () async {
      when(
        () => analytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenThrow(StateError('analytics down'));

      await expectLater(
        () => service.logEvent('tapped'),
        throwsA(
          isA<AppException>().having(
            (AppException e) => e.code,
            'code',
            'analytics/log-event-failed',
          ),
        ),
      );
      expect(logger.lines.single, contains('tapped'));
    });
  });
}
