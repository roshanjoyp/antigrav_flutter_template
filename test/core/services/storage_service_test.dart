import 'package:antigrav_flutter_template/core/services/storage_service/storage_service_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mocktail mock of the secure storage plugin.
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('InMemoryStorageService', () {
    test('read returns null for unknown keys, then written values', () async {
      final InMemoryStorageService storage = InMemoryStorageService();

      expect((await storage.read('k')).getOrNull(), isNull);

      await storage.write('k', 'v');
      expect((await storage.read('k')).getOrNull(), 'v');

      await storage.delete('k');
      expect((await storage.read('k')).getOrNull(), isNull);
    });
  });

  group('SecureStorageServiceImpl', () {
    late MockFlutterSecureStorage plugin;
    late SecureStorageServiceImpl storage;

    setUp(() {
      plugin = MockFlutterSecureStorage();
      storage = SecureStorageServiceImpl(storage: plugin);
    });

    test('delegates read/write/delete to the plugin', () async {
      when(
        () => plugin.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'v');
      when(
        () => plugin.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => plugin.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      expect((await storage.read('k')).getOrNull(), 'v');
      expect((await storage.write('k', 'v')).isSuccess, isTrue);
      expect((await storage.delete('k')).isSuccess, isTrue);

      verify(() => plugin.read(key: 'k')).called(1);
      verify(() => plugin.write(key: 'k', value: 'v')).called(1);
      verify(() => plugin.delete(key: 'k')).called(1);
    });

    test('maps plugin failures to storage/* codes', () async {
      when(
        () => plugin.read(key: any(named: 'key')),
      ).thenThrow(StateError('keychain locked'));

      final result = await storage.read('k');
      result.fold(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (exception) {
          expect(exception.code, 'storage/read-failed');
          expect(exception.originalError, isA<StateError>());
        },
      );
    });
  });
}
