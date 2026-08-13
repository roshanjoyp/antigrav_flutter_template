# CRAFT Findings — first real external build

_Started: 2026-08-13 — status: in progress_

CRAFT's first use as a real starting point rather than a self-test. The
build is a lightweight POS + manager app pair on a shared Firestore
backend (see `docs/plugin_promotions_job_posting.md`), generated through
the real `craft_generator` pipeline rather than hand-copied.

Everything that caused friction is recorded here. Policy for this run:
fix upstream only when the fix is small and clearly template-shaped;
otherwise log and defer so the build keeps moving.

---

## Confirmed — found during the build

### 1. `flutter analyze` fails on any macOS checkout — **FIXED**

**Severity: high.** The template repo itself reported **686 issues**, none
of them from template code. All came from
`build/{ios,macos}/SourcePackages/**`.

Flutter's Swift Package Manager integration materialises third-party
plugin *Dart* sources under `build/` during `flutter pub get`.
`analysis_options.yaml` had no `exclude:` section, so the analyzer walked
them and reported lint issues from Firebase's own source.

Why it went unnoticed: CI runs on Linux runners, where no SwiftPM
resolution happens, so `build/` never gets populated and analyze stays
green. Every buyer on a Mac would have hit this on their first
`flutter analyze`.

It also **broke the generator**: `--gate analyze` runs inside staging
after `flutter pub get`, so the first real generation attempt failed with
664 issues and refused to produce a zip.

Fixed by adding to `analysis_options.yaml`:

```yaml
analyzer:
  exclude:
    - build/**
```

**Follow-up worth considering:** the CI workflow should run analyze on a
macOS runner at least once per release, since the Linux-only matrix
structurally cannot catch this class of problem.

### 2. Module-conditional test assertions without markers — **FIXED**

**Severity: high.** The second generation attempt got past analyze and
failed the test gate:

```
Failing tests:
  test/features/startup/startup_view_test.dart:
    StartupView renders identity, status line, and navigation tiles
```

`lib/features/startup/presentation/startup_view.dart:159-176` correctly
wraps the Paywall and Onboarding nav tiles in `// MODULE(revenuecat)` and
`// MODULE(onboarding)` markers. The test asserting those tiles render had
**no markers at all**, so pruning either module removed the tile from the
view but left the assertion in the test. Any selection excluding
revenuecat or onboarding — the majority of the module space, and the
default shape of most real projects — failed to generate.

Introduced by `38f970b` (`feat: implement AppNavTile …`), the
second-most-recent commit.

Fixed by wrapping the two assertions in their modules' markers.

**Why nothing caught it — two independent blind spots:**

1. **The drift guards structurally cannot see it.** The import-boundary
   guard in `generator/test/template_integrity_test.dart` checks that
   imports of module-owned paths from shared files sit inside markers.
   This is a `find.text('Paywall')` string assertion — no import, no
   owned path, nothing for the guard to key on.
2. **The compile matrix never runs these tests.** In
   `generator/bin/verify_matrix.dart:80`, the test gate applies only when
   `tier == 'full' && isExtreme`, where `isExtreme` means all-on or
   all-off. The `quick` tier — the documented pre-commit sweep — is
   **analyze-only for every combo**. So a test that breaks on a partial
   module selection is invisible to the routine check, and the full sweep
   simply had not been re-run since `38f970b`.

**Follow-ups worth considering (not done — beyond this run's policy):**

- Give `quick` a test gate on at least one *partial* combo. Analyze-only
  cannot catch this entire class of bug, and partial selections are what
  buyers actually generate.
- Consider a drift guard asserting that any `find.text('…')` in a shared
  test matching a module-owned label sits inside that module's markers.
  Narrow, but it closes the exact hole found here.

### 3. `@JsonKey` on a freezed factory parameter warns — not fixed upstream yet

**Severity: low, but hits every buyer who writes a second model.**

The template ships freezed + json_serializable together, and the first
model written outside the template's own `ProfileModel` immediately
produced four warnings:

```
warning • The annotation 'JsonKey.new' can only be used on fields or
getters • lib/features/menu/data/menu_item_model.dart:25:6
        • invalid_annotation_target
```

`@JsonKey` is declared `@Target({field, getter})`, but freezed declares
fields *as constructor parameters* — so the documented json_serializable
pattern (defaults, renames, custom converters) warns every time even
though it generates correct code. The template's own `ProfileModel` never
trips it because it only uses `@TimestampConverter()`, which has no such
target restriction.

Worked around in the generated project by adding to
`analysis_options.yaml`:

```yaml
analyzer:
  errors:
    invalid_annotation_target: ignore
```

**Recommendation:** ship this in the template's `analysis_options.yaml`.
One line, standard practice for this dependency pair, and it saves every
buyer the same detour. Not applied upstream yet — batching template edits
so the assignment keeps moving.

### 4. Riverpod 3 dropped `AsyncValue.valueOrNull`

**Severity: informational.** `valueOrNull` — near-universal in Riverpod 2
code and in most published examples and LLM training data — no longer
exists in Riverpod 3:

```
error • The getter 'valueOrNull' isn't defined for the type
        'AsyncValue<List<MenuItemEntity>>'
```

`asData?.value` works across both. Not a template defect: the pin is
correct and current. Worth a line in `guide/` all the same, since buyers
arriving with Riverpod 2 habits (or AI assistants trained on them) will
hit it on their first derived provider.

---

## Predicted — expected before writing any code

Recorded up front from reading the template; confirm or discard as the
build actually reaches them.

| # | Finding | Upstream now? |
| :-- | :--- | :--- |
| 2 | No `firestore.rules` / `firebase.json` shipped. Rules exist only as a snippet in `docs/setup/FIREBASE_SETUP.md:156`, so buyers start with no deployable rules and Firestore's default deny-all. | **Yes** — small, clearly template-shaped |
| 3 | No Firestore emulator wiring. Roadmap Phase 3 explicitly admits the Firestore impl is untested for this reason ("needs fake_cloud_firestore or emulator"). | **Yes if cheap** — unblocks real repository tests |
| 4 | No collection-CRUD repository example. `profile` is single-doc (`profiles/{uid}`) only; nothing demonstrates a live list stream with add/update/delete, which is the far more common shape. | Log — generalise after submission |
| 5 | Breakpoints declared at `app_constants.dart:284-302` (600/840/1024/1280) but with **zero** `LayoutBuilder` or `MediaQuery` usage anywhere in `lib/`. Tokens without a consumer. | Log — a responsive helper widget is a good later addition |
| 6 | No auth sign-in screen despite a complete `AuthRepository` with email/password, Google, Apple, and anonymous. Buyers get the hard part and have to write the easy part. | Log — strong candidate, too big for this run |
| 7 | No multi-app-from-one-codebase story. Flavors cover environments (dev/staging/prod) but two shippable apps from one project needs a second `flavorDimensions` axis, six iOS schemes, and a rename-script that understands two dimensions. | Log — needs design |
