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

## 7. PushService
**Location**: `lib/core/services/push_service`
**Usage**: Push notifications — permission, token, message streams, topics.
**Implementations**: `DebugPushService` (default; can simulate messages) · `FirebasePushServiceImpl` (FCM; bound when Firebase is enabled).

```dart
final granted = await ref.read(pushServiceProvider).requestPermission();
final token = await ref.read(pushServiceProvider).getToken(); // Result<String?>
ref.read(pushServiceProvider).onForegroundMessage.listen((msg) { /* in-app UI */ });
```

Notification taps deep-link automatically: messages with a `route` data key navigate there via `pushDeepLinkListenerProvider` (`lib/app/config/push_deep_link_listener.dart`). See `docs/setup/PUSH_NOTIFICATIONS_SETUP.md`.

## 8. StorageService
**Location**: `lib/core/services/storage_service`
**Usage**: Persistent key/value storage for small flags and tokens (keys live in `AppConstants.storageKey*`).
**Implementations**: `SecureStorageServiceImpl` (default — real, keychain/keystore-backed) · `InMemoryStorageService` (tests/overrides).

```dart
final value = await ref.read(storageServiceProvider).read(AppConstants.storageKeyTheme); // Result<String?>
await ref.read(storageServiceProvider).write(AppConstants.storageKeyTheme, 'dark');
```

## 9. NetworkService
**Location**: `lib/core/services/network_service`
**Usage**: HTTP calls to the app's own REST backend — the single seam between repositories and the wire, so the backend can be swapped or re-pointed without touching call sites. Paths are relative to the flavor-resolved base URL in `NetworkConfig` (`lib/core/config/network/network_config.dart`).
**Implementations**: `DebugNetworkService` (default — logs the request, returns an empty 200) · `DioNetworkService` (real, applied by `bootstrap.dart` via `networkServiceOverrides()` when `NetworkConfig.enabled`; optional `tokenProvider` attaches `Authorization: Bearer` headers).

All methods return `Result<NetworkResponse>` and never throw; failures carry `network/...` codes (`network/timeout`, `network/no-connection`, `network/http-<status>`, ...) mapped in `dio_network_error_mapper.dart`.

```dart
final result = await ref.read(networkServiceProvider).get('/v1/profile'); // Result<NetworkResponse>
result.fold(
  onSuccess: (response) => ProfileModel.fromJson(response.data! as Map<String, dynamic>),
  onFailure: (e) => e.code == 'network/timeout' ? retry() : showError(e),
);
```

## Feature Repositories (Data Layer)
**Location**: `lib/features/*`

We follow the **Repository Pattern**. All repository methods return the `Result` type from `lib/core/utils/result.dart`; implementations map backend errors into `AppException` and never throw.

| Feature | Interface (domain) | Stub/default | Real impl (switch) |
| :--- | :--- | :--- | :--- |
| Auth | `AuthRepository` | `StubAuthRepository` | `FirebaseAuthRepositoryImpl` (Firebase Auth) |
| Profile | `ProfileRepository` | `StubProfileRepository` | `FirestoreProfileRepositoryImpl` (Firestore) |
| Paywall | `SubscriptionRepository` | `StubSubscriptionRepository` | `RevenueCatSubscriptionRepositoryImpl` (RevenueCat, `RevenueCatConfig.enabled`) |
| Onboarding | `OnboardingRepository` | `OnboardingRepositoryImpl` (real, storage-backed — never overridden) | — |

The Firebase implementations are bound automatically when `FirebaseConfig.enabled` is `true` (see `lib/app/config/firebase_overrides.dart`); the RevenueCat implementation when `RevenueCatConfig.enabled` is `true` (see `lib/app/config/revenuecat_overrides.dart` and `docs/setup/REVENUECAT_SETUP.md`).

To add another backend (e.g. REST):
1. Create `RestAuthRepository` implementing `AuthRepository` (map errors into `Result`/`AppException`).
2. Bind it — either as the provider default in `auth_repository_impl.dart` or through an override list like the Firebase one.
