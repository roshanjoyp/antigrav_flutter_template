import 'package:antigrav_flutter_template/features/profile/data/profile_repository_impl.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StubProfileRepository', () {
    test('watchProfile emits null first, then saved profiles', () async {
      final StubProfileRepository repository = StubProfileRepository();
      final List<ProfileEntity?> emitted = <ProfileEntity?>[];
      final subscription = repository.watchProfile('u1').listen(emitted.add);
      // Let the initial emission arrive.
      await Future<void>.delayed(Duration.zero);
      expect(emitted, <ProfileEntity?>[null]);

      final result = await repository.saveProfile(
        const ProfileEntity(uid: 'u1', displayName: 'Alice'),
      );
      expect(result.isSuccess, isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(emitted.last?.displayName, 'Alice');
      expect(emitted.last?.updatedAt, isNotNull);

      await subscription.cancel();
    });

    test('saveProfile merges: null fields keep existing values', () async {
      final StubProfileRepository repository = StubProfileRepository();
      await repository.saveProfile(
        const ProfileEntity(uid: 'u1', displayName: 'Alice'),
      );
      await repository.saveProfile(
        const ProfileEntity(uid: 'u1', bio: 'Hello there'),
      );

      final result = await repository.fetchProfile('u1');
      final ProfileEntity? profile = result.getOrNull();
      expect(profile?.displayName, 'Alice');
      expect(profile?.bio, 'Hello there');
    });

    test('fetchProfile returns success(null) for unknown uid', () async {
      final StubProfileRepository repository = StubProfileRepository();
      final result = await repository.fetchProfile('nobody');
      expect(result.isSuccess, isTrue);
      expect(result.getOrNull(), isNull);
    });

    test('watchProfile ignores changes to other uids', () async {
      final StubProfileRepository repository = StubProfileRepository();
      final List<ProfileEntity?> emitted = <ProfileEntity?>[];
      final subscription = repository.watchProfile('u1').listen(emitted.add);
      await Future<void>.delayed(Duration.zero);

      await repository.saveProfile(
        const ProfileEntity(uid: 'u2', displayName: 'Bob'),
      );
      await Future<void>.delayed(Duration.zero);
      expect(emitted, <ProfileEntity?>[null]);

      await subscription.cancel();
    });
  });
}
