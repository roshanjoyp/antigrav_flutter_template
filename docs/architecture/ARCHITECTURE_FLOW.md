# Architecture & Data Flow

This document explains how the application is wired together, from the entry point to the UI.

## 1. Entry Point (`main.dart`)
Everything starts in `lib/main.dart`.
1.  **Global Error Handling**: The app is wrapped in `runZonedGuarded` to catch any unhandled async errors.
2.  **DI Initialization**: A `ProviderContainer` is created manually. This holds the state of all Riverpod providers.
3.  **App Launch**: `runApp` is called with `UncontrolledProviderScope`, passing the container. This makes the providers available to the widget tree.

## 2. The App Widget (`lib/app/app.dart`)
The `App` widget is the root `ConsumerWidget`.
1.  **Router**: It watches `goRouterProvider` to get the `GoRouter` configuration.
2.  **Theme**: It applies `AppTheme.lightTheme` and `AppTheme.darkTheme`.
3.  **Localization**: It sets up `AppLocalizations` delegates.

## 3. Navigation (`lib/app/router/app_router.dart`)
We use `GoRouter` for declarative routing.
*   **Initial Route**: `/startup`
*   **Startup**: The App first loads `StartupView`.
*   **Next**: `StartupController` decides where to go next (e.g., `/` for Home or `/login` for Auth).

### Who handles Navigation? (View vs. Controller)
This is a common point of confusion.
*   **The Controller** knows *WHERE* to go (Logic).
*   **The View** holds the keys to *GO* there (`BuildContext`).

**The Pattern**:
1.  **Controller**: "I have finished my work. The result is: Go to /home." (Sets specific State).
2.  **View**: Listens to that state. "Oh, the controller says we should go to /home? Okay, I have the Context, I will call `context.go('/home')`."

**Why?**
We avoid passing `BuildContext` to the Controller because:
*   It breaks the "Pure Logic" rule (Logic shouldn't know about Flutter UI elements).
*   Using `context` across async gaps (await) in a Controller is dangerous and can cause crashes if the View was closed.

## 4. Feature Flow
Most features follow a **Clean Architecture** style:

**Presentation (UI) -> Domain (Logic) -> Data (Repository)**

Example: **Startup Feature**
1.  **UI**: `StartupView` (Widget) watches `startupControllerProvider`.
2.  **Controller**: `StartupController` (Riverpod Notifier) executes logic.
3.  **Logic**: The controller calls `LogService` and typically would call `AuthRepository` to check session status.

## 5. Dependency Injection (Riverpod)
*   **Providers**: defined globally or via code generation (`@riverpod`).
*   **Reading**: Widgets use `ref.watch(provider)` to react to changes.
*   **Logic**: Controllers use `ref.read(provider)` to access services or repositories.

## 6. Service Layer
Core services (Log, Crash, etc.) are separated into:
*   **Interface**: `lib/core/services/xyz/xyz_service.dart` (Abstract class).
*   **Implementation**: `lib/core/services/xyz/xyz_service_impl.dart` (Concrete class + Provider).

**Why?** This allows us to keep the app "Backend Agnostic" and easily testable by swapping implementations.
