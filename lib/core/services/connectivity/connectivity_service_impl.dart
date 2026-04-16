import 'package:antigrav_flutter_template/core/services/connectivity/connectivity_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service_impl.g.dart';

/// A [ConnectivityService] backed by [InternetConnection].
///
/// Both [isConnected] and [onConnectivityChanged] propagate errors as
/// [AppException] rather than raw platform exceptions, ensuring callers
/// receive structured error information.
///
/// The stream surfaces errors via [AppException] so stream subscribers
/// can distinguish connectivity errors from connectivity state changes.
class RealConnectivityService implements ConnectivityService {
  /// Creates a [RealConnectivityService].
  ///
  /// [internetConnection] may be injected for testing. Defaults to a
  /// new [InternetConnection] instance.
  /// [logger] is used to log errors before propagating them.
  RealConnectivityService({
    InternetConnection? internetConnection,
    required LogService logger,
  })  : _internetConnection = internetConnection ?? InternetConnection(),
        _logger = logger;

  final InternetConnection _internetConnection;
  final LogService _logger;

  /// A stream of connectivity state changes.
  ///
  /// Emits `true` when the device gains internet access and `false` when
  /// it loses it. Errors from the underlying platform are logged and
  /// re-thrown as [AppException].
  @override
  Stream<bool> get onConnectivityChanged => _internetConnection.onStatusChange
      .map((status) => status == InternetStatus.connected)
      .handleError((Object error, StackTrace stack) {
        _logger.error('Connectivity stream error', error, stack);
        throw AppException(
          message: 'Connectivity stream error',
          code: 'connectivity/stream-error',
          originalError: error,
          stackTrace: stack,
        );
      });

  /// Returns the current internet connectivity state.
  ///
  /// Returns `true` if the device has internet access, `false` otherwise.
  /// Throws [AppException] if the connectivity check itself fails.
  @override
  Future<bool> get isConnected async {
    try {
      return await _internetConnection.hasInternetAccess;
    } catch (e, st) {
      _logger.error('Failed to check internet connectivity', e, st);
      throw AppException(
        message: 'Failed to check internet connectivity',
        code: 'connectivity/check-failed',
        originalError: e,
        stackTrace: st,
      );
    }
  }
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) {
  return RealConnectivityService(logger: ref.watch(logServiceProvider));
}
