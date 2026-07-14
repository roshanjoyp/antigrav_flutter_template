import 'package:craft_configurator/core/services/download_service/download_service_stub_impl.dart'
    if (dart.library.js_interop) 'package:craft_configurator/core/services/download_service/download_service_web_impl.dart'
    as impl;

/// Hands a generated text file to the user as a browser download.
abstract interface class DownloadService {
  /// Offers [text] as a download named [fileName].
  void downloadTextFile({required String fileName, required String text});
}

/// Creates the platform implementation (real on web, throwing elsewhere —
/// the configurator only ships as a web app).
DownloadService createDownloadService() => impl.createDownloadService();
