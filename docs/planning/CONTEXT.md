# Project Context & Agent Manual

**Last Updated**: 2026-01-17

This document is intended for AI Agents (and humans) to quickly understand the context, architecture, and rules of this project. **Read this before making significant changes.**

## 1. Project Identity
*   **Name**: AntiGrav Flutter Template
*   **Description**: A production-grade, backend-agnostic Flutter application template.
*   **Goal**: To serve as a robust starting point for scalable apps with built-in core services.

## 2. Technical Stack
*   **Framework**: Flutter
*   **State Management**: `flutter_riverpod` (v2+) with `riverpod_annotation`.
*   **Routing**: `go_router`.
*   **Immutability**: `freezed` & `json_serializable`.
*   **Localization**: Standard `flutter_localizations` (ARB files).

## 3. Architecture Rules
We follow a **Clean Architecture** + **Feature-First** approach.

### 3.1 Directory Structure
```text
lib/
├── app/          # Global config (Router, Theme, Main App Widget)
├── core/         # Shared utilities & Services (Log, Crash, etc.)
└── features/     # Feature modules (Auth, Startup, Home...)
    ├── [feature]/
    │   ├── domain/       # Entities & Repository Interfaces (Pure Dart)
    │   ├── data/         # Repository Implementations (API calls)
    │   └── presentation/ # Widgets & Riverpod Controllers
```

### 3.2 Key Patterns
*   **Repository Pattern**: **Strictly Enforced**. Features must define an abstract `IAuthRepository` in `domain/` and implement it in `data/`. UI never talks to Data directly.
*   **Interface Separation**: Core services (`lib/core/services`) are split into:
    *   `xyz_service.dart` (Abstract Interface)
    *   `xyz_service_impl.dart` (Implementation)
    *   **Rule**: Always depend on the Interface. Use the Implementation only for DI in the Provider.
*   **Dependency Injection**: Use Riverpod.
    *   Services are Singletons: `@Riverpod(keepAlive: true)`
    *   Controllers are auto-disposed: `@riverpod`

## 4. Coding Standards
*   **Linting**: Strict rules enabled via `analysis_options.yaml` (custom_lint, riverpod_lint).
*   **Async**: usage of `runZonedGuarded` in `main.dart` is mandatory for global error catching.
*   **Imports**: Absolute imports preferred for project files (`package:antigrav_flutter_template/...`).

## 5. Development Workflow
*   **Code Gen**: Run `dart run build_runner build -d` after editing models/providers.
*   **Localization**: Edit `lib/l10n/app_en.arb` then run `flutter gen-l10n`.

## 6. Service Integration
*   **Log/Crash**: Use `ref.read(logServiceProvider)` or `crashServiceProvider`. Do NOT use `print()`.
*   **Updates**: Use `checkUpdateService` (Custom implementation by user).
