import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:craft_generator/src/staging.dart';

/// Regression guard for the empty-zip bug: archive 4.x made
/// `ZipFileEncoder.addFile` async, so the old unawaited loop closed an
/// archive with zero entries. `writeProjectZip` must stay synchronous and
/// must re-apply the denylist.
void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('craft_zip_test_');
    File(p.join(root.path, 'lib', 'main.dart'))
      ..createSync(recursive: true)
      ..writeAsStringSync('void main() {}\n');
    File(p.join(root.path, 'pubspec.yaml'))
      ..createSync(recursive: true)
      ..writeAsStringSync('name: my_app\n');
    // Denied content that gates/setup create inside staging.
    File(p.join(root.path, '.dart_tool', 'x'))
      ..createSync(recursive: true)
      ..writeAsStringSync('deny');
    File(p.join(root.path, 'configurator', 'lib', 'main.dart'))
      ..createSync(recursive: true)
      ..writeAsStringSync('deny');
    File(p.join(root.path, 'generator', 'pubspec.yaml'))
      ..createSync(recursive: true)
      ..writeAsStringSync('deny');
  });

  tearDown(() => root.deleteSync(recursive: true));

  test('writes every non-denied file with its content', () {
    final outPath = p.join(root.path, '..', '${p.basename(root.path)}.zip');
    writeProjectZip(root, outPath);
    addTearDown(() => File(outPath).deleteSync());

    final archive = ZipDecoder().decodeBytes(File(outPath).readAsBytesSync());
    final names = {for (final f in archive) f.name};

    expect(names, {
      'lib/main.dart',
      'pubspec.yaml',
    }, reason: 'denied dirs must be pruned and nothing else lost');
    final main = archive.firstWhere((f) => f.name == 'lib/main.dart');
    expect(String.fromCharCodes(main.readBytes()!), 'void main() {}\n');
  });
}
