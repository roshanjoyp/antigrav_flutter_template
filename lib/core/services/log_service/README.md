# Log Service

## Overview
The `LogService` provides a unified interface for logging across the application. It abstracts the underlying logging implementation (currently `logger` package), allowing for easy substitution or extension (e.g., adding cloud logging).

## Interface
```dart
abstract class LogService {
  void debug(String message, [dynamic error, StackTrace? stackTrace]);
  void info(String message, [dynamic error, StackTrace? stackTrace]);
  void warning(String message, [dynamic error, StackTrace? stackTrace]);
  void error(String message, [dynamic error, StackTrace? stackTrace]);
  void wtf(String message, [dynamic error, StackTrace? stackTrace]);
}
```

## Usage
Inject `LogService` via Riverpod:

```dart
final logger = ref.read(logServiceProvider);
logger.info('App initialized');
logger.error('Something went wrong', error, stackTrace);
```

## Implementation Details
*   **File**: `log_service_impl.dart`
*   **Package**: `logger`
*   **Formatter**: `PrettyPrinter` (colors, emojis, no time stamp by default).
