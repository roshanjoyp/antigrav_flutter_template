import 'package:craft_flutter_template/core/services/log_service/log_service.dart';
import 'package:craft_flutter_template/core/services/permissions/permission_service.dart';
import 'package:craft_flutter_template/core/services/push_service/push_service.dart';
import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Handles FCM messages while the app is backgrounded or terminated.
///
/// Runs in its own isolate, so it can't touch app state, providers, or
/// UI. Extend it for data-only messages that must be processed without
/// user interaction (call `Firebase.initializeApp()` first if you use
/// other Firebase services here).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM background message: ${message.messageId}');
}

/// FCM-backed implementation of [PushService].
///
/// Bound via `firebaseServiceOverrides()` when Firebase is enabled — the
/// stub remains the default binding. The notification permission prompt
/// goes through the app's [PermissionService] so push follows the same
/// permission flow as every other capability.
class FirebasePushServiceImpl implements PushService {
  /// Creates a [FirebasePushServiceImpl].
  ///
  /// [messaging] is injectable for tests; defaults to
  /// `FirebaseMessaging.instance`.
  FirebasePushServiceImpl(
    this._permissions,
    this._logger, {
    FirebaseMessaging? messaging,
  }) : _messaging = messaging ?? FirebaseMessaging.instance;

  final PermissionService _permissions;
  final LogService _logger;
  final FirebaseMessaging _messaging;

  /// Registers [firebaseMessagingBackgroundHandler] for background and
  /// terminated-state messages.
  ///
  /// Called from `main.dart` right after Firebase initialization — the
  /// handler must be registered before any message can arrive.
  static void registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Maps an FCM [RemoteMessage] into the vendor-agnostic [PushMessage].
  static PushMessage mapRemoteMessage(RemoteMessage message) => PushMessage(
    title: message.notification?.title,
    body: message.notification?.body,
    data: message.data,
  );

  @override
  Future<bool> requestPermission() async {
    final bool granted = await _permissions.requestPermission(
      Permission.notification,
    );
    if (granted) {
      // iOS suppresses foreground notifications by default; opt in to
      // the usual banner + sound so foreground pushes are visible.
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    return granted;
  }

  @override
  Future<Result<String?>> getToken() => _guard(
    'push/token-failed',
    'Failed to get the push registration token.',
    () => _messaging.getToken(),
  );

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Stream<PushMessage> get onForegroundMessage =>
      FirebaseMessaging.onMessage.map(mapRemoteMessage);

  @override
  Stream<PushMessage> get onMessageOpened =>
      FirebaseMessaging.onMessageOpenedApp.map(mapRemoteMessage);

  @override
  Future<PushMessage?> getInitialMessage() async {
    final RemoteMessage? message = await _messaging.getInitialMessage();
    return message == null ? null : mapRemoteMessage(message);
  }

  @override
  Future<Result<void>> subscribeToTopic(String topic) => _guard(
    'push/subscribe-failed',
    'Failed to subscribe to topic "$topic".',
    () => _messaging.subscribeToTopic(topic),
  );

  @override
  Future<Result<void>> unsubscribeFromTopic(String topic) => _guard(
    'push/unsubscribe-failed',
    'Failed to unsubscribe from topic "$topic".',
    () => _messaging.unsubscribeFromTopic(topic),
  );

  /// Runs [action], wrapping the outcome in a [Result] and logging
  /// failures before returning them.
  Future<Result<T>> _guard<T>(
    String code,
    String message,
    Future<T> Function() action,
  ) async {
    try {
      return Success<T>(await action());
    } catch (error, stackTrace) {
      _logger.error(message, error, stackTrace);
      return Failure<T>(
        AppException(
          message: message,
          code: code,
          originalError: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
