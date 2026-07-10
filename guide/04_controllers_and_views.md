# Controllers and Views

How state reaches the screen, using
`profile_controller.dart` / `profile_screen.dart` as the working
example. The template's rule: **all logic in the controller, all
rendering in the view** — a view never imports a repository.

## The controller: `build()` is the binding

```dart
@riverpod
class ProfileController extends _$ProfileController {
  @override
  Stream<ProfileEntity?> build() {
    final ProfileRepository repository = ref.watch(profileRepositoryProvider);
    return repository.watchProfile(_currentUid());
  }
}
```

- `build()` *is* the subscription. Return a `Stream` (or `Future`, or
  plain value) and Riverpod wraps it in `AsyncValue`: loading → data →
  error, plus re-emission on every stream event.
- `ref.watch` inside `build()` means: if the repository binding changes
  (say, the Firebase override replaces the stub), the controller
  rebuilds and re-subscribes automatically.
- Actions are plain methods (`save(…)`) using `ref.read` — read, don't
  watch, inside event handlers. They return `Result` so the view can
  show success/failure feedback without knowing why it failed.
- After a successful save, **nothing is manually refreshed**: the
  watched stream emits the new profile, the state updates itself. If
  you're calling `state = …` after a mutation of stream-backed state,
  the data flow is inside out.

## The view: render `AsyncValue`, nothing else

```dart
final AsyncValue<ProfileEntity?> profile = ref.watch(profileControllerProvider);

return profile.when(
  skipLoadingOnReload: true,
  loading: () => const AppLoading(message: 'Loading profile...'),
  error: (Object error, StackTrace stackTrace) => AppError(
    message: error is AppException ? error.message : 'Failed to load profile.',
    onRetry: () => ref.invalidate(profileControllerProvider),
  ),
  data: (ProfileEntity? data) => ProfileFormWidget(profile: data),
);
```

- One `ref.watch` at the top of `build`, one `when` over the three
  states, core widgets for each. That's an entire screen.
- **`skipLoadingOnReload: true` matters:** Riverpod 3 auto-retries
  failed providers and reports each retry as loading. Without the flag,
  a persistent error renders as an infinite spinner instead of the
  error state.
- **Retry = `ref.invalidate(...)`** — throws the controller away and
  re-runs `build()`. No retry logic in either the view or controller.
- Calling an action:
  `ref.read(profileControllerProvider.notifier).save(…)` — `.notifier`
  for methods, the bare provider for state.

## Where each thing lives

| Thing | Lives in | Not in |
|---|---|---|
| Validation, uid resolution, trimming input | controller | view, repository |
| Which repository/backend | provider override (`lib/app/config/`) | controller |
| Loading spinners, error text, layout | view (core widgets) | controller |
| Ephemeral, logic-free UI state (a toggle, a tab index) | local widget or a tiny `@riverpod` class | screen-level controller |

`setState` is allowed only for that last row, and only when no business
logic touches it — when in doubt, make it a provider (see
`ShowSkippedReadiness` in the setup_status feature for a minimal
example).

## Testing the pair

- **Controller:** `ProviderContainer` + repository override; assert
  emitted states. Riverpod 3 pauses unlistened streams — keep a
  listener attached, as `profile_controller_test.dart` demonstrates.
- **View:** pump inside `ProviderScope(overrides: […])` and assert all
  three `AsyncValue` renderings. Overriding the *repository* (not the
  controller) exercises the real binding.

Full provider reference: [`docs/architecture/RIVERPOD_GUIDE.md`](../docs/architecture/RIVERPOD_GUIDE.md).
