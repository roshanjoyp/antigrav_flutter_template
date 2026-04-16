import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/permissions/permission_service.dart';
import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_service_impl.g.dart';

/// A [PermissionService] backed by the [permission_handler] package.
///
/// Permission denial is a **valid result**, not an error — [requestPermission]
/// and [checkPermission] return `false` when a permission is denied or
/// permanently denied. They only throw [AppException] when the platform
/// itself raises an unexpected error (e.g. a [PlatformException]).
class RealPermissionService implements PermissionService {
  /// Creates a [RealPermissionService].
  ///
  /// [logger] is used to log errors before propagating them.
  RealPermissionService({required LogService logger}) : _logger = logger;

  final LogService _logger;

  /// Requests the given [permission] from the user.
  ///
  /// Returns `true` if granted, `false` if denied or permanently denied.
  /// Throws [AppException] only if the platform raises an unexpected error.
  @override
  Future<bool> requestPermission(Permission permission) async {
    try {
      final status = await permission.request();
      return status.isGranted;
    } catch (e, st) {
      _logger.error('Failed to request permission: $permission', e, st);
      throw AppException(
        message: 'Failed to request permission: $permission',
        code: 'permissions/request-failed',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Checks the current status of the given [permission].
  ///
  /// Returns `true` if granted, `false` otherwise.
  /// Throws [AppException] only if the platform raises an unexpected error.
  @override
  Future<bool> checkPermission(Permission permission) async {
    try {
      return await permission.isGranted;
    } catch (e, st) {
      _logger.error('Failed to check permission: $permission', e, st);
      throw AppException(
        message: 'Failed to check permission: $permission',
        code: 'permissions/check-failed',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Opens the app's system settings page.
  ///
  /// Throws [AppException] if the settings page cannot be opened.
  @override
  Future<void> openSettings() async {
    try {
      await openAppSettings();
    } catch (e, st) {
      _logger.error('Failed to open app settings', e, st);
      throw AppException(
        message: 'Failed to open app settings',
        code: 'permissions/open-settings-failed',
        originalError: e,
        stackTrace: st,
      );
    }
  }
}

@Riverpod(keepAlive: true)
PermissionService permissionService(Ref ref) {
  return RealPermissionService(logger: ref.watch(logServiceProvider));
}
