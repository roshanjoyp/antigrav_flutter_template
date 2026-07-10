# Models vs. Entities

The template keeps two classes for profile data — `ProfileEntity`
(domain) and `ProfileModel` (data). This looks like duplication until
the first time it saves you.

## The split in one sentence

**The entity is what the thing *is* to your app; the model is how one
particular backend *stores* it.**

| | Entity (`domain/`) | Model (`data/`) |
|---|---|---|
| Knows about | business fields only | JSON keys, `Timestamp`, document shape |
| Imports | freezed only | freezed + backend SDKs |
| Used by | controllers, views, repos (as the contract type) | repository *implementations* only |
| Example | `ProfileEntity.updatedAt` is a `DateTime` | `ProfileModel` converts it to a Firestore `Timestamp` |

Repository interfaces speak entities. Models never cross out of the
data layer — the conversion happens inside the repository
implementation, at the boundary:

```dart
// firestore_profile_repository_impl.dart
final ProfileModel model = ProfileModel.fromJson(snapshot.data()!);
return model.toEntity();                       // out: entity
…
await doc.set(ProfileModel.fromEntity(profile).toJson());  // in: model
```

## Why bother?

- **Backend churn stays contained.** Rename a Firestore field, switch
  `Timestamp` handling, move to Supabase — only the model and the one
  repository implementation change. Controllers, views, and tests
  don't know it happened.
- **The stub stays trivial.** `StubProfileRepository` works directly
  with entities in a map. No fake JSON needed.
- **Serialization quirks don't leak.** `ProfileModel`'s
  `TimestampConverter` tolerates nulls and wrong types so a malformed
  document degrades instead of crashing — that defensive code belongs
  next to the storage format, not in the domain.

## When do I actually need a model?

- **No real backend yet (stub only)?** Skip the model. The entity is
  enough — the notes example in
  [Add a Feature](02_add_a_feature.md) starts this way.
- **Wiring Firestore/REST/anything serialized?** Add the model in
  `data/`, with `fromJson`/`toJson`, `fromEntity`/`toEntity`, and any
  converters. Keep the entity untouched.
- **Entity and model fields drift apart?** Good — that's the point.
  Store-only fields (schema versions, denormalized counters) go on the
  model and simply don't map to the entity.

## Smells that mean the split is broken

- An import of `cloud_firestore` (or any SDK) inside `domain/`.
- A widget or controller constructing a model.
- `toJson` on an entity.
- A repository interface that mentions a model type.

Any of these means persistence is leaking toward the UI; push it back
into `data/`.
