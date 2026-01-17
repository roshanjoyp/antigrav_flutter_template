# Analytics Service

## Overview
The `AnalyticsService` provides a generic interface for tracking user events, screen views, and user properties.

## Interface
```dart
abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object>? parameters});
  Future<void> logScreenView(String screenName);
  Future<void> setUserProperty(String name, String value);
}
```

## Usage
```dart
ref.read(analyticsServiceProvider).logEvent('add_to_cart', parameters: {'id': '123'});
```

## Implementation Details
*   **File**: `analytics_service_impl.dart`
*   **Current State**: `DebugAnalyticsService` (Console logging).
*   **Production**: Ready to be swapped with `FirebaseAnalyticsService` or similar.
