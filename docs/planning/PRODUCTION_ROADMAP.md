# Production Roadmap — craft_flutter_template

_Created: 2026-07-08 — updated: 2026-07-09 — status: planning_

## Product vision (two tiers)

**v1 — Premium template (zip/repo product).** Take the template from its current
state (solid architecture, stub services, no tests) to a production-grade,
sellable premium Flutter boilerplate — listable on CodeCanyon/Gumroad and
positioned as "Flutter + Firebase starter, clone and ship."

**v2 — Web configurator (the real product).** A Flutter web app where buyers
configure their template — backend, monetization, push, i18n, onboarding,
theming preset, app name/package — then pay and download a **generated** zip
containing only what they selected. Model: `start.spring.io` / ApparenceKit.
The generated zip additionally contains:

- **`guide/`** — documentation generated to match the buyer's exact
  configuration: how everything binds together, how state management flows,
  how to add a feature, when to add models vs. entities. No chapters for
  modules they didn't buy.
- **`tool/doctor.dart`** — a setup doctor CLI that verifies post-download
  setup steps (config files present, bundle IDs match, pub get resolves,
  build_runner fresh) and reports `✓ x/y steps complete` with exact
  next-step instructions per failure.
- **In-app Setup Status screen** — dev-only screen (natural extension of the
  existing `test_control_panel`) running *runtime* checks static analysis
  can't: Firebase initializes, anonymous auth succeeds, FCM token issued.
  Stripped from release builds.
- **Production Readiness checklist** — dev-only checklist UI (sibling of the
  Setup Status screen) covering what a shipping app needs: icon replaced,
  splash branded, flavors configured, store metadata, signing, plus
  module-conditional items (push → APNs key; paywall → products created &
  sandbox-tested). Users can skip items they don't want and add their own —
  see Phase 5 for the full design.

Steps that can't be machine-verified (console work: creating the Firebase
project, APNs keys, RevenueCat dashboard) get guided instructions + deep
links + a manual "I've done this" confirmation. Target ~80% hard
verification, ~20% guided-with-confirmation.

## Locked-in opinions (not configurable — ever, for v1/v2)

- **State management: Riverpod (codegen).** Offering Bloc as an option means
  maintaining a parallel rewrite of every controller and screen forever.
- **Routing: go_router.** Same reasoning.
- Configurable axes are **additive modules only** (backend impl, paywall,
  push, onboarding, i18n, theming presets, branding). These sit behind the
  existing service/repository interfaces, so generation = include/exclude,
  never rewrite. A second state-management flavor is a possible paid
  expansion later, not a v1/v2 goal.

## Current assessment

Architecture, docs, theming, and the setup/rename script are already stronger
than most templates on the market. `setup/setup.dart` proves the programmatic
project-rewrite mechanics the generator needs. What's missing is the layer
buyers actually pay for: real backend integrations, monetization, push,
tests, CI — and for v2, the module manifests + generator + configurator.
Roughly 60–70% of the way to v1.

---

# v1 phases

## Phase 1 — Firebase integration layer (highest value)

The template is backend-agnostic by design; keep that. Add Firebase as the
**first-party reference implementation** of the existing interfaces, behind
the same abstractions.

- [x] Add Firebase core setup: `firebase_core`, flavor-aware `firebase_options` per environment (dev/staging/prod), documented `flutterfire configure` workflow (2026-07-09)
- [x] **Auth**: `FirebaseAuthRepositoryImpl` implementing the existing `AuthRepository` — email/password, Google Sign-In, Apple Sign-In, anonymous; map Firebase errors into the `Result` type (2026-07-09; also refactored `AuthRepository` to `Result` returns per CLAUDE.md §3, renamed stub to `StubAuthRepository`, expanded `UserEntity`)
- [x] **CrashService**: Crashlytics implementation (2026-07-09)
- [x] **AnalyticsService**: Firebase Analytics implementation (2026-07-09)
- [x] **Firestore example feature**: one small end-to-end feature (e.g. user profile) showing the full clean-architecture flow — Firestore data source → repository → Riverpod controller → view. This is the "how do I actually use this" sample buyers look for first (2026-07-09: profile feature + first unit tests in test/)
- [x] Wire service selection through flavors/env so stub vs. Firebase impls are swappable via a single provider override (2026-07-09: lib/app/config/firebase_overrides.dart, applied in main.dart on FirebaseConfig.enabled)
- [x] Update `docs/architecture/SERVICES.md` and `docs/architecture/ARCHITECTURE_FLOW.md` to cover the Firebase layer (2026-07-09)

## Phase 2 — Monetization + push (what buyers pay for)

- [x] **Paywall module**: RevenueCat (`purchases_flutter`) integration — subscription entitlement provider, paywall screen using existing core widgets, restore purchases, sandbox testing docs (2026-07-09: stub-first `SubscriptionRepository`, `RevenueCatConfig.enabled` switch mirroring the Firebase pattern, `/paywall` screen, docs/setup/REVENUECAT_SETUP.md)
- [x] **Push notifications**: FCM integration — token handling, foreground/background handlers, permission flow through the existing `PermissionService`, notification tap → deep link via go_router (2026-07-09: `PushService` in core/services, `route` data-key deep-link convention via `pushDeepLinkListenerProvider`, docs/setup/PUSH_NOTIFICATIONS_SETUP.md; bound with the Firebase override set)
- [x] **Onboarding flow**: 2–3 screen onboarding with "seen" state persisted (secure storage or shared prefs), wired into the startup/router redirect logic (2026-07-09: new `StorageService` (secure-storage default, in-memory for tests), `OnboardingRepository`, 3-page flow, startup redirects first runs to `/onboarding`)

## Phase 3 — Tests (currently zero — no `test/` directory)

- [x] Unit tests: `Result` type, `AppFlavor`, controllers, stub + Firebase repository impls (mocktail), error mappers, debug/Firebase services (2026-07-09)
- [x] Widget tests: all six core widgets, startup view, profile screen incl. error/retry states (2026-07-09; no auth screens exist yet — add tests with the feature)
- [x] Riverpod tests: provider overrides pattern documented as the example for buyers to follow (2026-07-09: test/features/profile/profile_controller_test.dart; also documents the Riverpod 3 pause-when-unlistened gotcha)
- [x] Golden tests for the theme (light + dark) — optional but a strong differentiator (2026-07-10: test/goldens/ — core-widget gallery in both themes + Setup Status screen; regenerate with `flutter test --update-goldens test/goldens`)
- [x] Target: enough coverage that "tested" is an honest listing bullet (2026-07-09: 81% of instrumented lines, excluding generated; uncovered: Firestore impl (needs fake_cloud_firestore or emulator), theme/router wiring, test_control_panel)

## Phase 4 — CI/CD

- [x] GitHub Actions workflow: `flutter analyze` + `dart format --set-exit-if-changed` + `flutter test` on PR/push (2026-07-10: `.github/workflows/ci.yml`, also runs `custom_lint` since `flutter analyze` doesn't cover riverpod_lint; uploads lcov coverage artifact; fixed the two pre-existing analyzer infos to get green. 2026-07-10 later: switched to **manual-only trigger** (`workflow_dispatch`) by owner preference — run from the Actions tab or `gh workflow run ci.yml` before releases; the iOS job is the only iOS compile-proof, so fire it at least per release)
- [x] Build jobs: Android APK/AAB and iOS (no signing) to prove the template compiles on CI (2026-07-10: `build-android` + `build-ios` jobs, gated on the checks job)
- [x] `build_runner` check to catch stale generated files (2026-07-10: regenerate + `git diff --exit-code` — required, not optional, because generated files are committed)

## Phase 5 — Buyer guidance layer (guide + doctor + setup screen)

Valuable in the plain v1 zip on day one, and the per-module manifests it
produces are exactly what the v2 generator consumes later.

- [x] **`guide/`**: restructure the `docs/architecture/` material (ARCHITECTURE_FLOW, RIVERPOD_GUIDE, SERVICES) into buyer-facing walkthroughs — "anatomy of a feature" (trace one real feature layer by layer), "add a new feature step-by-step", "model vs. entity: when and where", "how a controller binds to a view". Markdown first; pretty rendered version is later polish (2026-07-10: guide/ with 4 walkthroughs traced against the profile feature; linked from docs/README.md)
- [x] **Setup-steps manifest**: per module, a declared list of setup steps, each with a check implementation (static or runtime) or `manual` flag. Single source of truth for doctor CLI, in-app screen, and (later) generator (2026-07-10: lib/core/setup/ — SetupStep + per-module manifests; check impls live with their runners, bound by id with drift-guard tests)
- [x] **`tool/doctor.dart`**: doctor CLI running the static checks — config files present and non-placeholder, bundle IDs consistent post-rename, `pub get` resolves, generated files fresh. `x/y` summary + per-failure remediation text (same mechanics/style as `setup/setup.dart`) (2026-07-10; also detects module enablement from the config switches and skips disabled modules' steps)
- [x] **Setup Status screen**: dev-only runtime checks (Firebase init, auth ping, FCM token) as an extension of `test_control_panel`; excluded from release builds (2026-07-10: /setup-status behind kDebugMode — /test now gated too — linked from the test panel)
- [x] **Production Readiness checklist** (2026-07-10: ReadinessItem definitions in the module manifests, checklist.yaml state file + dependency-free parser, doctor readiness section with auto-checks — icon/description/signing — and Readiness tab on the Setup Status screen; in-app view is read-only by design since a device app can't write to the repo, so state edits happen in the file itself): dev-only UI (sibling tab of the Setup Status screen, also reported by the doctor CLI) listing what a shipping app needs — icon replaced (auto-check: hash vs. default Flutter icon), splash branded, pubspec description changed, flavors configured, signing, store metadata, privacy policy — plus module-conditional items sourced from the same per-module manifests (push → APNs key uploaded, notification icon; paywall → RevenueCat products created, sandbox purchase tested). Design rules:
  - **State lives in a git-tracked file** (`checklist.yaml`) in the generated project — diffable, PR-reviewable, shared via `git pull`; never per-device storage, no backend
  - **Skip/include is first-class**: dismissing an item sets `status: skipped` (optional reason) rather than deleting it — auditable, "show skipped" toggle in the UI, skipped items excluded from the `x/y` completion count
  - **Custom tasks**: users append their own items to the same file in a free-form section; optional free-text `owner:` field per task ("who's doing this" for small teams). No accounts, no assignment backend — real multi-user task management is out of scope (a possible hosted upsell once the v2 configurator has accounts, never a blocker)
  - **Staleness containment**: items are link-don't-restate (one-line what/why + deep link to the authoritative doc; no step-by-step prose that rots), verifiable-first (auto-checks break visibly instead of silently going stale), and checklist definitions ship in the module manifests so every template release can revise them

## Phase 6 — Polish for listing

- [x] `pubspec.yaml`: replace default `description: "A new Flutter project."` and strip the boilerplate Flutter comments (2026-07-10; setup.dart now prompts for the buyer's description, readiness auto-check flags the template's own)
- [x] Sweep remaining default-project artifacts (launcher icons, default bundle display names on desktop targets) (2026-07-10: web title/manifest, Linux/Windows window titles + version info rebranded; rename script now covers web + all desktop targets + tool/ imports; setup.dart split into setup/src/ modules per the 200-line rule; icons themselves await the launcher_icons decision below)
- [x] Add `flutter_launcher_icons` + `flutter_native_splash` configs so buyers rebrand assets in one command (extend `setup/setup.dart` to prompt for them) (2026-07-10: packages approved and added; assets/branding/ placeholder mark generated + stamped across all platforms; setup.dart offers regeneration post-rename; icon readiness auto-check now flags the CRAFT placeholder sizes too)
- [x] README rewrite for the *buyer* audience: feature matrix, screenshots/GIFs, quick-start, FAQ (2026-07-10: text complete; screenshot/GIF slots marked TODO(listing) pending marketing captures)
- [x] CHANGELOG.md + semantic versioning — marketplaces reward maintained products (2026-07-10: Keep-a-Changelog format, 1.0.0 entry)
- [ ] Decide license/pricing model: single-app vs. multi-app license text (current LICENSE is for the open repo; a sold template needs its own terms)
- [ ] Demo app build (web demo or Play Store internal track) linked from the listing

## Phase 7 — Listing & launch (not code, but on the critical path)

- [ ] CodeCanyon listing: title/keywords, gallery images, feature bullets, docs bundle
- [ ] Gumroad listing at a higher price point (own-channel margin)
- [ ] Launch posts: r/FlutterDev, Flutter Community Discord, X — build-in-public thread doubles as marketing

---

# v2 phases (web configurator)

Do not start until v1 Phases 1–3 exist — the configurator sells modules, so
the modules must exist first.

## Phase 8 — Generator + modularization

- [x] Restructure repo into a monorepo: `template/` (or bricks), `generator/`, later `configurator/` + `backend/` (2026-07-10: **owner-approved deviation** — app stays at repo root, `generator/` is a sibling pure-Dart package with `--template-root`; physical `template/` move deferred to Phase 9 when configurator/backend actually arrive)
- [x] ~~Mason bricks~~ (2026-07-10: **owner-approved deviation** — manifest + `// MODULE(id)` markers over the live template instead; exploration showed only ~40 wiring lines in 12 shared files, and drift-guard tests + the compile matrix mechanically prevent the marker rot mason was chosen to avoid, without forking the tested source into bricks)
- [x] Module manifest: files + pubspec entries + setup steps (from Phase 5) per brick (2026-07-10: `generator/lib/src/module_registry.dart` — ownedPaths globs, pubspec deps, checklist prefixes, requires-relations per module)
- [x] Generator pipeline: config JSON → compose bricks → rewrite pubspec → rename (reuse `setup.dart` logic) → `flutter analyze` sanity gate → zip (2026-07-10: `dart run craft_generator:generate` — staging copy, owned-file deletion, marker pass, pubspec/checklist pruning, non-interactive setup.dart rename, gate levels none/analyze/test, zip; failing staging preserved for inspection)
- [x] CI matrix: generate each module toggle (and key combinations), verify each output compiles and passes tests — without this, broken permutations *will* ship (2026-07-10: local-first per CI preference — `dart run craft_generator:verify_matrix` quick tier 6 combos ~1 min / full tier all 12 valid combos ~3 min with test gates on all-on+all-off, 12/12 green; plus manual-dispatch `generator-matrix.yml` workflow and 5 drift-guard tests incl. the import-boundary anti-rot guard)

## Phase 9 — Configurator app + payments + delivery

- [x] Flutter web configurator (dogfooding: "this site was built with the template" is marketing) — a form producing config JSON. UI design approved 2026-07-10: interactive mockup + token/type/component spec in `docs/design/` (monochrome studio-portfolio direction, sharp corners, live preview panel as the core demo moment) (2026-07-14: `configurator/` Flutter web package — v0.4 "breathable" design pass applied to mockup first, bundled OFL fonts (Jost/Inter/JetBrains Mono), Riverpod codegen, module catalogue drift-guard-tested against the generator registry, live preview (files/pubspec/steps), config.json download verified end-to-end in headless Chrome and fed through the real generator to a valid zip. Found+fixed en route: generator zips were empty — archive 4.x async `addFile` unawaited — and staging now denies `configurator/`. Theme presets deferred until the generator supports them)
- [ ] Generator service on Cloud Run: private template baked into the image; receives config + payment proof, generates, uploads zip, returns short-lived signed URL
- [ ] Payments — v1: Gumroad license key verified via Gumroad API (zero payment code); v2: Stripe Checkout + webhook minting download tokens (own margin, license enforcement)
- [ ] Regeneration/re-download policy for paid configs (license key → stored config)

---

## Suggested order of attack

**v1:** Phase 1 → 3 → 2 → 4 → 5 → 6 → 7. Firebase auth + services first
(headline feature), then tests while the code is fresh, then
monetization/push, then CI, then the guidance layer, then packaging.
Phases 1–4 are each roughly a focused day or two of work with AI assistance.

**v2:** Phase 8 → 9 after v1 Phases 1–3 are done (guidance layer Phase 5
should also land first, since Phase 8 consumes its manifests). Configurator +
Cloud Run + payments is roughly a week on top of a working generator.

## Out of scope (deliberately)

- Additional backends (Supabase, Appwrite) — good future upsell ("backend adapters"); the module architecture is designed so they slot in later, but not needed for v1/v2 launch
- Second state-management/routing flavor (Bloc, auto_route) — see locked-in opinions; possible paid expansion, never a launch goal
- More example features — one excellent Firestore feature beats five shallow ones
