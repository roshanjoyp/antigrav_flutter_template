import 'package:antigrav_flutter_template/core/utils/result.dart';

/// A push notification delivered to the app, vendor-agnostic.
///
/// Provider-specific message types (FCM `RemoteMessage`) are mapped into
/// this in the service implementation so nothing above the service layer
/// depends on the push vendor.
class PushMessage {
  /// Creates a [PushMessage].
  const PushMessage({
    this.title,
    this.body,
    this.data = const <String, Object?>{},
  });

  /// The notification title, if the message carried one.
  final String? title;

  /// The notification body, if the message carried one.
  final String? body;

  /// The message's custom key/value payload.
  final Map<String, Object?> data;

  /// The in-app route this notification deep-links to, if any.
  ///
  /// Convention: senders put a go_router location (e.g. `/profile`) in
  /// the data payload under the key `route`. The app-layer listener
  /// navigates there when the user taps the notification.
  String? get route {
    final Object? value = data['route'];
    return value is String ? value : null;
  }
}

/// Contract for push notifications.
///
/// Implementations wrap a push provider (FCM in this template) or a
/// stub. Access it via the `pushServiceProvider` Riverpod provider.
///
/// Permission denial is a **valid result** (`false` from
/// [requestPermission]), not an error. Error codes follow the
/// `'push/...'` convention.
abstract class PushService {
  /// Asks the user for notification permission (iOS prompt, Android 13+
  /// runtime permission) via the app's `PermissionService` flow.
  ///
  /// Returns `true` if granted. Safe to call repeatedly — the system
  /// only prompts once.
  Future<bool> requestPermission();

  /// The device's current push registration token.
  ///
  /// `Success(null)` means no token is available yet (e.g. iOS before
  /// APNs registration completes) — retry after [onTokenRefresh] fires.
  Future<Result<String?>> getToken();

  /// Emits whenever the registration token is created or rotated.
  ///
  /// Send every emission to your backend if it targets individual
  /// devices.
  Stream<String> get onTokenRefresh;

  /// Messages arriving while the app is in the **foreground**.
  ///
  /// The OS shows no system notification in this state — show in-app UI
  /// (snackbar, badge) if the message should be visible.
  Stream<PushMessage> get onForegroundMessage;

  /// Emits when the user **taps** a notification while the app is in the
  /// background, bringing it to the foreground.
  Stream<PushMessage> get onMessageOpened;

  /// The notification that **launched** the app from a terminated state,
  /// or `null` when the app was opened normally.
  ///
  /// Check once during startup; combined with [onMessageOpened] this
  /// covers every notification-tap entry point.
  Future<PushMessage?> getInitialMessage();

  /// Subscribes this device to a broadcast [topic].
  Future<Result<void>> subscribeToTopic(String topic);

  /// Unsubscribes this device from [topic].
  Future<Result<void>> unsubscribeFromTopic(String topic);
}
