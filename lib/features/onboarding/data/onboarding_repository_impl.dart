import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/services/storage_service/storage_service.dart';
import 'package:craft_flutter_template/core/services/storage_service/storage_service_impl.dart';
import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:craft_flutter_template/features/onboarding/domain/onboarding_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_repository_impl.g.dart';

/// [OnboardingRepository] persisting the seen flag via [StorageService].
///
/// A real implementation (not a stub): it sits on the storage service,
/// which needs no backend, so this works on a fresh checkout and is the
/// permanent binding.
class OnboardingRepositoryImpl implements OnboardingRepository {
  /// Creates an [OnboardingRepositoryImpl] on top of [storage].
  OnboardingRepositoryImpl(this._storage);

  /// The value stored when onboarding has been seen.
  static const String _seenValue = 'true';

  final StorageService _storage;

  @override
  Future<Result<bool>> hasSeenOnboarding() async {
    final Result<String?> stored = await _storage.read(
      AppConstants.storageKeyOnboardingSeen,
    );
    return stored.mapSuccess((String? value) => value == _seenValue);
  }

  @override
  Future<Result<void>> markOnboardingSeen() =>
      _storage.write(AppConstants.storageKeyOnboardingSeen, _seenValue);

  @override
  Future<Result<void>> resetOnboarding() =>
      _storage.delete(AppConstants.storageKeyOnboardingSeen);
}

/// Provides the app-wide [OnboardingRepository] binding.
@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) {
  return OnboardingRepositoryImpl(ref.watch(storageServiceProvider));
}
