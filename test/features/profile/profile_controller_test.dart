import 'package:antigrav_flutter_template/features/auth/data/auth_repository_impl.dart';
import 'package:antigrav_flutter_template/features/profile/data/profile_repository_impl.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_entity.dart';
import 'package:antigrav_flutter_template/features/profile/presentation/profile_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reference test for the **provider override pattern**.
///
/// This is how every controller in the template should be tested: build a
/// [ProviderContainer] with the repositories swapped for stubs/fakes via
/// `overrideWith` — the exact mechanism `lib/app/config/firebase_overrides.dart`
/// uses at app level — then drive the controller through the container.
void main() {
  late ProviderContainer container;
  late StubProfileRepository profileRepository;

  setUp(() {
    profileRepository = StubProfileRepository();
    container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWith((ref) => profileRepository),
        authRepositoryProvider.overrideWith((ref) => StubAuthRepository()),
      ],
    );
    addTearDown(container.dispose);
    // Riverpod 3 pauses providers nobody listens to — keep the controller
    // alive for the whole test, like a mounted widget would.
    container.listen(profileControllerProvider, (_, _) {});
  });

  group('ProfileController', () {
    test('emits null for a user with no profile yet', () async {
      final ProfileEntity? profile =
          await container.read(profileControllerProvider.future);
      expect(profile, isNull);
    });

    test('uses the demo uid while signed out', () async {
      await profileRepository.saveProfile(
        const ProfileEntity(
          uid: ProfileController.demoUid,
          displayName: 'Demo',
        ),
      );
      // Let the repository's change event flow through the watch stream.
      await Future<void>.delayed(Duration.zero);
      final ProfileEntity? profile =
          container.read(profileControllerProvider).value;
      expect(profile?.displayName, 'Demo');
    });

    test('save persists trimmed values and the stream emits the update',
        () async {
      // Wait for the initial (null) emission first.
      await container.read(profileControllerProvider.future);

      final result = await container
          .read(profileControllerProvider.notifier)
          .save(displayName: '  Alice  ', bio: '');
      expect(result.isSuccess, isTrue);

      // The watched stream should now emit the saved profile.
      await Future<void>.delayed(Duration.zero);
      final AsyncValue<ProfileEntity?> state =
          container.read(profileControllerProvider);
      expect(state.value?.displayName, 'Alice');
      // Blank bio is normalized to null rather than stored as ''.
      expect(state.value?.bio, isNull);
      expect(state.value?.uid, ProfileController.demoUid);
    });
  });
}
