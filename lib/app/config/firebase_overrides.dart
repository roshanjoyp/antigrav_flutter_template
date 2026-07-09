import 'package:antigrav_flutter_template/core/config/firebase/firebase_config.dart';
import 'package:antigrav_flutter_template/core/services/analytics_service/analytics_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/analytics_service/firebase_analytics_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/crash_service/crash_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/crash_service/firebase_crash_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:antigrav_flutter_template/features/auth/auth.dart';
import 'package:antigrav_flutter_template/features/profile/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

/// Provider overrides that swap every stub for its Firebase
/// implementation.
///
/// This is the single switch point between the stub and Firebase
/// backends: `main.dart` applies [firebaseServiceOverrides] to the root
/// [ProviderContainer] only when [FirebaseConfig.enabled] is `true`, so
/// enabling Firebase (see docs/setup/FIREBASE_SETUP.md) rebinds the whole
/// app with no call-site changes anywhere.
///
/// When adding a new service or repository with a Firebase-backed
/// implementation, add its override here.
List<Override> firebaseServiceOverrides() => <Override>[
      authRepositoryProvider.overrideWith(
        (Ref ref) => FirebaseAuthRepositoryImpl(),
      ),
      profileRepositoryProvider.overrideWith(
        (Ref ref) => FirestoreProfileRepositoryImpl(),
      ),
      crashServiceProvider.overrideWith(
        (Ref ref) => FirebaseCrashServiceImpl(ref.watch(logServiceProvider)),
      ),
      analyticsServiceProvider.overrideWith(
        (Ref ref) =>
            FirebaseAnalyticsServiceImpl(ref.watch(logServiceProvider)),
      ),
    ];
