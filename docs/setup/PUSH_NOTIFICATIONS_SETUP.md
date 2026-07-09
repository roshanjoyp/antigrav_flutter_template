# Push Notifications Setup (FCM)

The template ships with push **stubbed**: `DebugPushService` logs every
call and can simulate incoming messages, so the receive → deep-link flow
is demonstrable with no Firebase project. Push switches to Firebase Cloud
Messaging together with the rest of the Firebase layer — there is no
separate enable flag.

## What you get

- `PushService` — vendor-agnostic contract (permission, token, foreground
  stream, tap stream, initial message, topics)
- `FirebasePushServiceImpl` — FCM implementation, bound automatically by
  `firebaseServiceOverrides()` when `FirebaseConfig.enabled` is `true`
- **Notification-tap deep linking** — taps navigate to the go_router
  location in the message's `route` data key
  (`lib/app/config/push_deep_link_listener.dart`)
- A background-message handler registered in `main.dart`

## Prerequisites

Complete [FIREBASE_SETUP.md](FIREBASE_SETUP.md) first. Flipping
`FirebaseConfig.enabled` to `true` is what activates
`FirebasePushServiceImpl` — nothing push-specific to switch.

## Platform setup

### iOS (APNs — required, FCM does not work without it)

1. Apple Developer portal → Keys → create an **APNs Auth Key** (.p8).
2. Firebase console → Project settings → Cloud Messaging → your iOS app →
   upload the key with its Key ID and Team ID.
3. In Xcode (`open ios/Runner.xcworkspace`): Runner target →
   Signing & Capabilities → add **Push Notifications** and
   **Background Modes → Remote notifications**.
4. Real device required — the iOS simulator receives no APNs pushes.

### Android

Works out of the box with `google-services.json` in place. Notes:

- Android 13+ needs the runtime notification permission — that's what
  `PushService.requestPermission()` prompts for (routed through the
  template's `PermissionService`).
- The default notification icon is the app icon; for a proper silhouette
  icon add `com.google.firebase.messaging.default_notification_icon`
  metadata in `android/app/src/main/AndroidManifest.xml`.

## Using the service

```dart
final PushService push = ref.read(pushServiceProvider);

// 1. Ask for permission at a sensible moment (not cold start).
final bool granted = await push.requestPermission();

// 2. Get the device token; send it (and every onTokenRefresh emission)
//    to your backend if you target individual devices.
final Result<String?> token = await push.getToken();

// 3. Foreground messages show no system notification — react in-app.
push.onForegroundMessage.listen((PushMessage m) => showSnackBar(m.title));

// 4. Topics for broadcast segments.
await push.subscribeToTopic('news');
```

## Deep linking

Send a data key `route` with a go_router location:

```json
{
  "notification": {"title": "Profile updated"},
  "data": {"route": "/profile"}
}
```

Tapping the notification navigates there — from background
(`onMessageOpened`) and from terminated state (`getInitialMessage`),
both handled by `pushDeepLinkListenerProvider`, which the root `App`
widget activates. Messages without `route` are delivered but trigger no
navigation.

## Background messages

`firebaseMessagingBackgroundHandler`
(`lib/core/services/push_service/firebase_push_service_impl.dart`) runs
in a separate isolate for background/terminated data messages. It only
logs by default; extend it for silent data processing (initialize
Firebase inside the handler before using other Firebase services).

## Testing a push

1. Run the app on a real device with Firebase enabled, call
   `requestPermission()` and log `getToken()`.
2. Firebase console → Messaging → "Send test message" → paste the token.
   App in background → notification appears; tap it → app opens.
3. To test deep linking from the console, add a custom-data pair
   `route = /profile` in the advanced options.

## Errors

Failures come back as `AppException` with `push/...` codes
(`push/token-failed`, `push/subscribe-failed`, …) and are logged via
`LogService` first. Permission denial is a plain `false`, not an error.
