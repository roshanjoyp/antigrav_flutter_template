import 'dart:async';

import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/push_service/push_service.dart';
import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_service_impl.g.dart';

/// A debug [PushService] that logs every call instead of talking to a
/// real push provider.
///
/// No real notifications arrive in this mode; [simulateForegroundMessage]
/// and [simulateMessageOpened] inject fake ones so the full receive →
/// deep-link flow (including the app-layer route listener) is
/// demonstrable offline and in tests.
///
/// Template note: this stub is the default binding of
/// `pushServiceProvider`. Do not replace it — when Firebase is enabled,
/// `FirebasePushServiceImpl` is bound instead (see
/// docs/setup/PUSH_NOTIFICATIONS_SETUP.md).
class DebugPushService implements PushService {
  /// Creates a [DebugPushService] backed by the given [LogService].
  DebugPushService(this._logger);

  /// The fixed token this stub reports.
  static const String debugToken = 'debug-push-token';

  final LogService _logger;

  final StreamController<String> _tokenRefreshes =
      StreamController<String>.broadcast();
  final StreamController<PushMessage> _foregroundMessages =
      StreamController<PushMessage>.broadcast();
  final StreamController<PushMessage> _openedMessages =
      StreamController<PushMessage>.broadcast();

  @override
  Future<bool> requestPermission() async {
    _logger.debug('PUSH: permission requested (stub always grants)');
    return true;
  }

  @override
  Future<Result<String?>> getToken() async {
    _logger.debug('PUSH: token requested -> $debugToken');
    return const Success<String?>(debugToken);
  }

  @override
  Stream<String> get onTokenRefresh => _tokenRefreshes.stream;

  @override
  Stream<PushMessage> get onForegroundMessage => _foregroundMessages.stream;

  @override
  Stream<PushMessage> get onMessageOpened => _openedMessages.stream;

  @override
  Future<PushMessage?> getInitialMessage() async => null;

  @override
  Future<Result<void>> subscribeToTopic(String topic) async {
    _logger.debug('PUSH: subscribed to topic "$topic"');
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> unsubscribeFromTopic(String topic) async {
    _logger.debug('PUSH: unsubscribed from topic "$topic"');
    return const Success<void>(null);
  }

  /// Injects a fake message as if it arrived while the app was in the
  /// foreground.
  void simulateForegroundMessage(PushMessage message) {
    _logger.debug('PUSH: simulating foreground message "${message.title}"');
    _foregroundMessages.add(message);
  }

  /// Injects a fake notification tap, as if the user opened the app
  /// from a background notification.
  void simulateMessageOpened(PushMessage message) {
    _logger.debug('PUSH: simulating opened message "${message.title}"');
    _openedMessages.add(message);
  }

  /// Closes the stub's stream controllers.
  ///
  /// Wired to the provider's `onDispose`; call it directly when using
  /// the stub standalone in tests.
  void dispose() {
    _tokenRefreshes.close();
    _foregroundMessages.close();
    _openedMessages.close();
  }
}

/// Provides the app-wide [PushService] binding.
///
/// Defaults to [DebugPushService]; when Firebase is enabled the override
/// list in `lib/app/config/firebase_overrides.dart` binds
/// `FirebasePushServiceImpl` instead.
@Riverpod(keepAlive: true)
PushService pushService(Ref ref) {
  final DebugPushService service = DebugPushService(
    ref.watch(logServiceProvider),
  );
  ref.onDispose(service.dispose);
  return service;
}
