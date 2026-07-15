# Network Service

## Overview
The `NetworkService` is the single seam between repositories and the wire
for the app's own REST/HTTP backend. Repositories depend on this interface
— never on an HTTP client directly — so the backend can be swapped (Firebase
→ AWS, or any host move) by rebinding one provider, with zero call-site
changes.

## Interface
```dart
abstract class NetworkService {
  Future<Result<NetworkResponse>> get(String path, {Map<String, dynamic>? queryParameters, Map<String, String>? headers});
  Future<Result<NetworkResponse>> post(String path, {Object? body, ...});
  Future<Result<NetworkResponse>> put(String path, {Object? body, ...});
  Future<Result<NetworkResponse>> patch(String path, {Object? body, ...});
  Future<Result<NetworkResponse>> delete(String path, {Object? body, ...});
}
```

All methods return `Result` and never throw. Failures carry `network/...`
codes (`network/timeout`, `network/no-connection`, `network/http-404`,
`network/cancelled`, `network/bad-certificate`, `network/unknown`) so
repositories can decide between retry, re-auth, and messaging without
importing dio.

## Usage
```dart
final result = await ref.read(networkServiceProvider).get('/v1/profile');
result.fold(
  onSuccess: (response) => ProfileModel.fromJson(response.data! as Map<String, dynamic>),
  onFailure: (e) => ..., // e.code == 'network/timeout' etc.
);
```

## Enabling the real implementation
1. Set your dev/staging/prod base URLs in
   `lib/core/config/network/network_config.dart` (the active URL follows
   the running flavor).
2. Flip `NetworkConfig.enabled` to `true` — `bootstrap.dart` applies
   `networkServiceOverrides()` (lib/app/config/network_overrides.dart),
   rebinding the provider to `DioNetworkService`.
3. To attach bearer tokens, pass a `tokenProvider` in the override — every
   request then carries `Authorization: Bearer <token>`.

## Implementation Details
*   **File**: `network_service_impl.dart`
*   **Current State**: `DebugNetworkService` (logs the request, returns an
    empty 200 after a simulated delay).
*   **Production**: `DioNetworkService` (`dio_network_service_impl.dart`) —
    flavor-resolved base URL, timeout constants from `AppConstants`, error
    mapping in `dio_network_error_mapper.dart`.
