import 'package:permission_handler/permission_handler.dart';

/// Contract for requesting and checking device permissions.
///
/// Permission denial is a **valid result**, not an error. Methods return
/// `false` when a permission is denied or permanently denied. They only
/// throw [AppException] when the platform itself raises an unexpected error.
///
/// Use [PermissionService] via the `permissionServiceProvider` Riverpod
/// provider.
abstract class PermissionService {
  /// Requests the given [permission] from the user.
  ///
  /// Returns `true` if the permission is granted, `false` if denied or
  /// permanently denied. Throws [AppException] on unexpected platform error.
  Future<bool> requestPermission(Permission permission);

  /// Checks the current status of the given [permission] without prompting.
  ///
  /// Returns `true` if the permission is already granted, `false` otherwise.
  /// Throws [AppException] on unexpected platform error.
  Future<bool> checkPermission(Permission permission);

  /// Opens the app's system settings page so the user can manage permissions.
  ///
  /// Throws [AppException] if the settings page cannot be opened.
  Future<void> openSettings();
}
