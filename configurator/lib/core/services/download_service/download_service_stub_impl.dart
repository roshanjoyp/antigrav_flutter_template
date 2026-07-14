import 'package:craft_configurator/core/services/download_service/download_service.dart';

/// Non-web fallback so VM test runs can compile the app; the configurator
/// is only ever served as a web app.
class StubDownloadServiceImpl implements DownloadService {
  /// Creates the stub.
  const StubDownloadServiceImpl();

  @override
  void downloadTextFile({required String fileName, required String text}) {
    throw UnsupportedError('Downloads are only available in the browser.');
  }
}

/// Conditional-import factory (see `download_service.dart`).
DownloadService createDownloadService() => const StubDownloadServiceImpl();
