import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'package:craft_configurator/core/services/download_service/download_service.dart';

/// Browser implementation: wraps the text in a Blob and clicks a
/// synthetic anchor with a `download` attribute.
class WebDownloadServiceImpl implements DownloadService {
  /// Creates the web implementation.
  const WebDownloadServiceImpl();

  @override
  void downloadTextFile({required String fileName, required String text}) {
    final web.Blob blob = web.Blob(
      [text.toJS].toJS,
      web.BlobPropertyBag(type: 'application/json'),
    );
    final String url = web.URL.createObjectURL(blob);
    final web.HTMLAnchorElement anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName;
    anchor.click();
    web.URL.revokeObjectURL(url);
  }
}

/// Conditional-import factory (see `download_service.dart`).
DownloadService createDownloadService() => const WebDownloadServiceImpl();
