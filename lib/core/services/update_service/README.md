# Update Service

## Overview
A custom service designed to check for application updates. Use this to poll your backend or a remote configuration file to see if a new version is available.

## Interface
```dart
class AppUpdateInfo {
  final String version;
  final bool isMandatory;
  final String? releaseNotesUrl;
  // ...
}

abstract class UpdateService {
  /// Checks if a new version is available.
  /// Returns [AppUpdateInfo] if an update is found, or null otherwise.
  Future<AppUpdateInfo?> checkForUpdate();
}
```

## Usage
```dart
final updateInfo = await ref.read(updateServiceProvider).checkForUpdate();
if (updateInfo != null) {
  // Show update dialog
}
```

## Implementation Details
*   **File**: `update_service_impl.dart`
*   **Current State**: Stubbed (`CustomUpdateService`). You must implement the `checkForUpdate` logic to call your API.
