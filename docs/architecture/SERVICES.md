# Core Services Documentation

This template includes a set of abstracted core services designed for production-grade applications. These services are implemented using the Riverpod provider pattern and are located in `lib/core/services`.

Every service is an **interface** with a debug/stub implementation bound by default. Services with a Firebase implementation (`CrashService` → Crashlytics, `AnalyticsService` → Firebase Analytics) are rebound automatically when `FirebaseConfig.enabled` is `true` — see the override list in `lib/app/config/firebase_overrides.dart` and `docs/setup/FIREBASE_SETUP.md`.

## 1. LogService
**Location**: `lib/core/services/log_service`
**Usage**: Unified logging interface.

```dart
ref.read(logServiceProvider).info('User logged in');
ref.read(logServiceProvider).error('API Failed', error, stackTrace);
```

## 2. CrashService
**Location**: `lib/core/services/crash_service`
**Usage**: Reporting non-fatal errors to Crashlytics/Sentry.
**Implementations**: `DebugCrashService` (default) · `FirebaseCrashServiceImpl` (Crashlytics; bound when Firebase is enabled).

```dart
try {
  // hazardous code
} catch (e, s) {
  ref.read(crashServiceProvider).recordError(e, s, reason: 'Hazrdous op failed');
}
```

## 3. AnalyticsService
**Location**: `lib/core/services/analytics_service`
**Usage**: Tracking user behavior.
**Implementations**: `DebugAnalyticsService` (default) · `FirebaseAnalyticsServiceImpl` (bound when Firebase is enabled).

```dart
ref.read(analyticsServiceProvider).logEvent('purchase_button_clicked', parameters: {'item_id': '123'});
```

## 4. ConnectivityService
**Location**: `lib/core/services/connectivity`
**Usage**: Checking internet status.

```dart
final isConnected = ref.watch(connectivityServiceProvider).onConnectivityChanged; // Stream
// or
final hasInternet = await ref.read(connectivityServiceProvider).isConnected;
```

## 5. PermissionService
**Location**: `lib/core/services/permissions`
**Usage**: Requesting permissions with a unified API.

```dart
final granted = await ref.read(permissionServiceProvider).requestPermission(Permission.camera);
if (!granted) {
  // handle denial
}
```

## 6. UpdateService (Custom)
**Location**: `lib/core/services/update_service`
**Usage**: Check for updates manually.

```dart
final info = await ref.read(updateServiceProvider).checkForUpdate();
if (info != null) {
  print('New version available: ${info.version}');
}
```

## Auth & Data Layer
**Location**: `lib/features/auth` and `lib/features/profile`

We follow the **Repository Pattern**. All repository methods return the `Result` type from `lib/core/utils/result.dart`; implementations map backend errors into `AppException` and never throw.

| Feature | Interface (domain) | Stub (default) | Firebase impl |
| :--- | :--- | :--- | :--- |
| Auth | `AuthRepository` | `StubAuthRepository` | `FirebaseAuthRepositoryImpl` (Firebase Auth) |
| Profile | `ProfileRepository` | `StubProfileRepository` | `FirestoreProfileRepositoryImpl` (Firestore) |

The Firebase implementations are bound automatically when `FirebaseConfig.enabled` is `true` (see `lib/app/config/firebase_overrides.dart`).

To add another backend (e.g. REST):
1. Create `RestAuthRepository` implementing `AuthRepository` (map errors into `Result`/`AppException`).
2. Bind it — either as the provider default in `auth_repository_impl.dart` or through an override list like the Firebase one.
