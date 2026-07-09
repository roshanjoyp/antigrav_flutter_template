# Riverpod vs Provider Guide

If you are coming from `provider`, `riverpod` will feel familiar but more powerful. Here is how they compare and how to use Riverpod in this template.

## Key Differences

| Concept | Provider | Riverpod |
| :--- | :--- | :--- |
| **Global Access** | Requires `BuildContext` (e.g. `Provider.of<T>(context)`) | **No Context needed**. access via `ref` (e.g. `ref.read(provider)`) |
| **Compile Safety** | Runtime errors (ProviderNotFoundException) | **Compile-time safe**. You can't read a provider that doesn't exist. |
| **State** | `ChangeNotifier` | `Notifier`, `AsyncNotifier`, `StateProvider` |
| **Declaration** | `MultiProvider` at root | Global variables (don't worry, they are scoped/testable) |

## Cheatsheet

### 1. Reading a Value (in build)
**Provider**:
```dart
final user = Provider.of<User>(context);
// or
Consumer<User>(builder: (context, user, child) => ...);
```

**Riverpod**:
Extend `ConsumerWidget` instead of `StatelessWidget`.
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider); // Rebuilds on change
    return Text(user.name);
  }
}
```

### 2. Reading a Service (One-time action)
**Provider**:
```dart
Provider.of<AuthService>(context, listen: false).login();
```

**Riverpod**:
```dart
ref.read(authServiceProvider).login(); // No rebuild
```

### 3. State Management (ViewModel/Controller)
**Provider**: `ChangeNotifier`
```dart
class MyController extends ChangeNotifier { ... notifyListeners(); }
```

**Riverpod**: `Notifier` (Generated)
```dart
@riverpod
class MyController extends _$MyController {
  @override
  int build() => 0; // Initial state

  void increment() => state++; // Update state (triggers rebuilds)
}
```

## How we use it here
*   **Services**: Exposed as `@Riverpod(keepAlive: true)` providers (Singletons).
*   **Controllers**: Exposed as `@riverpod` classes (Auto-dispose by default).
*   **UI**: All major widgets are `ConsumerWidget` or `ConsumerStatefulWidget` to access `ref`.

## "Ref" is the Key
Think of `ref` as your handle to the dependency injection system.
*   `ref.watch(provider)`: "I want the value, and **rebuild me** when it changes."
*   `ref.read(provider)`: "I want the value/object implementation **right now**. Don't watch it." (Use in functions/Click handlers).
