import 'package:craft_flutter_template/core/services/storage_service/storage_service_impl.dart';
import 'package:craft_flutter_template/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardingRepositoryImpl', () {
    late OnboardingRepositoryImpl repository;

    setUp(
      () => repository = OnboardingRepositoryImpl(InMemoryStorageService()),
    );

    test('is unseen until marked, then seen until reset', () async {
      expect((await repository.hasSeenOnboarding()).getOrNull(), isFalse);

      expect((await repository.markOnboardingSeen()).isSuccess, isTrue);
      expect((await repository.hasSeenOnboarding()).getOrNull(), isTrue);

      expect((await repository.resetOnboarding()).isSuccess, isTrue);
      expect((await repository.hasSeenOnboarding()).getOrNull(), isFalse);
    });
  });
}
