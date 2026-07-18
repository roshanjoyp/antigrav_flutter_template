# Changelog

All notable changes to the CRAFT Flutter template are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project uses [semantic versioning](https://semver.org/): breaking
template-structure changes bump the major, new modules/features the minor,
fixes the patch. `pubspec.yaml`'s `version:` tracks the template release.

## [Unreleased]

### Added

- **Commercial license (Personal / Team tiers).**
  `LICENSE_COMMERCIAL.md` holds the terms for Gumroad/direct sales; the
  generator now ships it as the `LICENSE` of every generated project so
  buyers never receive the repo's MIT text. Drift-guarded in
  `generator/test/template_integrity_test.dart`.
- **Live demo deployment.** The template app's web build mounts at
  `/demo` next to the landing page (`flutter build web --base-href
  /demo/`, dev flavor on stub services); the landing page nav, hero,
  and bottom CTA link to it. Deploy notes in `landing/README.md`.

- **Platform flavors (dev / staging / prod).** Per-environment entry
  points (`lib/main_dev.dart`, `main_staging.dart`, `main_prod.dart` over
  a shared `lib/app/bootstrap.dart`), Android `productFlavors` with
  `.dev`/`.stg` application-id suffixes and per-flavor launcher labels,
  and iOS flavor schemes (`dev`/`staging`/`prod`) with per-flavor bundle
  ids and display names. All three environments install side by side:
  `flutter run --flavor dev -t lib/main_dev.dart`. The rename script
  covers all the new value locations.
- Generator now excludes `configurator/` (the Phase 9 web configurator
  package) from generated projects.

### Fixed

- Generated zips were written empty (`archive` 4.x made
  `ZipFileEncoder.addFile` async; the unawaited adds closed an empty
  archive). Zipping is now synchronous and regression-tested.

### Changed

- **Widget/golden tests render real fonts.** `test/flutter_test_config.dart`
  loads Roboto + MaterialIcons from the Flutter SDK cache, so goldens show
  actual glyphs instead of the block test font. Goldens are generated on
  macOS; regenerate with `flutter test --update-goldens test/goldens`.
- **Startup screen redesigned as a calm demo hub.** Uniform
  `AppNavTile` rows (new core widget, golden-tested) grouped into
  Explore / Development sections replace the mixed-size buttons; the
  permanent spinner is now a one-line status indicator that resolves
  to "Services ready". Dev-only destinations are compiled out of
  release builds together with their routes.
- **iOS minimum deployment target raised to 15.0** (was 13.0) —
  required by `cloud_firestore` / Firebase iOS SDK 11+.

## [1.0.0] — 2026-07-10

First production-ready release.

### Architecture & core

- Clean architecture per feature (presentation / domain / data) with
  Riverpod codegen, go_router, and a `Result`-based error contract.
- Core service layer (logging, analytics, crash reporting, connectivity,
  permissions, secure storage, push) — every service stub-first, so the
  template runs with zero external setup.
- Design system: `AppColors`/`AppConstants` tokens, themed core widget set,
  dark + light themes, golden tests pinning both.

### Modules (all optional, off by default)

- **Firebase** — Auth (email/Google/Apple/anonymous), Firestore profile
  example feature, Crashlytics, Analytics; flavor-aware options
  (dev/staging/prod) behind a single `FirebaseConfig.enabled` switch.
- **RevenueCat paywall** — entitlement-gated subscriptions behind
  `RevenueCatConfig.enabled`, stub-first repository, `/paywall` screen.
- **FCM push** — token handling, foreground/background handlers,
  notification-tap deep links via go_router.
- **Onboarding** — persisted seen-state with first-run redirect.

### Tooling & guidance

- `setup/setup.dart` — interactive rename across Android, iOS, web,
  Linux, Windows, macOS, Dart sources, and docs (name, package/bundle
  ids, description).
- `tool/doctor.dart` — setup doctor: static checks with per-failure
  remediation, module-aware skipping, production-readiness report.
- Setup Status screen (debug-only) — runtime checks (Firebase init,
  anonymous auth, FCM token) + readiness checklist tab backed by
  git-tracked `checklist.yaml`.
- `guide/` — buyer walkthroughs: anatomy of a feature, add a feature,
  models vs. entities, controllers and views.
- Test suite: 168 tests (unit, widget, golden) with provider-override
  patterns documented for reuse.
- Manual-trigger GitHub Actions workflow: checks + Android/iOS build
  proofs (`gh workflow run ci.yml`).
