class AppUpdateInfo {
  final String version;
  final bool isMandatory;
  final String? releaseNotesUrl;

  const AppUpdateInfo({
    required this.version,
    required this.isMandatory,
    this.releaseNotesUrl,
  });
}

abstract class UpdateService {
  /// Checks if a new version is available.
  /// Returns [AppUpdateInfo] if an update is found, or null otherwise.
  Future<AppUpdateInfo?> checkForUpdate();
}
