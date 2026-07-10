import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'first_run_redirect.g.dart';

/// Resolves where a fresh launch should be redirected, or `null` to
/// proceed to home.
///
/// Defaults to no redirect. Features that want to intercept the first
/// run (e.g. onboarding) override this provider in `main.dart` — see
/// `lib/app/config/onboarding_overrides.dart`. Startup stays ignorant
/// of who is redirecting and why.
@riverpod
Future<String?> firstRunRedirect(Ref ref) async => null;
