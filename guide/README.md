# CRAFT Template Guide

Walkthroughs for working *in* this template — how the pieces bind
together, and how to extend them without fighting the architecture.

Read in order the first time; after that, each stands alone.

| # | Guide | Answers |
|---|-------|---------|
| 1 | [Anatomy of a Feature](01_anatomy_of_a_feature.md) | "How is a feature actually wired, file by file?" |
| 2 | [Add a Feature, Step by Step](02_add_a_feature.md) | "Where do I start when I build my own?" |
| 3 | [Models vs. Entities](03_models_vs_entities.md) | "Why two classes for the same data, and when do I need both?" |
| 4 | [Controllers and Views](04_controllers_and_views.md) | "How does state reach the screen, and where does logic live?" |

## Reference docs

The guides walk through *one* concrete path each; the reference docs
cover the full surface:

- [`docs/architecture/ARCHITECTURE_FLOW.md`](../docs/architecture/ARCHITECTURE_FLOW.md) — the layer rules and data flow
- [`docs/architecture/RIVERPOD_GUIDE.md`](../docs/architecture/RIVERPOD_GUIDE.md) — providers, codegen, overrides
- [`docs/architecture/SERVICES.md`](../docs/architecture/SERVICES.md) — every core service and its stub/real pairing
- [`docs/setup/`](../docs/setup/) — per-module setup (Firebase, RevenueCat, push)

## Verifying your setup

- `dart run tool/doctor.dart` — static setup checks + production-readiness report
- Debug build → **Setup Status** screen (`/setup-status`, linked from the test panel) — runtime checks
- [`checklist.yaml`](../checklist.yaml) — git-tracked production-readiness state
