import 'package:craft_flutter_template/core/config/firebase/firebase_config.dart';
import 'package:craft_flutter_template/core/services/push_service/push_service.dart';
import 'package:craft_flutter_template/core/services/push_service/push_service_impl.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:craft_flutter_template/features/auth/data/auth_repository_impl.dart';
import 'package:craft_flutter_template/features/setup_status/domain/runtime_check_entity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setup_status_controller.g.dart';

/// Runs the manifest's runtime setup checks and exposes their states.
///
/// Each runtime [SetupStep] (kind [SetupCheckKind.runtimeCheck]) is bound
/// to an implementation here by its id — things only a running app can
/// verify: Firebase actually initializes, anonymous auth round-trips,
/// an FCM token is issued. Steps of disabled modules start (and stay)
/// [RuntimeCheckStatus.skipped].
@riverpod
class SetupStatusController extends _$SetupStatusController {
  /// The runtime step ids this controller implements. Kept in sync with
  /// the manifest by a drift-guard unit test.
  static const Set<String> handledStepIds = {
    'firebase.initializes',
    'firebase.anon_auth',
    'push.fcm_token',
  };

  @override
  Map<String, RuntimeCheckEntity> build() {
    return {
      for (final SetupStep step in SetupManifest.stepsOfKind(
        SetupCheckKind.runtimeCheck,
      ))
        step.id: RuntimeCheckEntity(
          stepId: step.id,
          status: _moduleEnabled(step.module)
              ? RuntimeCheckStatus.notRun
              : RuntimeCheckStatus.skipped,
          detail: _moduleEnabled(step.module) ? null : 'Module disabled.',
        ),
    };
  }

  /// Runs every non-skipped runtime check sequentially.
  Future<void> runAll() async {
    for (final String stepId in state.keys) {
      if (state[stepId]!.status != RuntimeCheckStatus.skipped) {
        await run(stepId);
      }
    }
  }

  /// Runs the single check bound to [stepId] and records its outcome.
  Future<void> run(String stepId) async {
    final RuntimeCheckEntity current = state[stepId]!;
    if (current.status == RuntimeCheckStatus.skipped) return;
    _update(current.copyWith(status: RuntimeCheckStatus.running));
    final RuntimeCheckEntity outcome = switch (stepId) {
      'firebase.initializes' => _checkFirebaseInitialized(current),
      'firebase.anon_auth' => await _checkAnonymousAuth(current),
      'push.fcm_token' => await _checkFcmToken(current),
      _ => current.copyWith(
        status: RuntimeCheckStatus.failed,
        detail: 'No implementation bound for $stepId.',
      ),
    };
    _update(outcome);
  }

  /// Whether [module]'s runtime checks apply in this build.
  bool _moduleEnabled(SetupModule module) => switch (module) {
    SetupModule.core => true,
    SetupModule.firebase || SetupModule.push => FirebaseConfig.enabled,
    SetupModule.revenuecat => false, // No runtime checks declared yet.
  };

  RuntimeCheckEntity _checkFirebaseInitialized(RuntimeCheckEntity check) {
    return Firebase.apps.isEmpty
        ? check.copyWith(
            status: RuntimeCheckStatus.failed,
            detail: 'No Firebase app initialized at startup.',
          )
        : check.copyWith(
            status: RuntimeCheckStatus.passed,
            detail: 'App "${Firebase.apps.first.name}" initialized.',
          );
  }

  Future<RuntimeCheckEntity> _checkAnonymousAuth(
    RuntimeCheckEntity check,
  ) async {
    final Result<Object?> result = await ref
        .read(authRepositoryProvider)
        .signInAnonymously();
    return result.fold(
      onSuccess: (_) => check.copyWith(
        status: RuntimeCheckStatus.passed,
        detail: 'Signed in anonymously.',
      ),
      onFailure: (AppException error) => check.copyWith(
        status: RuntimeCheckStatus.failed,
        detail: error.message,
      ),
    );
  }

  Future<RuntimeCheckEntity> _checkFcmToken(RuntimeCheckEntity check) async {
    final PushService push = ref.read(pushServiceProvider);
    final Result<String?> result = await push.getToken();
    return result.fold(
      onSuccess: (String? token) => token == null
          ? check.copyWith(
              status: RuntimeCheckStatus.failed,
              detail: 'No token issued (permission or APNs setup missing).',
            )
          : check.copyWith(
              status: RuntimeCheckStatus.passed,
              detail: 'Token: ${token.substring(0, 12)}…',
            ),
      onFailure: (AppException error) => check.copyWith(
        status: RuntimeCheckStatus.failed,
        detail: error.message,
      ),
    );
  }

  void _update(RuntimeCheckEntity entity) {
    state = {...state, entity.stepId: entity};
  }
}
