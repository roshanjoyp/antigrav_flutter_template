# CLAUDE.md — Standing Instructions

These rules apply to every task in this project without exception.

---

## 1. Code Organisation

- No file should exceed 200 lines. If it grows beyond that, split it logically.
  **Exception:** Pure constant definition files (`app_constants.dart`, `app_colors.dart`) and pure typography definition files (`app_text.dart`) may exceed 200 lines when splitting would require renaming all public identifiers or using `part` files. Document the reason inline if a constant file exceeds 200 lines.
- Colors must always come from `app_colors.dart`. Never hardcode a color anywhere.
- Spacing, dimensions, and durations must always come from `app_constants.dart`. Never hardcode numbers.
- Every reusable widget goes in `lib/core/widgets/`. If a widget is used more than once, extract it immediately.

---

## 2. Architecture

- Strictly follow clean architecture: presentation, domain, data layers per feature.
- No business logic inside widget or view files.
- No direct database or API calls from the UI layer. Always go through a repository.
- Services in `lib/core/services/` are the only place for cross-cutting concerns like logging, analytics, and crash reporting.

---

## 3. Error Handling

- Never swallow errors silently.
- Always use the `Result` type from `lib/core/utils/result.dart` for repository methods.
- Services should log errors via `LogService` before propagating them.

---

## 4. Imports

- Always use package-absolute imports. Never use relative imports.
- Correct: `import 'package:antigrav_flutter_template/core/...'`
- Wrong: `import '../../core/...'`

---

## 5. File Naming

- `snake_case` for all files, always.
- Suffix files correctly:
  - `_screen.dart` — full screens
  - `_widget.dart` — reusable widgets
  - `_controller.dart` — Riverpod controllers
  - `_repository.dart` — repository interfaces
  - `_repository_impl.dart` — repository implementations
  - `_model.dart` — data models
  - `_entity.dart` — domain entities
  - `_service.dart` — service interfaces
  - `_service_impl.dart` — service implementations

---

## 6. Documentation

- Every class must have a dartdoc comment explaining its purpose and responsibility.
- Every public method must have a dartdoc comment.
- Every property in `app_colors.dart` and `app_constants.dart` must have a dartdoc comment.

---

## 7. Before Every Task

- Check if a widget already exists in `lib/core/widgets/` before creating a new one.
- Check if a color already exists in `app_colors.dart` before adding a new one.
- Check if a constant already exists in `app_constants.dart` before adding a new one.
- Check if a service already exists in `lib/core/services/` before creating a new one.
- Never add a new package to `pubspec.yaml` without explicitly telling the developer first and waiting for approval.

---

## 8. State Management

- Use Riverpod with code generation (`@riverpod`) exclusively.
- No `setState` anywhere except inside truly isolated local widgets with no business logic.
- Keep providers in the same file as their controller unless the file exceeds 200 lines.

---

## 9. Template Awareness

- This is a template project. Many features are intentionally stubbed with fake implementations.
- Never replace a stub implementation with a real one unless explicitly instructed by the developer.
- Stubs exist to show structure, not to be completed automatically.

---

## 10. Git Hygiene (reminders only)

- Remind the developer to commit after every completed task.
- Never suggest force pushing.

---

## 11. setup.sh Awareness

- This project uses a `setup.sh` (Node.js based) configurator that scaffolds features based on developer choices.
- Never manually wire or remove features that `setup.sh` is responsible for.
- If a file is marked with the comment `// SETUP_MANAGED` at the top, do not modify its structure without developer instruction.

---

## 12. Dart & Flutter Specifics

- Always run `build_runner` after modifying any file that uses `@riverpod`, `@freezed`, or `@JsonSerializable` annotations.
- Never commit generated files (`*.g.dart`, `*.freezed.dart`) — these are in `.gitignore`.
- Always use `const` constructors wherever possible.
- Always specify explicit types. Never rely on `dynamic` or `var` unless absolutely necessary.
