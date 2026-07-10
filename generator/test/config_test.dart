import 'package:craft_generator/craft_generator.dart';
import 'package:test/test.dart';

Map<String, Object?> _valid({Map<String, Object?>? modules}) => {
  'appName': 'Just Tap',
  'packageId': 'com.example.justtap',
  'description': 'A tap game for quick reflexes.',
  'modules': modules ?? {'firebase': true, 'push': true},
};

void main() {
  group('GeneratorConfig', () {
    test('parses a valid request and defaults unlisted modules to false', () {
      final config = GeneratorConfig.fromJson(_valid());
      expect(config.appName, 'Just Tap');
      expect(config.modules['firebase'], isTrue);
      expect(config.modules['revenuecat'], isFalse);
      expect(config.excluded, {'revenuecat', 'onboarding'});
    });

    test('every registered module gets an entry', () {
      final config = GeneratorConfig.fromJson(_valid());
      expect(config.modules.keys.toSet(), kModules.keys.toSet());
    });

    test('rejects push without firebase', () {
      expect(
        () => GeneratorConfig.fromJson(_valid(modules: {'push': true})),
        throwsA(
          isA<ConfigException>().having(
            (e) => e.message,
            'message',
            contains('requires "firebase"'),
          ),
        ),
      );
    });

    test('rejects unknown module keys', () {
      expect(
        () => GeneratorConfig.fromJson(_valid(modules: {'blockchain': true})),
        throwsA(isA<ConfigException>()),
      );
    });

    test('rejects invalid package ids and lengths', () {
      expect(
        () => GeneratorConfig.fromJson({..._valid(), 'packageId': 'nope'}),
        throwsA(isA<ConfigException>()),
      );
      expect(
        () => GeneratorConfig.fromJson({..._valid(), 'appName': 'x'}),
        throwsA(isA<ConfigException>()),
      );
      expect(
        () => GeneratorConfig.fromJson({..._valid(), 'description': 'short'}),
        throwsA(isA<ConfigException>()),
      );
    });

    test('rejects malformed JSON text', () {
      expect(
        () => GeneratorConfig.fromJsonString('not json'),
        throwsA(isA<ConfigException>()),
      );
    });
  });
}
