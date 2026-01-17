import 'package:antigrav_flutter_template/core/services/connectivity/connectivity_service.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service_impl.g.dart';

class RealConnectivityService implements ConnectivityService {
  final InternetConnection _internetConnection;

  RealConnectivityService([InternetConnection? internetConnection])
    : _internetConnection = internetConnection ?? InternetConnection();

  @override
  Stream<bool> get onConnectivityChanged => _internetConnection.onStatusChange
      .map((status) => status == InternetStatus.connected);

  @override
  Future<bool> get isConnected => _internetConnection.hasInternetAccess;
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) {
  return RealConnectivityService();
}
