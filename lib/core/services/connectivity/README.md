# Connectivity Service

## Overview
Monitors the device's internet connection status.

## Interface
```dart
abstract class ConnectivityService {
  Stream<bool> get onConnectivityChanged;
  Future<bool> get isConnected;
}
```

## Usage
```dart
// Reactive UI
final isConnected = ref.watch(connectivityServiceProvider).onConnectivityChanged;

// Imperative Check
if (await ref.read(connectivityServiceProvider).isConnected) {
  // perform network request
}
```

## Implementation Details
*   **File**: `connectivity_service_impl.dart`
*   **Package**: `internet_connection_checker_plus`
*   **Note**: Checks for actual data connection (ping), not just Wi-Fi/Cellular connectivity.
