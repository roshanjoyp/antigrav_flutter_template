# Landing page (static, SEO)

`index.html` is the production marketing page for the CRAFT site. It exists
because Flutter web renders to canvas — crawlers see no text and CanvasKit
hurts Core Web Vitals — so the marketing content must live in crawlable
static HTML (roadmap Phase 9, "SEO split", decided 2026-07-14).

It is a single self-contained file: no external fonts, scripts, stylesheets,
or JavaScript at all. Design derives from
`docs/design/configurator_mockup.html` (the approved v0.4 design study) and
uses the same tokens documented in `docs/design/README.md`.

## Deployment layout

| Path | Serves |
| :--- | :--- |
| `/` | this `index.html` (plus `og-image.png`, favicon) |
| `/configure` | the Flutter web build of `configurator/` (`flutter build web` output) |

Every CTA on the page links to `/configure`; the configurator's own base href
must be set accordingly (`flutter build web --base-href /configure/`).

## Before going live

- Replace every `https://craft.example.com` placeholder in the `<head>`
  (canonical, `og:url`, `og:image`, JSON-LD `url`) with the real domain —
  marked `TODO(deploy)` in the file.
- Add a real 1200×630 `og-image.png` next to `index.html`.
- Add a favicon (the page currently relies on the server default).

## Keeping it honest

The copy states checkable facts: 4 optional modules
(`generator/lib/src/module_registry.dart`), 168 tests / 81% line coverage
(`flutter test`, README feature matrix), 12 verified module combinations
(`dart run craft_generator:verify_matrix --tier full`). If any of those
numbers change, update the metrics row and the "Why this one" /
"In every download" sections here too.

This directory is product-internal: `generator/lib/src/staging.dart` denies
`landing/` so it never ships inside generated project zips.
