# antigrav_flutter_template

A production-grade, backend-agnostic Flutter application template built for teams that care about structure from day one. It ships with clean architecture (presentation, domain, data layers), Riverpod state management with code generation, a full Material 3 dark theme, design tokens via `AppColors` and `AppConstants`, six core services with interface/implementation separation, a `Result` type for safe error handling, environment and flavor support, barrel exports, and a `CLAUDE.md` optimised for AI-assisted development. Clone it, run the setup script, and start building — no boilerplate wiring required.

## Prerequisites

- Flutter SDK installed
- Dart SDK installed (comes with Flutter)
- Git installed

## Getting Started

### Step 1 — Clone the repository

```bash
git clone <repo-url> your-app-name
cd your-app-name
```

### Step 2 — Rename the root folder

The cloned folder should already be named your app name from Step 1. If not, rename it manually now.

### Step 3 — Run the setup script

```bash
dart setup/setup.dart
```

Follow the prompts to enter:

- App display name (e.g. Just Tap)
- Package name (e.g. com.antigrav.justtap)

Package name rules:

- All lowercase
- At least 3 segments separated by dots
- Only letters, numbers, underscores
- Example: `com.yourcompany.appname`

### Step 4 — Install dependencies

```bash
flutter clean && flutter pub get
```

### Step 5 — Run the app

```bash
flutter run
```

## Optional — Push to your own repository

### Create a new repo on GitHub/GitLab/Bitbucket

Do not initialize it with a README or `.gitignore` — keep it empty.

### Point your local repo to the new remote

```bash
git remote remove origin
git remote add origin <your-new-repo-url>
git branch -M main
git push -u origin main
```

### Verify

```bash
git remote -v
```

Should show your new repo URL for both fetch and push.

## What the setup script changes

The script updates every location where the app name and package name appear:

- **Android files** — `AndroidManifest.xml`, `build.gradle`, `MainActivity.kt`, package directory structure
- **iOS files** — `Info.plist`, `AppDelegate.swift`, `project.pbxproj`, bundle identifier references
- **Dart/Flutter files** — `pubspec.yaml`, `app.dart`, import paths that include the package name
- **Documentation files** — `README.md`, `CLAUDE.md`, and any other docs that reference the template name

## Template features

- Clean architecture + Riverpod (with code generation)
- `AppColors` and `AppConstants` design tokens
- Dark theme with full Material 3 support
- 6 core reusable widgets
- 6 core services with interfaces (`LogService`, `CrashService`, `AnalyticsService`, `ConnectivityService`, `PermissionService`, `UpdateService`)
- `Result` type for error handling
- Environment and flavor support
- Barrel exports
- `CLAUDE.md` for AI-assisted development

## After Setup

- Replace stub service implementations with real ones as needed — stubs exist to show structure, not to be shipped as-is
- Read `CLAUDE.md` before starting development — it contains standing rules for code organisation, architecture, and tooling
- Read `docs/architecture/ARCHITECTURE_FLOW.md` for a full overview of data flow and layer responsibilities
- Browse [`docs/`](docs/README.md) for the full documentation set (architecture, setup guides, planning)
