---
name: verify
description: Build, serve, and drive the CRAFT configurator web app headlessly to verify changes end-to-end.
---

# Verify the configurator

Build and serve (from `configurator/`):

```bash
flutter build web --release
(cd build/web && python3 -m http.server 8642 &)
```

Drive it headlessly — no Chrome extension needed. Start Chrome with CDP,
then script it over the DevTools WebSocket (Node ≥22 has native WebSocket):

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless=new --remote-debugging-port=9223 --window-size=1440,900 \
  --user-data-dir=$(mktemp -d) about:blank &
```

CDP recipe (see the pattern in any prior session's scratchpad `drive.mjs`):
fetch `http://127.0.0.1:9223/json` → open `webSocketDebuggerUrl` →
`Page.navigate` to `http://127.0.0.1:8642/` → **wait ~6s** (CanvasKit boot;
screenshots before that are blank) → `Page.captureScreenshot`,
`Input.dispatchMouseEvent` (wheel deltas scroll the Flutter view 1:1;
clicks toggle module rows), `Browser.setDownloadBehavior` to capture the
config.json download.

Flows worth driving:

- Scroll tour: hero → metrics → configure → band → inside → CTA (wheel
  900px steps line up with section rhythm at 1440×900).
- At scroll ≈1500: click a module row (~x400) to toggle; the preview file
  tree and summary must re-render. Firebase off must drop push.
- Click Download (in the preview foot) → config.json lands in the
  download dir; feed it to the generator for the full loop:
  `cd ../generator && dart run craft_generator:generate --config <json> \
   --out /tmp/app.zip --gate analyze` — then check the zip is non-empty
  and contains no `configurator/` or `generator/` entries.

Gotchas:

- Text is Canvas-rendered: DOM tools are useless; verify by screenshot.
- `flutter test` in `configurator/` covers derivations + a registry
  drift guard (`../generator` path-relative) — but tests are not
  verification; drive the browser.
