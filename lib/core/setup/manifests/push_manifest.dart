import 'package:craft_flutter_template/core/setup/setup_step.dart';

/// Setup steps for the FCM push notification module.
///
/// Push rides on the Firebase module and is enabled with it
/// (`FirebaseConfig.enabled`); these steps are skipped while Firebase is
/// disabled.
const List<SetupStep> pushSetupSteps = [
  SetupStep(
    id: 'push.apns_key',
    module: SetupModule.push,
    kind: SetupCheckKind.manual,
    title: 'APNs auth key uploaded to Firebase (iOS delivery)',
    remediation:
        'Create an APNs key in the Apple Developer portal and upload it: '
        'Firebase console → Project settings → Cloud Messaging.',
    docPath: 'docs/setup/PUSH_NOTIFICATIONS_SETUP.md',
    link: 'https://console.firebase.google.com/',
  ),
  SetupStep(
    id: 'push.fcm_token',
    module: SetupModule.push,
    kind: SetupCheckKind.runtimeCheck,
    title: 'FCM registration token issued on-device',
    remediation:
        'Run a debug build on a real device (iOS requires the push '
        'capability + APNs key) and open the Setup Status screen.',
    docPath: 'docs/setup/PUSH_NOTIFICATIONS_SETUP.md',
  ),
];
