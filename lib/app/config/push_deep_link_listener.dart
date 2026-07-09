import 'dart:async';

import 'package:craft_flutter_template/app/router/app_router.dart';
import 'package:craft_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:craft_flutter_template/core/services/push_service/push_service.dart';
import 'package:craft_flutter_template/core/services/push_service/push_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_deep_link_listener.g.dart';

/// Routes notification taps to their in-app destination.
///
/// Covers both tap entry points: the message that launched the app from
/// a terminated state ([PushService.getInitialMessage]) and taps that
/// foregrounded a backgrounded app ([PushService.onMessageOpened]).
/// Messages carrying a `route` key in their data payload (see
/// [PushMessage.route]) are sent to that go_router location; messages
/// without one are ignored here.
///
/// Activated by a single `ref.watch` in the root `App` widget, so it
/// lives exactly as long as the app UI. Works identically with the
/// debug and FCM implementations.
@Riverpod(keepAlive: true)
void pushDeepLinkListener(Ref ref) {
  final PushService push = ref.watch(pushServiceProvider);

  void openRoute(PushMessage message) {
    final String? route = message.route;
    if (route == null) return;
    ref.read(logServiceProvider).info('Push deep link -> $route');
    ref.read(goRouterProvider).go(route);
  }

  unawaited(
    push.getInitialMessage().then((PushMessage? message) {
      if (message != null) openRoute(message);
    }),
  );
  final StreamSubscription<PushMessage> subscription = push.onMessageOpened
      .listen(openRoute);
  ref.onDispose(subscription.cancel);
}
