# Crash Service

## Overview
The `CrashService` abstracts error reporting. It is designed to capture fatal and non-fatal errors and send them to a backend service like Firebase Crashlytics or Sentry.

## Interface
```dart
abstract class CrashService {
  Future<void> recordError(dynamic exception, StackTrace? stack, {dynamic reason, bool fatal = false});
  Future<void> log(String message);
  Future<void> setUserIdentifier(String identifier);
}
```

## Usage
```dart
try {
  // risky operation
} catch (e, stack) {
  ref.read(crashServiceProvider).recordError(e, stack, reason: 'Operation failed');
}
```

## Implementation Details
*   **File**: `crash_service_impl.dart`
*   **Current State**: `DebugCrashService`. It simply logs errors to the console using `LogService`.
*   **Production**: Replace `DebugCrashService` with `FirebaseCrashService` (using `firebase_crashlytics`) when ready.
