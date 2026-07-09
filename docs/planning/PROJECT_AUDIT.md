# Project Audit — antigrav_flutter_template
_Generated: 2026-04-16 — last updated: 2026-04-16_

---

## 1. Folder Structure

```
antigrav_flutter_template/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── config/app_config_controller.dart
│   │   ├── router/app_router.dart
│   │   └── theme/
│   │       ├── app_theme.dart              ✅ rebuilt
│   │       ├── app_theme_components.dart   ✅ added
│   │       └── app_theme_extensions.dart   ✅ added
│   ├── core/
│   │   ├── core.dart                       ✅ added (barrel)
│   │   ├── config/
│   │   │   ├── app_env.dart               ✅ added
│   │   │   └── app_flavor.dart            ✅ added
│   │   ├── constants/
│   │   │   ├── app_colors.dart            ✅ added
│   │   │   └── app_constants.dart         ✅ added
│   │   ├── utils/
│   │   │   └── result.dart                ✅ added
│   │   ├── widgets/
│   │   │   ├── widgets.dart               ✅ added (barrel)
│   │   │   ├── app_scaffold.dart          ✅ added
│   │   │   ├── app_button.dart            ✅ added
│   │   │   ├── app_text.dart              ✅ added
│   │   │   ├── app_loading.dart           ✅ added
│   │   │   ├── app_error.dart             ✅ added
│   │   │   └── app_divider.dart           ✅ added
│   │   └── services/
│   │       ├── analytics_service/   (interface + impl + README)
│   │       ├── connectivity/        (interface + impl + README)
│   │       ├── crash_service/       (interface + impl + README)
│   │       ├── log_service/         (interface + impl + README)
│   │       ├── permissions/         (interface + impl + README)
│   │       └── update_service/      (interface + impl + README)
│   ├── features/
│   │   ├── auth/
│   │   │   ├── auth.dart                  ✅ added (barrel)
│   │   │   ├── domain/  (auth_repository.dart, user_entity.dart)
│   │   │   └── data/    (auth_repository_impl.dart)
│   │   ├── startup/
│   │   │   ├── startup.dart               ✅ added (barrel)
│   │   │   └── presentation/  (startup_controller.dart, startup_view.dart)
│   │   └── test_control_panel/
│   │       ├── test_control_panel.dart    ✅ added (barrel)
│   │       └── presentation/
│   │           ├── test_screen.dart
│   │           └── widgets/
│   │               ├── analytics_test_widget.dart
│   │               ├── connectivity_test_widget.dart
│   │               ├── crash_test_widget.dart
│   │               ├── log_test_widget.dart
│   │               ├── permissions_test_widget.dart
│   │               └── update_test_widget.dart
│   └── l10n/
│       ├── app_en.arb / app_es.arb
│       └── app_localizations*.dart
├── pubspec.yaml
├── CLAUDE.md                              ✅ added
├── PROJECT_AUDIT.md                       ✅ added
├── ARCHITECTURE_FLOW.md
├── CONTEXT.md
├── RIVERPOD_GUIDE.md
├── SERVICES.md
├── PACKAGE_COMPATIBILITY.md
└── android/ ios/ macos/ windows/ linux/ web/
```

---

## 2. Packages (pubspec.yaml)

### Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^3.1.0 | State management |
| `riverpod_annotation` | ^4.0.0 | Code gen annotations |
| `go_router` | ^17.0.1 | Navigation/routing |
| `freezed_annotation` | ^3.1.0 | Immutable models |
| `json_annotation` | ^4.9.0 | JSON serialization |
| `flutter_secure_storage` | ^10.0.0 | Secure local storage |
| `intl` | ^0.20.2 | Internationalization |
| `flutter_localizations` | sdk | i18n support |
| `logger` | ^2.6.2 | Logging |
| `internet_connection_checker_plus` | ^2.9.1+2 | Connectivity check |
| `connectivity_plus` | ^7.0.0 | Connectivity events |
| `permission_handler` | ^12.0.1 | Device permissions |
| `flutter_dotenv` | ^6.0.0 | `.env` config |
| `cupertino_icons` | ^1.0.8 | iOS icons |

### Dev Dependencies

| Package | Purpose |
|---|---|
| `build_runner` | Code generation runner |
| `riverpod_generator` | Generates provider boilerplate |
| `riverpod_lint` | Riverpod lint rules |
| `custom_lint` | Lint framework |
| `freezed` | Generates immutable model code |
| `json_serializable` | Generates JSON serialization |
| `flutter_lints` | Flutter lint rules |

---

## 3. Architecture Pattern

**Clean Architecture + Riverpod + Feature-First structure.**

- **Domain layer** — abstract repositories + `freezed` entities
- **Data layer** — repository implementations
- **Presentation layer** — views + Riverpod controllers (`@riverpod` annotation)
- **Core/Services** — 6 singleton services, each with an abstract interface and a concrete implementation
- **Core/Widgets** — 6 foundational reusable widgets enforcing `AppColors` and `AppConstants`
- **Core/Constants** — `AppColors` and `AppConstants` as single source of truth for all design tokens
- **Core/Config** — `AppEnv` + `AppFlavor` for environment-aware behavior
- **Core/Utils** — `Result<T>` + `AppException` for structured error handling
- **Router** — GoRouter instance provided via Riverpod
- **Theme** — Full dark `ThemeData` built from `AppColors`/`AppConstants` across 3 files

All providers use `keepAlive: true` for services, and code generation via `riverpod_generator`.

---

## 4. Issues & Code Smells

### Critical

- `auth_repository_impl.dart` — Firebase is fully commented out. `signInWithEmailAndPassword` returns a hardcoded fake user. Auth is non-functional. **Intentional stub — do not fix without instruction (see CLAUDE.md §9).**
- `startup_controller.dart` — Always navigates to `/` home. Auth state is never checked. **Intentional stub — do not fix without instruction.**

### Major

- `update_service_impl.dart` — `checkForUpdate()` always returns `null`. Completely stubbed out. **Intentional stub — do not fix without instruction.**
- ~~No error handling strategy~~ **✅ Fixed — `Result<T>` + `AppException` in `lib/core/utils/result.dart`. All 6 service implementations now wrap operations in try/catch and throw `AppException` on failure. `LogService` and `CrashService` are never-throw by contract.**
- No session persistence — app loses auth state on restart. **Intentional stub — do not fix without instruction.**

### Moderate

- ~~`test_screen.dart` (173 lines) — monolithic widget~~ **✅ Fixed — split into 6 per-service widgets in `presentation/widgets/`. `test_screen.dart` is now 64 lines.**
- ~~No environment-based service switching~~ **✅ Fixed — `AppEnv` + `AppFlavor` added. Logger config is now environment-aware.**
- ~~Mixed import styles~~ **✅ Incorrect original finding — all imports were already package-absolute.**
- ~~No barrel/index exports~~ **✅ Fixed — barrel files added for all features and core.**

### Minor

- ~~`log_service_impl.dart` — Logger config hardcoded~~ **✅ Fixed — environment-aware via `AppFlavor`.**
- Only 2 supported locales (`en`, `es`) hardcoded in `app.dart`. Still outstanding.
- ~~`test_control_panel` reads providers directly~~ — acceptable pattern for Riverpod `ConsumerWidget`; not an issue.

### Known Acceptable Exceptions

- `app_constants.dart` (~291 lines) and `app_text.dart` (~234 lines) exceed the 200-line rule. These are pure definition files where splitting would require renaming all public identifiers. Documented exception in `CLAUDE.md §1`.
- `auth_repository_impl.dart` — `Duration(seconds: 1)` stub delay uses a magic number. Intentionally not fixed per CLAUDE.md §9 (stub file).

---

## 5. Dart File Line Counts

_Current as of last audit pass._

| File | Lines |
|---|---|
| `lib/main.dart` | ~68 |
| `lib/app/app.dart` | 36 |
| `lib/app/config/app_config_controller.dart` | 53 |
| `lib/app/router/app_router.dart` | 27 |
| `lib/app/theme/app_theme.dart` | 95 |
| `lib/app/theme/app_theme_components.dart` | 169 |
| `lib/app/theme/app_theme_extensions.dart` | 108 |
| `lib/core/core.dart` | 24 |
| `lib/core/config/app_env.dart` | 62 |
| `lib/core/config/app_flavor.dart` | 116 |
| `lib/core/constants/app_colors.dart` | 139 |
| `lib/core/constants/app_constants.dart` | ~291 ⚠️ exempt |
| `lib/core/utils/result.dart` | 160 |
| `lib/core/widgets/widgets.dart` | 12 |
| `lib/core/widgets/app_scaffold.dart` | 72 |
| `lib/core/widgets/app_button.dart` | 112 |
| `lib/core/widgets/app_text.dart` | ~234 ⚠️ exempt |
| `lib/core/widgets/app_loading.dart` | 50 |
| `lib/core/widgets/app_error.dart` | 74 |
| `lib/core/widgets/app_divider.dart` | 42 |
| `lib/core/services/analytics_service/analytics_service.dart` | 25 |
| `lib/core/services/analytics_service/analytics_service_impl.dart` | 82 |
| `lib/core/services/connectivity/connectivity_service.dart` | 18 |
| `lib/core/services/connectivity/connectivity_service_impl.dart` | 74 |
| `lib/core/services/crash_service/crash_service.dart` | 38 |
| `lib/core/services/crash_service/crash_service_impl.dart` | 77 |
| `lib/core/services/log_service/log_service.dart` | 36 |
| `lib/core/services/log_service/log_service_impl.dart` | 145 |
| `lib/core/services/permissions/permission_service.dart` | 28 |
| `lib/core/services/permissions/permission_service_impl.dart` | 85 |
| `lib/core/services/update_service/update_service.dart` | 35 |
| `lib/core/services/update_service/update_service_impl.dart` | 55 |
| `lib/features/auth/auth.dart` | 12 |
| `lib/features/auth/domain/auth_repository.dart` | 29 |
| `lib/features/auth/domain/user_entity.dart` | 16 |
| `lib/features/auth/data/auth_repository_impl.dart` | 36 |
| `lib/features/startup/startup.dart` | 9 |
| `lib/features/startup/presentation/startup_controller.dart` | 43 |
| `lib/features/startup/presentation/startup_view.dart` | 69 |
| `lib/features/test_control_panel/test_control_panel.dart` | 17 |
| `lib/features/test_control_panel/presentation/test_screen.dart` | 64 |
| `lib/features/test_control_panel/presentation/widgets/analytics_test_widget.dart` | 40 |
| `lib/features/test_control_panel/presentation/widgets/connectivity_test_widget.dart` | 35 |
| `lib/features/test_control_panel/presentation/widgets/crash_test_widget.dart` | 35 |
| `lib/features/test_control_panel/presentation/widgets/log_test_widget.dart` | 42 |
| `lib/features/test_control_panel/presentation/widgets/permissions_test_widget.dart` | 30 |
| `lib/features/test_control_panel/presentation/widgets/update_test_widget.dart` | 28 |
