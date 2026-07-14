# Firebase Setup

The template ships with Firebase **disabled** and runs entirely on stub
services — no Firebase project is required to build or run it. This guide
enables the Firebase layer, one environment at a time.

How it fits together:

- `lib/core/config/firebase/firebase_options_{dev,staging,prod}.dart` — one
  options file per environment. They ship as placeholders (marked with a
  `FIREBASE_OPTIONS_PLACEHOLDER` header) that throw if used; the FlutterFire
  CLI overwrites each file in place with real credentials.
- `lib/core/config/firebase/firebase_config.dart` — picks the options file
  matching the active `AppEnv` (see `AppFlavor`) and initializes Firebase at
  startup. Holds the master `enabled` switch.
- `lib/main.dart` — calls `FirebaseConfig.initialize()` inside the guarded
  zone. A no-op until `enabled` is flipped to `true`.

---

## 1. Prerequisites

```sh
# Firebase CLI (https://firebase.google.com/docs/cli)
curl -sL https://firebase.tools | bash
firebase login

# FlutterFire CLI
dart pub global activate flutterfire_cli
```

## 2. Create Firebase projects

Create one Firebase project **per environment** in the
[Firebase console](https://console.firebase.google.com/) (or via
`firebase projects:create`):

| Environment | Suggested project ID |
| :--- | :--- |
| Development | `<yourapp>-dev` |
| Staging | `<yourapp>-staging` |
| Production | `<yourapp>-prod` |

Separate projects keep dev data, analytics, and crash reports out of
production. (A single project for all three works for evaluation, but is
not recommended for a shipping app.)

## 3. Generate options per environment

Run from the repo root — each command targets one project and overwrites the
matching placeholder file:

```sh
flutterfire configure \
  --project=<yourapp>-dev \
  --out=lib/core/config/firebase/firebase_options_dev.dart

flutterfire configure \
  --project=<yourapp>-staging \
  --out=lib/core/config/firebase/firebase_options_staging.dart

flutterfire configure \
  --project=<yourapp>-prod \
  --out=lib/core/config/firebase/firebase_options_prod.dart
```

Notes:

- Run `dart setup/setup.dart` (the app rename script) **before** this step,
  so the registered Android package name / iOS bundle ID are your real ones.
- When prompted, select the platforms you ship to. The CLI also writes
  platform files (`android/app/google-services.json`,
  `ios/Runner/GoogleService-Info.plist`) — for multi-project setups these
  are per-project too; the CLI manages them for the most recently
  configured project.
- Configure only `dev` to start with; staging/prod can wait until you need
  those builds.

## 4. Enable Firebase

In `lib/core/config/firebase/firebase_config.dart`, flip:

```dart
static const bool enabled = false;  // → true
```

If `enabled` is `true` while an environment's options file is still a
placeholder, startup fails loudly with an `UnsupportedError` naming the
exact file and command to run — that is intentional.

## 5. Verify

```sh
flutter run
```

The app should start with no Firebase errors in the log. The environment
used is whatever `main.dart` passes to `AppFlavor.initialize`
(`AppEnv.development` by default).

---

## How the app switches to Firebase (automatic)

Flipping `FirebaseConfig.enabled` to `true` does two things at startup:
Firebase initializes for the active flavor, **and** every stub is swapped
for its Firebase implementation via the provider override list in
`lib/app/config/firebase_overrides.dart` — auth, profile (Firestore),
Crashlytics, Analytics, and push (FCM; see
docs/setup/PUSH_NOTIFICATIONS_SETUP.md for its platform steps). No
call-site changes anywhere.

When you add your own Firebase-backed service or repository, add its
override to that same list.

## Sign-in providers (Firebase Auth)

`FirebaseAuthRepositoryImpl` supports email/password, Google, Apple, and
anonymous sign-in (bound automatically — see above).

Per provider, in Firebase console → **Authentication → Sign-in method**:

1. **Email/password & Anonymous** — toggle on. No platform config needed.
2. **Google** — toggle on, then:
   - *Android*: add your SHA-1 (and SHA-256) fingerprints in Project
     settings → your Android app, then re-download
     `google-services.json`. Pass the **web** client ID (Sign-in method →
     Google → Web SDK configuration) as `googleServerClientId` to
     `FirebaseFederatedSignIn` — required for the ID token on Android.
   - *iOS/macOS*: add the reversed client ID from
     `GoogleService-Info.plist` as a URL scheme in Xcode
     (Runner → Info → URL Types).
   - *Web*: no extra config — the popup flow is used automatically.
3. **Apple** — toggle on, then enable the *Sign in with Apple* capability
   for your bundle ID (Xcode → Signing & Capabilities, plus the Apple
   Developer portal). Uses Firebase's built-in `AppleAuthProvider`; no
   extra package.

All auth methods return the template's `Result` type — Firebase error
codes are mapped to user-presentable messages in
`lib/features/auth/data/firebase_auth_error_mapper.dart`.

## Firestore (profile example feature)

The profile feature (`lib/features/profile/`) is the template's reference
end-to-end Firestore slice: `FirestoreProfileRepositoryImpl` stores one
document per user in the `profiles` collection (bound automatically when
Firebase is enabled).

1. In Firebase console → **Firestore Database**, create a database
   (production mode) per environment project.
2. Publish security rules that let each user manage only their own
   profile document:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /profiles/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

Note: the signed-out fallback profile (`demo-user`) works only against
the stub repository — with the rules above, Firestore requires a
signed-in user, which is the correct production behaviour.

## Crashlytics & Analytics

`FirebaseCrashServiceImpl` and `FirebaseAnalyticsServiceImpl` implement the
template's `CrashService` / `AnalyticsService` interfaces (bound
automatically when Firebase is enabled).

Setup notes:

- **Re-run `flutterfire configure`** (per environment) after adding these
  packages — it wires the required Android Gradle plugins
  (`google-services`, `firebase-crashlytics`) into the project.
- **Crashlytics** must be enabled once per project in the Firebase console
  (Release & Monitor → Crashlytics) and only reports in non-debug builds
  by default. It has no web/desktop support; `FirebaseCrashServiceImpl`
  degrades to logged no-ops there (it never throws by contract — it sits
  inside the global error handlers wired in `main.dart`).
- **Analytics** needs no console setup; events appear in DebugView when
  the device is started with the `--dart-define` / adb debug flag
  documented in the Firebase docs.

## Environment switching

`FirebaseConfig` resolves the options file from the active `AppEnv` at
startup — no extra wiring needed. To build against staging or production,
run the matching flavor + entry point:

```sh
flutter run --flavor staging --target lib/main_staging.dart
flutter build apk --flavor prod --target lib/main_prod.dart
```

Each flavor has its own application/bundle id suffix (`.dev` / `.stg`),
so register those ids in the matching Firebase project when running
`flutterfire configure` per environment.

## Committing credentials

The generated `firebase_options_*.dart` files contain client API keys.
These are app identifiers, not secrets — security comes from Firebase
Security Rules — so committing them to a **private** repo is standard
practice. Do not commit them to a public repo.
