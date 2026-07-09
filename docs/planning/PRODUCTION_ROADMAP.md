# Production Roadmap — antigrav_flutter_template

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
- [ ] **Firestore example feature**: one small end-to-end feature (e.g. user profile) showing the full clean-architecture flow — Firestore data source → repository → Riverpod controller → view. This is the "how do I actually use this" sample buyers look for first
- [ ] Wire service selection through flavors/env so stub vs. Firebase impls are swappable via a single provider override
- [ ] Update `docs/architecture/SERVICES.md` and `docs/architecture/ARCHITECTURE_FLOW.md` to cover the Firebase layer

## Phase 2 — Monetization + push (what buyers pay for)

- [ ] **Paywall module**: RevenueCat (`purchases_flutter`) integration — subscription entitlement provider, paywall screen using existing core widgets, restore purchases, sandbox testing docs
- [ ] **Push notifications**: FCM integration — token handling, foreground/background handlers, permission flow through the existing `PermissionService`, notification tap → deep link via go_router
- [ ] **Onboarding flow**: 2–3 screen onboarding with "seen" state persisted (secure storage or shared prefs), wired into the startup/router redirect logic

## Phase 3 — Tests (currently zero — no `test/` directory)

- [ ] Unit tests: `Result` type, controllers, repository impls (with mocked data sources)
- [ ] Widget tests: all six core widgets, startup view, auth screens
- [ ] Riverpod tests: provider overrides pattern documented as the example for buyers to follow
- [ ] Golden tests for the theme (light + dark) — optional but a strong differentiator
- [ ] Target: enough coverage that "tested" is an honest listing bullet (~70%+ on lib/, excluding generated files)

## Phase 4 — CI/CD

- [ ] GitHub Actions workflow: `flutter analyze` + `dart format --set-exit-if-changed` + `flutter test` on PR/push
- [ ] Build jobs: Android APK/AAB and iOS (no signing) to prove the template compiles on CI
- [ ] Optional: `build_runner` check to catch stale generated files

## Phase 5 — Buyer guidance layer (guide + doctor + setup screen)

Valuable in the plain v1 zip on day one, and the per-module manifests it
produces are exactly what the v2 generator consumes later.

- [ ] **`guide/`**: restructure the `docs/architecture/` material (ARCHITECTURE_FLOW, RIVERPOD_GUIDE, SERVICES) into buyer-facing walkthroughs — "anatomy of a feature" (trace one real feature layer by layer), "add a new feature step-by-step", "model vs. entity: when and where", "how a controller binds to a view". Markdown first; pretty rendered version is later polish
- [ ] **Setup-steps manifest**: per module, a declared list of setup steps, each with a check implementation (static or runtime) or `manual` flag. Single source of truth for doctor CLI, in-app screen, and (later) generator
- [ ] **`tool/doctor.dart`**: doctor CLI running the static checks — config files present and non-placeholder, bundle IDs consistent post-rename, `pub get` resolves, generated files fresh. `x/y` summary + per-failure remediation text (same mechanics/style as `setup/setup.dart`)
- [ ] **Setup Status screen**: dev-only runtime checks (Firebase init, auth ping, FCM token) as an extension of `test_control_panel`; excluded from release builds

## Phase 6 — Polish for listing

- [ ] `pubspec.yaml`: replace default `description: "A new Flutter project."` and strip the boilerplate Flutter comments
- [ ] Sweep remaining default-project artifacts (launcher icons, default bundle display names on desktop targets)
- [ ] Add `flutter_launcher_icons` + `flutter_native_splash` configs so buyers rebrand assets in one command (extend `setup/setup.dart` to prompt for them)
- [ ] README rewrite for the *buyer* audience: feature matrix, screenshots/GIFs, quick-start, FAQ
- [ ] CHANGELOG.md + semantic versioning — marketplaces reward maintained products
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

- [ ] Restructure repo into a monorepo: `template/` (or bricks), `generator/`, later `configurator/` + `backend/`
- [ ] Mason bricks per module (backend impls, paywall, push, onboarding, i18n, guide chapters, doctor checks), template variables for name/package/branding — mason chosen over marker-stripping (markers get unmaintainable past ~5 toggles); this also yields the CLI generator as a free byproduct
- [ ] Module manifest: files + pubspec entries + setup steps (from Phase 5) per brick
- [ ] Generator pipeline: config JSON → compose bricks → rewrite pubspec → rename (reuse `setup.dart` logic) → `flutter analyze` sanity gate → zip
- [ ] CI matrix: generate each module toggle (and key combinations), verify each output compiles and passes tests — without this, broken permutations *will* ship

## Phase 9 — Configurator app + payments + delivery

- [ ] Flutter web configurator (dogfooding: "this site was built with the template" is marketing) — a form producing config JSON
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
