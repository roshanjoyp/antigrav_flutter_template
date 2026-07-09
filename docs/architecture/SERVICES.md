# Core Services Documentation

This template includes a set of abstracted core services designed for production-grade applications. These services are implemented using the Riverpod provider pattern and are located in `lib/core/services`.

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
**Location**: `lib/features/auth`

We follow the **Repository Pattern**.
- **Domain**: `AuthRepository` (Interface)
- **Data**: `FirebaseAuthRepository` (Implementation)

To switch to REST API:
1. Create `RestAuthRepository` implementing `AuthRepository`.
2. Update the provider in `auth_repository_impl.dart` to return `RestAuthRepository`.
