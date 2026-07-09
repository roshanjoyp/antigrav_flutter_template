/// Barrel export for the onboarding feature.
///
/// First-run flow: a swipeable intro whose "seen" flag persists via the
/// core `StorageService`. Startup redirects unseen users to
/// `/onboarding`; completing or skipping marks it seen.
library;

// Domain
export 'package:antigrav_flutter_template/features/onboarding/domain/onboarding_repository.dart';

// Data — exported for the Riverpod provider (onboardingRepositoryProvider)
export 'package:antigrav_flutter_template/features/onboarding/data/onboarding_repository_impl.dart';

// Presentation
export 'package:antigrav_flutter_template/features/onboarding/presentation/onboarding_controller.dart';
export 'package:antigrav_flutter_template/features/onboarding/presentation/onboarding_screen.dart';
