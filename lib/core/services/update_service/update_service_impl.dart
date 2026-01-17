import 'package:antigrav_flutter_template/core/services/update_service/update_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_service_impl.g.dart';

class CustomUpdateService implements UpdateService {
  @override
  Future<AppUpdateInfo?> checkForUpdate() async {
    // TODO: Implement your backend check here.
    // Example:
    // final response = await httpClient.get('https://api.myapp.com/version');
    // if (response.version > currentVersion) return AppUpdateInfo(...);

    // Returning null means no update available.
    return null;
  }
}

@Riverpod(keepAlive: true)
UpdateService updateService(Ref ref) {
  return CustomUpdateService();
}
