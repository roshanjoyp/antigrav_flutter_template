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

## Sign-in providers (Firebase Auth)

`FirebaseAuthRepositoryImpl` supports email/password, Google, Apple, and
anonymous sign-in. It is not bound by default — `authRepositoryProvider`
returns the stub; override it to activate Firebase auth:

```dart
// e.g. in main.dart when creating the ProviderContainer:
final container = ProviderContainer(
  overrides: [
    authRepositoryProvider.overrideWith((ref) => FirebaseAuthRepositoryImpl()),
  ],
);
```

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

## Environment switching

`FirebaseConfig` resolves the options file from the active `AppEnv` at
startup — no extra wiring needed. To build against staging or production,
initialize the corresponding flavor (see the entry-point notes in
`lib/main.dart`).

## Committing credentials

The generated `firebase_options_*.dart` files contain client API keys.
These are app identifiers, not secrets — security comes from Firebase
Security Rules — so committing them to a **private** repo is standard
practice. Do not commit them to a public repo.
