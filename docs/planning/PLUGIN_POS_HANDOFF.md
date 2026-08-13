# Plugin POS build — handoff

_Paused: 2026-08-13. Resume from “Next session” below._

CRAFT's first real external build, doubling as a job-application build task
for Plug-In Promotions (posting: `docs/plugin_promotions_job_posting.md`).
Findings live in `CRAFT_FINDINGS.md`; this file is the state of the build
itself.

**Project location:** `/Users/roshanjoy/Projects/claude/plugin_pos`
(sibling of this repo, own git repo, HEAD = `6d4d368`).

---

## Where it stands

Done and green — `flutter analyze`, `dart run custom_lint`, and 188 tests
all clean; both entry points compile for web.

| Step | State |
| :--- | :--- |
| 1. Generate from CRAFT (firebase module only) | ✅ |
| 3. Shared `menu` + `order` domain/data/controllers | ✅ |
| 4. Two entry points, per-surface routers | ✅ |
| 5. POS presentation (tablet/web) | ✅ |
| 6. Manager presentation (phone) | ✅ |
| 7. `firestore.rules` + `firebase.json` + session bootstrap | ✅ written, **not yet verified against a real project** |
| 8. Tests (46 new) | ✅ |
| 9. README | ✅ |
| 2. Firebase project + `flutterfire configure` | ⏳ **needs console access** |
| 9b. 2–3 min screen recording | ⏳ blocked on step 2 |

Everything runs today on `StubMenuRepository`, and live propagation is real
in stub mode — it is the same stream — so both apps are demonstrable
without a backend.

## Next session

1. **Firebase setup** (manual): create project → Firestore → enable
   **Anonymous** auth → `flutterfire configure` in the project directory.
2. Set `FirebaseConfig.enabled = true` in
   `lib/core/config/firebase/firebase_config.dart`.
3. `firebase deploy --only firestore:rules`.
4. Launch the manager app, open the **Manager access** dialog (badge icon
   in the app bar), copy the uid, create `managers/<uid>` in Firestore.
5. **Verify end to end:** POS in Chrome + manager on a phone against the
   same project. Toggle sold out → POS greys it within a second. Edit a
   price → POS reflects it. Add/delete → both update live.
6. **Verify the rules bite:** a write from the POS's anonymous uid is
   rejected; the manager's succeeds only once seeded.
7. Record 2–3 min showing both apps together.
8. Upload repo + recording to Google Drive; send the application email.

## Open decisions carried forward

- **Submit now vs. ask first.** The listing showed as “no longer accepting
  applications.” Recommendation given: send the complete submission anyway
  with a line acknowledging that, rather than asking permission first — the
  posting states applications without a build task are not reviewed, so a
  complete package is the stronger opener. The earlier “is it still open?”
  email draft is obsolete; it asked to do work that is now done.
- **README “Tooling” section needs Roshan's eye** before sending. It makes
  specific claims about how the AI tooling was used, including which
  suggestions were rejected and why. Strongest part of the submission for
  an “AI native” team, but it has to match how he would describe it.

## Template work deferred (not done, deliberately)

Beyond the two fixes already committed in `f536d53`:

- Port `session_bootstrap.dart` (anonymous sign-in before first read) back
  into CRAFT — without it, any buyer deploying non-trivial rules has every
  read fail.
- Ship `firestore.rules` + `firebase.json` in the template (finding #2/#6).
- Generate a project README instead of shipping CRAFT's own (finding #5).
- Add `invalid_annotation_target: ignore` to the template's
  `analysis_options.yaml` (finding #3).
- Give `verify_matrix`'s `quick` tier a test gate on a *partial* combo;
  analyze-only cannot catch the class of bug in finding #2.

## Scope boundary to keep holding

This POC stays tailored to the assignment. The larger product idea — a
one-stop restaurant OS for the Kerala market, wedge = re-ordering from your
table in self-service restaurants — is explicitly **out of scope here**;
the real product starts fresh afterwards, informed by what this build
taught. No venue scoping, no order channel, no per-channel pricing in this
codebase.
