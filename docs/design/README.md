# Configurator design reference

`configurator_mockup.html` is the approved UI mockup for the v2 web
configurator (roadmap Phase 9). It is a self-contained interactive HTML page —
open it directly in a browser. It exists as the design source of truth for the
future Flutter web build; it is **not** shipped anywhere.

Live copy (same file, hosted): https://claude.ai/code/artifact/ec5c772c-3378-4191-8723-029455544406

## Design direction

Monochrome studio-portfolio aesthetic (references live in
`docs/design/screenshots/`, gitignored — third-party images, do not
commit). Sharp corners everywhere, no
border-radius. Dark-first, single-theme by design, with one light band section
as the counterpoint. Hierarchy comes from typography, not color or chrome.

## Tokens → Flutter theme

| Token        | Value      | Role                                   |
| ------------ | ---------- | -------------------------------------- |
| `bg`         | `#17181c`  | page / scaffold background             |
| `panel`      | `#1d1f25`  | floating card surface                  |
| `panel-deep` | `#14151a`  | inset pane inside the card             |
| `fg`         | `#f2f2ef`  | primary text; also fills (buttons, checked states) |
| `muted`      | `#8d8f96`  | secondary text                         |
| `line`       | `#2b2d34`  | hairline borders (1px everywhere)      |
| `band-bg`    | `#f4f4f1`  | light band background                  |
| `band-fg`    | `#17181c`  | text on light band                     |
| `band-muted` | `#6d6f6a`  | secondary text on light band           |
| `band-line`  | `#dddcd5`  | hairlines on light band                |

No accent color. State = contrast + opacity.

## Type system

Three voices (mockup uses system stacks; pick bundled fonts for Flutter):

1. **Display** — geometric sans (mockup: Futura). ALL-CAPS with wide tracking:
   hero wordmark ~0.28em, section titles 0.3em, micro-labels 0.32–0.42em.
   When centering tracked caps, add leading padding equal to the tracking to
   rebalance. Flutter candidates: Jost, Questrial (Futura-like, OFL).
2. **Body** — neutral sans (mockup: Helvetica Neue), 16px base, muted color
   for secondary copy.
3. **Mono** — code, file trees, dep chips, section numbers (`.01`), package
   preview. Flutter candidate: JetBrains Mono / IBM Plex Mono.

## Layout & components

- Max content width 1120px; section padding clamp(110–190px). Breathable
  pass (2026-07-14, v0.4): whitespace is part of the identity — generous
  vertical rhythm everywhere, hierarchy through space before size. Key
  values: config grid gap clamp(48–88px), module rows 28px vertical
  padding, preview card 30px inner padding, body line-height 1.7
  (secondary copy 1.75–1.8), nav height 80px.
- Section heads centered: mono number (`.01`) → spaced-caps title → muted lede.
- Metrics: 4-cell hairline-divided row, tabular numerals, tiny caps labels.
- Module list: hairline rows, whole row tappable. **Unchecked rows sit at 38%
  opacity** (focus through de-emphasis); hover/press restores to 100%.
- Checkbox/radio: sharp squares; checked = fg fill with 3px bg inset ring.
- Text fields: underline-only (no filled boxes).
- Preview panel: sticky floating card, `panel` surface, 1px `line` border,
  large soft shadow (0 40px 80px, 50% black). Tabs = tiny caps, active gets
  fg underline. Panes on `panel-deep`.
- Buttons: sharp rectangles, tiny spaced-caps label; primary = fg fill that
  inverts to outline on hover; ghost = outline that fills on hover.
- Setup-step tags: `doctor` = solid fg/inverted text; `guided` = 1px outline.
- Hover on grids recedes siblings to ~40% opacity (pointer devices only).

## Interaction model (must survive the Flutter port)

The right-hand preview re-renders live from the module selection:
file tree (+ marked additions), deduped pubspec dependency list, and setup
steps tagged `doctor` (machine-verified) vs `guided` (console work + confirm).
App name + org derive the package name and zip name as you type. This preview
is the product's core demo moment — keep it first-class.

The identity block also carries a full-width **description** field (added
2026-07-14): the generator's config schema requires a 10–180 char pubspec
description, so the form must collect it. Module ids in the built app come
from `generator/lib/src/module_registry.dart` (firebase, revenuecat, push,
onboarding), not the aspirational seven in this mockup; the mockup's theme
preset row is likewise not in the app until the generator supports presets.

The Flutter implementation lives at `configurator/` (Phase 9); a drift-guard
test there keeps its catalogue in lock-step with the generator registry.
