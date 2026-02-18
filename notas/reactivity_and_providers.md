# Reactivity and Providers Documentation

This document explains how reactivity is implemented using **Riverpod 3.0** and how state flows through the application.

## Core Concepts

### 1. Riverpod 3.0 (Generator Pattern)
The project uses the `@riverpod` annotation pattern. Most providers are generated from classes using the `RiverpodGenerator`. This provides:
- **Type Safety**: No more `Provider<String>`, just the generated class.
- **Auto-dispose**: Providers clean up automatically unless `keepAlive: true` is specified.

### 2. Provider Initialization
The root level initialization happens in `main.dart` within a `ProviderScope`.
```dart
runApp(
  ProviderScope(
    observers: [ErrorHandler()],
    child: const _Initialization(child: MyApp()),
  ),
);
```

## Types of Providers

### Global Providers (`keepAlive: true`)
These providers persist throughout the app's lifecycle:
- **`Auth`**: Manages user session, login/logout, and token persistence.
- **`MultiCDN`**: Continuously monitors and updates the best available content URL.
- **`Notifications`**: Handles system-wide notifications and deep links.
- **`InternetCheck`**: Monitors connectivity status.

### Feature Providers
Providers scoped to specific features or screens (e.g., `CategoryProvider`, `ChannelPlayingProvider`). These usually auto-dispose when the UI that consumes them is unmounted.

## Consuming States

Reactivity is achieved by "watching" providers in widgets or other providers:

### In Widgets (`ConsumerWidget`)
Widgets rebuild automatically when the provider's state changes.
```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);
    return state.when(...);
  }
}
```

### Between Providers
Providers can depend on each other. For example, the `AppRouter` watches the `Auth` provider to determine the initial route.

## Unified State Handling (Freezed)

All complex states use **Freezed Union Types**. This allows for exhaustive switch-case handling in the UI, ensuring all scenarios (Loading, Error, Success) are covered.

Example state definition:
```dart
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.error(AppException failure) = Error;
  const factory AuthState.success(User entity) = Success;
}
```

The UI handles this reactively:
```dart
authState.when(
  initial: () => IntroScreen(),
  loading: () => LoadingSpinner(),
  error: (err) => ErrorMessage(err),
  success: (user) => HomeScreen(user),
);
```
