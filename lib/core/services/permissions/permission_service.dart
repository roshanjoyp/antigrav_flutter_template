import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  Future<bool> requestPermission(Permission permission);
  Future<bool> checkPermission(Permission permission);
  Future<void> openSettings();
}
