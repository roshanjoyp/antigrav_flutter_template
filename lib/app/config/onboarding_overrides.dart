import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:craft_flutter_template/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:craft_flutter_template/features/startup/domain/first_run_redirect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

/// Provider overrides that wire the onboarding module into startup.
///
/// Applied unconditionally in `main.dart` while the onboarding module is
/// part of the project; the generator removes this file (and its wiring
/// line) when onboarding is excluded, and startup falls back to its
/// default no-redirect behavior.
List<Override> onboardingOverrides() {
  return [
    firstRunRedirectProvider.overrideWith((Ref ref) async {
      // First run goes to onboarding. A failed storage read counts as
      // "seen" — a broken storage layer must not trap users in
      // onboarding, and home works without it.
      final Result<bool> seen = await ref
          .read(onboardingRepositoryProvider)
          .hasSeenOnboarding();
      return seen.getOrElse(true) ? null : '/onboarding';
    }),
  ];
}
