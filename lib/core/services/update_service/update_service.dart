/// Holds information about an available app update.
///
/// Returned by [UpdateService.checkForUpdate] when a newer version of the
/// app is available for installation.
class AppUpdateInfo {
  /// Creates an [AppUpdateInfo] with the given details.
  const AppUpdateInfo({
    required this.version,
    required this.isMandatory,
    this.releaseNotesUrl,
  });

  /// The version string of the available update, e.g. `'2.1.0'`.
  final String version;

  /// Whether this update is mandatory and the user cannot skip it.
  final bool isMandatory;

  /// An optional URL pointing to the release notes for this update.
  final String? releaseNotesUrl;
}

/// Contract for checking whether an app update is available.
///
/// Use [UpdateService] via the `updateServiceProvider` Riverpod provider.
abstract class UpdateService {
  /// Checks whether a new version of the app is available.
  ///
  /// Returns an [AppUpdateInfo] if an update is available, or `null` if the
  /// app is already up-to-date. A `null` return is a valid, non-error result.
  ///
  /// Throws [AppException] if the update check itself fails (e.g. network
  /// error or malformed server response).
  Future<AppUpdateInfo?> checkForUpdate();
}
