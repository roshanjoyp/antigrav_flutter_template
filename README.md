# AntiGrav Flutter Template

A production-grade, backend-agnostic Flutter application template designed for scalability and robustness.

## 🚀 Features

*   **Clean Architecture**: Separation of concerns into Presentation, Domain, and Data layers.
*   **Feature-First Structure**: Modular code organization by feature.
*   **State Management**: `flutter_riverpod` (v2+) with `riverpod_annotation`.
*   **Navigation**: `go_router` for deep linking and navigation.
*   **Core Services** (Abstracted & Testable):
    *   **LogService**: Unified logging.
    *   **CrashService**: Error reporting (Crashlytics/Sentry ready).
    *   **AnalyticsService**: Event tracking abstraction.
    *   **ConnectivityService**: Offline status monitoring.
    *   **PermissionService**: Simplified permission requests.
    *   **UpdateService**: Custom update checking interface.
*   **Localization**: Built-in `l10n` support (English & Spanish).
*   **Dynamic Configuration**: Runtime toggle for Theme (Light/Dark) and Locale.
*   **Test Control Panel**: A built-in screen to manually verify all services.

## 📚 Documentation

Detailed documentation is available in the project root:

*   **[CONTEXT.md](CONTEXT.md)**: High-level overview for AI Agents & Developers.
*   **[ARCHITECTURE_FLOW.md](ARCHITECTURE_FLOW.md)**: Detailed data flow and architecture explanation.
*   **[SERVICES.md](SERVICES.md)**: Guide to using core services.
*   **[RIVERPOD_GUIDE.md](RIVERPOD_GUIDE.md)**: Migration guide for Provider users.
*   **[PACKAGE_COMPATIBILITY.md](PACKAGE_COMPATIBILITY.md)**: Platform compatibility table.

## 🛠️ Getting Started

### 1. Prerequisites
*   Flutter SDK (v3.x+)
*   Dart (v3.x+)

### 2. Setup
Clone the repository and install dependencies:
```bash
flutter pub get
```

### 3. Code Generation
This project uses `freezed`, `json_serializable`, and `riverpod_generator`. Run the build runner:
```bash
dart run build_runner build -d
```
*Tip: creating a `build.sh` or `Makefile` for this is recommended.*

### 4. Running the App
```bash
flutter run
```

## 🧪 Testing Services (Manual)

The app launches into a **Startup View** where you can choose:
1.  **Go to Home**: The main app entry point.
2.  **Test Services**: A control panel to verify:
    *   Switching Locales (en/es)
    *   Switching Themes (Light/Dark)
    *   Triggering Logs (Info/Warning/Error)
    *   Simulating Crashes (Fatal errors)
    *   Camera Permission requests
    *   Connectivity status

## 🏗️ Architecture Overview

**Directory Structure**:
```text
lib/
├── app/          # Global config (Router, Theme, Main App Widget)
├── core/         # Shared utilities & Services (Interfaces & Impl)
└── features/     # Feature modules (Auth, Startup, Home...)
    ├── [feature]/
    │   ├── domain/       # Entities & Repository Interfaces (Pure Dart)
    │   ├── data/         # Repository Implementations (API calls)
    │   └── presentation/ # Widgets & Riverpod Controllers
```

See **[ARCHITECTURE_FLOW.md](ARCHITECTURE_FLOW.md)** for more details.
