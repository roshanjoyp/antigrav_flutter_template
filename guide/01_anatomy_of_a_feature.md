# Anatomy of a Feature

Every feature in this template has the same three-layer shape. This
guide dissects the **profile** feature — the reference example — file
by file, in the order data flows.

```
lib/features/profile/
├── profile.dart                          # barrel export
├── domain/
│   ├── profile_entity.dart               # what a profile IS
│   └── profile_repository.dart           # what you can DO with profiles
├── data/
│   ├── profile_model.dart                # how a profile is STORED
│   ├── profile_repository_impl.dart      # stub implementation + provider
│   └── firestore_profile_repository_impl.dart
└── presentation/
    ├── profile_controller.dart           # binds repository to UI state
    ├── profile_screen.dart               # renders controller state
    └── widgets/profile_form_widget.dart  # feature-local widget
```

The dependency rule: **presentation → domain ← data**. The domain layer
imports nothing from the other two; the UI never touches the data layer
directly.

## 1. Domain — the contract

**`domain/profile_entity.dart`** defines what a profile *is* to the
app: a freezed class with `uid`, `displayName`, `bio`, `photoUrl`,
`updatedAt`. No JSON, no Firestore imports — persistence details are
banned here (see [Models vs. Entities](03_models_vs_entities.md)).

**`domain/profile_repository.dart`** defines what you can *do*:

```dart
abstract class ProfileRepository {
  Stream<ProfileEntity?> watchProfile(String uid);
  Future<Result<void>> saveProfile(ProfileEntity profile);
}
```

Two things to notice:

- Methods return **`Result<T>`** (`lib/core/utils/result.dart`), never
  throw. Call sites are forced to handle failure explicitly.
- The interface names a **provider** in its doc comment
  (`profileRepositoryProvider`) — that's the only way other layers
  obtain an implementation.

## 2. Data — the implementations

**`data/profile_model.dart`** is the storage-side twin of the entity.
It owns JSON field names, the Firestore `Timestamp` ↔ `DateTime`
conversion, and the mapping (`fromEntity` / `toEntity`). Models never
leave this layer.

**`data/profile_repository_impl.dart`** is the **stub**: an in-memory
map plus a broadcast stream, so the whole watch → edit → save loop works
offline with zero setup. It also declares the provider:

```dart
@riverpod
ProfileRepository profileRepository(Ref ref) => StubProfileRepository();
```

**`data/firestore_profile_repository_impl.dart`** is the real backend.
It is *not* wired by editing code — when `FirebaseConfig.enabled` is
true, `lib/app/config/firebase_overrides.dart` overrides
`profileRepositoryProvider` at startup. Stub and real implementation
coexist; a provider override picks one.

> Template rule: never "complete" a stub in place. Stubs are the default
> binding; real implementations arrive as overrides.

## 3. Presentation — controller, then view

**`presentation/profile_controller.dart`** is the only place with
feature logic:

```dart
@riverpod
class ProfileController extends _$ProfileController {
  @override
  Stream<ProfileEntity?> build() {
    final ProfileRepository repository = ref.watch(profileRepositoryProvider);
    return repository.watchProfile(_currentUid());
  }

  Future<Result<void>> save({required String displayName, required String bio}) { … }
}
```

`build()` returns the repository stream; Riverpod wraps it in
`AsyncValue`, giving the view loading/error/data for free.

**`presentation/profile_screen.dart`** renders those three states with
core widgets (`AppLoading`, `AppError`, the form) and calls
`controller.save(…)` on submit. No business logic, no repository
imports — the view only knows the controller. The binding mechanics are
covered in [Controllers and Views](04_controllers_and_views.md).

## 4. The seams that make it testable

- `test/features/profile/profile_controller_test.dart` overrides
  `profileRepositoryProvider` with a fake — no Firestore, no network.
- The widget tests pump `ProfileScreen` inside a `ProviderScope` with
  the same override and assert on the three `AsyncValue` states.

That is the whole pattern. Every other feature (onboarding, paywall,
setup_status) is a variation on these files.
