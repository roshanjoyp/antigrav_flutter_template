/// Contract for monitoring internet connectivity.
///
/// Use [ConnectivityService] via the `connectivityServiceProvider` Riverpod
/// provider to check the current connectivity state or listen for changes.
abstract class ConnectivityService {
  /// A stream that emits `true` when internet access is gained and `false`
  /// when it is lost.
  ///
  /// Subscribers should handle stream errors — implementations may emit
  /// an [AppException] if the underlying platform check fails.
  Stream<bool> get onConnectivityChanged;

  /// Returns the current internet connectivity state.
  ///
  /// Returns `true` if the device currently has internet access.
  /// Throws [AppException] if the connectivity check itself fails.
  Future<bool> get isConnected;
}
