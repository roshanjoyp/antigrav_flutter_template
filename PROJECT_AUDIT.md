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
│   │   └── theme/app_theme.dart
│   ├── core/
│   │   ├── config/
│   │   │   ├── app_env.dart               ✅ added
│   │   │   └── app_flavor.dart            ✅ added
│   │   ├── constants/
│   │   │   ├── app_colors.dart            ✅ added
│   │   │   └── app_constants.dart         ✅ added
│   │   ├── utils/
│   │   │   └── result.dart                ✅ added
│   │   └── services/
│   │       ├── analytics_service/   (interface + impl + README)
│   │       ├── connectivity/        (interface + impl + README)
│   │       ├── crash_service/       (interface + impl + README)
│   │       ├── log_service/         (interface + impl + README)
│   │       ├── permissions/         (interface + impl + README)
│   │       └── update_service/      (interface + impl + README)
│   ├── features/
│   │   ├── auth/
│   │   │   ├── domain/  (auth_repository.dart, user_entity.dart)
│   │   │   └── data/    (auth_repository_impl.dart)
│   │   ├── startup/
│   │   │   └── presentation/  (startup_controller.dart, startup_view.dart)
│   │   └── test_control_panel/
│   │       └── presentation/  (test_screen.dart)
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
- **Router** — GoRouter instance provided via Riverpod
- **Config** — `AppConfigController` manages theme (`ThemeMode`) and locale (`Locale`) app-wide

All providers use `keepAlive: true` for services, and code generation via `riverpod_generator`.

---

## 4. Issues & Code Smells

### Critical

- `auth_repository_impl.dart` — Firebase is fully commented out. `signInWithEmailAndPassword` returns a hardcoded fake user. Auth is non-functional. **Intentional stub — do not fix without instruction (see CLAUDE.md §9).**
- `startup_controller.dart:32-39` — Always navigates to `/` home. Auth state is never checked. **Intentional stub — do not fix without instruction.**

### Major

- `update_service_impl.dart` — `checkForUpdate()` always returns `null`. Completely stubbed out. **Intentional stub — do not fix without instruction.**
- No error handling strategy — services swallow errors via `recordError()` with no propagation to UI. Users see nothing on failures. **Partially addressed: `Result<T>` type added in `lib/core/utils/result.dart`. Repositories must now use it; existing services not yet updated.**
- No session persistence — app loses auth state on restart.

### Moderate

- `test_screen.dart` (173 lines) — monolithic widget with 6 service test sections in one file, multiple private builder methods that should be extracted.
- ~~No environment-based service switching~~ **✅ Fixed — `AppEnv` + `AppFlavor` added in `lib/core/config/`. Flavor initialized in `main.dart` before `runApp`.**
- ~~Mixed import styles — some relative, some package-absolute~~ **✅ Incorrect finding — audited and confirmed all imports were already package-absolute. `part` directives are relative by Dart language requirement and are correct as-is.**
- No barrel/index exports — still outstanding.

### Minor

- `log_service_impl.dart` — Logger config (`PrettyPrinter`, method counts, etc.) is hardcoded; can't vary per environment.
- Only 2 supported locales (`en`, `es`) hardcoded in `app.dart`.
- The `test_control_panel` feature reads providers directly, making isolated testing hard.

---

## 5. Dart File Line Counts

_Original files — line counts reflect state at initial audit._

| File | Lines | Notes |
|---|---|---|
| `lib/main.dart` | 44 → ~58 | Updated: binding order fix, AppFlavor init |
| `lib/app/app.dart` | 36 | |
| `lib/app/config/app_config_controller.dart` | 53 | |
| `lib/app/router/app_router.dart` | 27 | |
| `lib/app/theme/app_theme.dart` | 25 | |
| `lib/core/config/app_env.dart` | — | ✅ New |
| `lib/core/config/app_flavor.dart` | — | ✅ New |
| `lib/core/constants/app_colors.dart` | — | ✅ New |
| `lib/core/constants/app_constants.dart` | — | ✅ New |
| `lib/core/utils/result.dart` | — | ✅ New |
| `lib/core/services/analytics_service/analytics_service.dart` | 5 | |
| `lib/core/services/analytics_service/analytics_service_impl.dart` | 31 | |
| `lib/core/services/connectivity/connectivity_service.dart` | 4 | |
| `lib/core/services/connectivity/connectivity_service_impl.dart` | 24 | |
| `lib/core/services/crash_service/crash_service.dart` | 10 | |
| `lib/core/services/crash_service/crash_service_impl.dart` | 36 | |
| `lib/core/services/log_service/log_service.dart` | 7 | |
| `lib/core/services/log_service/log_service_impl.dart` | 53 | |
| `lib/core/services/permissions/permission_service.dart` | 7 | |
| `lib/core/services/permissions/permission_service_impl.dart` | 28 | |
| `lib/core/services/update_service/update_service.dart` | 17 | |
| `lib/core/services/update_service/update_service_impl.dart` | 22 | |
| `lib/features/auth/domain/auth_repository.dart` | 7 | |
| `lib/features/auth/domain/user_entity.dart` | 16 | |
| `lib/features/auth/data/auth_repository_impl.dart` | 36 | |
| `lib/features/startup/presentation/startup_controller.dart` | 42 | |
| `lib/features/startup/presentation/startup_view.dart` | 59 | |
| `lib/features/test_control_panel/presentation/test_screen.dart` | 173 | |
| `lib/l10n/app_localizations.dart` | 146 | |
| `lib/l10n/app_localizations_en.dart` | 16 | |
| `lib/l10n/app_localizations_es.dart` | 16 | |
