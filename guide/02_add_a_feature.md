# Add a Feature, Step by Step

Building a `notes` feature from nothing, in the order that keeps every
intermediate step compiling. Substitute your own nouns.

## 0. Before writing anything

- Check `lib/core/widgets/` — the widget you're about to write may
  exist.
- Check `lib/core/services/` — cross-cutting concerns (logging,
  analytics, connectivity, storage) are already there.
- New package needed? Stop and clear it with the team first — that's a
  template rule (`CLAUDE.md` §7).

## 1. Scaffold the folders

```
lib/features/notes/
├── domain/
├── data/
└── presentation/widgets/
```

## 2. Domain first: entity + repository contract

`domain/note_entity.dart` — a freezed class, no JSON:

```dart
@freezed
abstract class NoteEntity with _$NoteEntity {
  const factory NoteEntity({
    required String id,
    required String text,
    DateTime? updatedAt,
  }) = _NoteEntity;
}
```

`domain/note_repository.dart` — the contract, `Result` returns:

```dart
abstract class NoteRepository {
  Stream<List<NoteEntity>> watchNotes();
  Future<Result<void>> saveNote(NoteEntity note);
}
```

## 3. Data: stub implementation + provider

`data/note_repository_impl.dart` — in-memory stub, and the provider
that the rest of the app will depend on:

```dart
class StubNoteRepository implements NoteRepository { … }

@riverpod
NoteRepository noteRepository(Ref ref) => StubNoteRepository();
```

Model (`data/note_model.dart`) only when you wire a real backend — the
stub works directly with entities. See
[Models vs. Entities](03_models_vs_entities.md) for when the model
becomes necessary.

## 4. Run codegen

```
dart run build_runner build --delete-conflicting-outputs
```

Do this after every change to `@riverpod` / `@freezed` /
`@JsonSerializable` code. If the analyzer shows "URI hasn't been
generated", this is the fix.

## 5. Presentation: controller, then screen

`presentation/notes_controller.dart`:

```dart
@riverpod
class NotesController extends _$NotesController {
  @override
  Stream<List<NoteEntity>> build() =>
      ref.watch(noteRepositoryProvider).watchNotes();

  Future<Result<void>> save(NoteEntity note) =>
      ref.read(noteRepositoryProvider).saveNote(note);
}
```

`presentation/notes_screen.dart` — a `ConsumerWidget` that renders the
controller's `AsyncValue` using the core widgets (`AppLoading`,
`AppError`, `AppScaffold`, `AppText`). Colors from `AppColors`,
spacing from `AppConstants`, always.

## 6. Route it

Add a `GoRoute` in `lib/app/router/app_router.dart` (dev-only screens
go inside the `if (kDebugMode)` block), then re-run build_runner.

## 7. Barrel + tests

- `lib/features/notes/notes.dart` exporting the public surface.
- `test/features/notes/notes_controller_test.dart` — override
  `noteRepositoryProvider` with a fake, assert states. Copy the shape of
  `test/features/profile/profile_controller_test.dart`; it documents
  the Riverpod 3 pause-when-unlistened gotcha you *will* hit.
- Widget test for the screen's loading/error/data states.

## 8. Verify

```
flutter analyze && dart run custom_lint && flutter test
```

The same three gates CI runs. Done — commit.

## File-naming cheat sheet

`_screen` / `_widget` / `_controller` / `_repository` /
`_repository_impl` / `_model` / `_entity` / `_service` /
`_service_impl` — snake_case, one concept per file, split anything
approaching 200 lines.
