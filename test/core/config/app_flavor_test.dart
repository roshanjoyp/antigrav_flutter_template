import 'package:antigrav_flutter_template/core/config/app_env.dart';
import 'package:antigrav_flutter_template/core/config/app_flavor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(AppFlavor.reset);

  group('AppFlavor', () {
    test('initialize sets the active environment', () {
      AppFlavor.initialize(AppEnv.staging);
      expect(AppFlavor.instance.env, AppEnv.staging);
      expect(AppFlavor.isStaging, isTrue);
      expect(AppFlavor.isDevelopment, isFalse);
      expect(AppFlavor.isProduction, isFalse);
    });

    test('accessing instance before initialize throws StateError', () {
      expect(() => AppFlavor.instance, throwsStateError);
    });

    test('initializing twice throws StateError', () {
      AppFlavor.initialize(AppEnv.development);
      expect(
        () => AppFlavor.initialize(AppEnv.production),
        throwsStateError,
      );
    });

    test('reset allows re-initialization (test-only escape hatch)', () {
      AppFlavor.initialize(AppEnv.development);
      AppFlavor.reset();
      AppFlavor.initialize(AppEnv.production);
      expect(AppFlavor.isProduction, isTrue);
    });
  });

  group('AppEnv', () {
    test('convenience getters match the enum value', () {
      expect(AppEnv.development.isDevelopment, isTrue);
      expect(AppEnv.staging.isStaging, isTrue);
      expect(AppEnv.production.isProduction, isTrue);
      expect(AppEnv.production.isDevelopment, isFalse);
    });

    test('displayName is human readable', () {
      expect(AppEnv.development.displayName, 'Development');
      expect(AppEnv.staging.displayName, 'Staging');
      expect(AppEnv.production.displayName, 'Production');
    });
  });
}
