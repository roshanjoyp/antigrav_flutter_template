import 'package:antigrav_flutter_template/core/services/permissions/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_service_impl.g.dart';

class RealPermissionService implements PermissionService {
  @override
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  @override
  Future<bool> checkPermission(Permission permission) async {
    return await permission.isGranted;
  }

  @override
  Future<void> openSettings() async {
    await openAppSettings();
  }
}

@Riverpod(keepAlive: true)
PermissionService permissionService(Ref ref) {
  return RealPermissionService();
}
