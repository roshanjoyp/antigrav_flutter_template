# CRAFT — Flutter Starter Template

A production-ready Flutter template for shipping real apps, not wiring
boilerplate. Clean architecture, Riverpod codegen, and a stub-first module
system: everything compiles and runs on day one with **zero external
setup** — then you flip on Firebase, payments, or push when you're ready.

> Rename it in one command, verify your setup with a doctor CLI and an
> in-app status screen, and follow a written guide for every step from
> "clone" to "store listing".

<!-- TODO(listing): hero screenshot / GIF strip goes here -->

## Feature matrix

| Area | What you get |
| :--- | :--- |
| Architecture | Clean architecture per feature (presentation / domain / data), `Result`-based error contract, no logic in widgets |
| State | Riverpod 3 with code generation, provider-override pattern for swapping stub ↔ real implementations |
| Navigation | go_router with startup redirect + onboarding flow wired in |
| Theming | Design tokens (`AppColors`, `AppConstants`), Material 3 dark + light themes, themed core widget set, golden tests |
| Services | Logging, crash reporting, analytics, connectivity, permissions, secure storage, push, HTTP network client — interface + stub + real impl each |
| Firebase module | Auth (email / Google / Apple / anonymous), Firestore example feature, Crashlytics, Analytics; flavor-aware dev/staging/prod options |
| Paywall module | RevenueCat subscriptions behind an entitlement, stub-first so the paywall screen works offline |
| Push module | FCM tokens, foreground/background handlers, notification-tap deep links |
| Verification | `tool/doctor.dart` static checks, debug-only Setup Status screen (runtime checks), git-tracked production-readiness checklist |
| Docs | `guide/` walkthroughs + full architecture/setup reference in `docs/` |
| Tests | 181 unit/widget/golden tests with reusable override patterns |

Every module ships **disabled** behind a single config switch
(`FirebaseConfig.enabled`, `RevenueCatConfig.enabled`) with stub
implementations bound by default — the app runs offline out of the box.

## Quick start

```bash
# 1. Clone (or unzip) as your app's folder name
git clone <repo-url> your_app && cd your_app

# 2. Rename everything — app name, description, package/bundle ids,
#    across Android, iOS, web, Linux, Windows, macOS, Dart, and docs
dart setup/setup.dart

# 3. Install and generate
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# 4. Run — pick an environment (dev / staging / prod)
flutter run --flavor dev -t lib/main_dev.dart
```

Each flavor gets its own application id (`.dev` / `.stg` suffix) and
launcher label, so all three environments install side by side. Desktop
and web have no flavor concept — plain `flutter run` uses the
development default in `lib/main.dart`.

Then check where you stand:

```bash
dart run tool/doctor.dart
```

The doctor reports every setup step (`✓ x/y complete`) with exact
remediation for anything missing, plus a production-readiness section.
In a debug build, the **Setup Status** screen (`/setup-status`, linked
from the test panel at `/test`) runs the checks that need a live app —
Firebase initialization, auth round-trip, FCM token.

## Enabling modules

Each integration is a documented, verifiable flip:

| Module | Switch | Guide |
| :--- | :--- | :--- |
| Firebase (auth, Firestore, Crashlytics, Analytics) | `FirebaseConfig.enabled` | [docs/setup/FIREBASE_SETUP.md](docs/setup/FIREBASE_SETUP.md) |
| RevenueCat paywall | `RevenueCatConfig.enabled` | [docs/setup/REVENUECAT_SETUP.md](docs/setup/REVENUECAT_SETUP.md) |
| Push notifications (FCM) | rides on the Firebase switch | [docs/setup/PUSH_NOTIFICATIONS_SETUP.md](docs/setup/PUSH_NOTIFICATIONS_SETUP.md) |
| REST/HTTP network layer (core, ships with every config) | `NetworkConfig.enabled` | [lib/core/services/network_service/README.md](lib/core/services/network_service/README.md) |

The doctor and Setup Status screen know about every step in these guides
— nothing depends on you remembering console clicks.

## Learn the codebase

Start with the walkthroughs in [`guide/`](guide/README.md):

1. **Anatomy of a Feature** — the profile feature traced file by file
2. **Add a Feature, Step by Step** — from empty folder to routed, tested screen
3. **Models vs. Entities** — why persistence never leaks into the UI
4. **Controllers and Views** — how state reaches the screen

Reference docs live in [`docs/`](docs/README.md): architecture flow,
Riverpod conventions, the service catalog, and per-module setup.

## Before you ship

The **Readiness** tab of the Setup Status screen (and the doctor CLI)
tracks a production checklist — launcher icon, splash, release signing,
store metadata, privacy policy, plus module-specific items (APNs key,
sandbox purchases). State lives in the git-tracked
[`checklist.yaml`](checklist.yaml): diffable, PR-reviewable, and shared
with your team. Skip what doesn't apply (with a recorded reason), add
your own items.

## FAQ

**Why don't the stubs do anything real?**
By design. Stubs prove the architecture and keep the template runnable
with no accounts or keys. Real implementations already exist beside them
(Firebase, RevenueCat) and are bound via provider overrides when you
flip the module switch — you never rewrite a stub.

**Which state management / router? Can I swap them?**
Riverpod (codegen) and go_router, deliberately locked in. Every
controller, guide, and test assumes them; a parallel Bloc variant would
double the maintenance surface for no gain.

**Does it build on all six platforms?**
Android, iOS, web, macOS, Linux, and Windows targets are included and
covered by the rename script. A manual-trigger CI workflow
(`gh workflow run ci.yml`) proves the analyze/test suite plus Android
and iOS release builds.

**How do I keep generated files in sync?**
`*.g.dart`/`*.freezed.dart` are committed. After changing annotated
code, run build_runner and commit the output — the doctor and CI both
check freshness.

**Where do I add my first feature?**
Follow [guide/02_add_a_feature.md](guide/02_add_a_feature.md) — it walks
the exact folder layout, codegen, routing, and test pattern.

## Requirements

- Flutter 3.41+ (stable) / Dart 3.10+
- Platform toolchains for the targets you ship (Xcode, Android SDK, …)

## License

See [LICENSE](LICENSE). Purchased and generated copies ship the CRAFT
Commercial License in that file — two tiers: **Personal** (one
developer, unlimited apps) and **Team** (one organization, unlimited
developers and apps). Copies bought on CodeCanyon are governed by the
Envato Market License instead.
