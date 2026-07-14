/// Pure text derivations shared by the identity form and the preview.
library;

/// Converts a display name to the generator's snake_case project name.
///
/// Mirrors the rename logic in `setup/setup.dart`: lowercase, non
/// alphanumerics collapse to single underscores, edges trimmed. Falls back
/// to `my_app` when nothing survives.
String snakeCase(String input) {
  final String result = input
      .trim()
      .toLowerCase()
      .replaceAll(RegExp('[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  return result.isEmpty ? 'my_app' : result;
}
