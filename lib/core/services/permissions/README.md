# Permission Service

## Overview
A wrapper around `permission_handler` to simplify permission requests and status checks.

## Interface
```dart
abstract class PermissionService {
  Future<bool> requestPermission(Permission permission);
  Future<bool> checkPermission(Permission permission);
  Future<void> openSettings();
}
```

## Usage
```dart
final granted = await ref.read(permissionServiceProvider).requestPermission(Permission.camera);
if (granted) {
  // access camera
}
```

## Implementation Details
*   **File**: `permission_service_impl.dart`
*   **Package**: `permission_handler`
