import 'package:craft_generator/craft_generator.dart';
import 'package:test/test.dart';

const _ids = {'firebase', 'push', 'onboarding'};

void main() {
  group('stripMarkers', () {
    test('removes an excluded region including its markers', () {
      const source = '''
keep;
// MODULE(firebase): begin
gone;
// MODULE(firebase): end
also kept;''';
      expect(stripMarkers(source, excluded: {'firebase'}), 'keep;\nalso kept;');
    });

    test('strips marker text but keeps code for included modules', () {
      const source = '''
// MODULE(firebase): begin
kept code;
// MODULE(firebase): end
inline; // MODULE(push)''';
      expect(stripMarkers(source, excluded: const {}), 'kept code;\ninline;');
    });

    test('removes an excluded suffix-marked line entirely', () {
      const source = 'a;\nb; // MODULE(push)\nc;';
      expect(stripMarkers(source, excluded: {'push'}), 'a;\nc;');
    });

    test('handles cross-module nesting when the outer is excluded', () {
      const source = '''
// MODULE(firebase): begin
f;
// MODULE(push): begin
p;
// MODULE(push): end
// MODULE(firebase): end
tail;''';
      expect(stripMarkers(source, excluded: {'firebase'}), 'tail;');
    });

    test('handles cross-module nesting when only the inner is excluded', () {
      const source = '''
// MODULE(firebase): begin
f;
// MODULE(push): begin
p;
// MODULE(push): end
// MODULE(firebase): end''';
      expect(stripMarkers(source, excluded: {'push'}), 'f;');
    });

    test('supports hash-style markers', () {
      const source =
          'a: 1\nb: 2 # MODULE(push)\n# MODULE(push): begin\nc: 3\n# MODULE(push): end';
      expect(stripMarkers(source, excluded: {'push'}), 'a: 1');
    });
  });

  group('scanMarkers', () {
    test('reports sites and no errors for balanced markers', () {
      const source = '''
// MODULE(firebase): begin
x; // MODULE(push)
// MODULE(firebase): end''';
      final (sites, errors) = scanMarkers(source, knownIds: _ids);
      expect(errors, isEmpty);
      expect(sites.map((s) => s.kind), ['begin', 'line', 'end']);
    });

    test('flags unknown ids', () {
      final (_, errors) = scanMarkers('x; // MODULE(bogus)', knownIds: _ids);
      expect(errors.single.message, contains('unknown module id'));
    });

    test('flags unbalanced and mismatched regions', () {
      final (_, e1) = scanMarkers('// MODULE(firebase): begin', knownIds: _ids);
      expect(e1.single.message, contains('begin without end'));

      final (_, e2) = scanMarkers('// MODULE(push): end', knownIds: _ids);
      expect(e2.single.message, contains('end without matching begin'));
    });

    test('flags same-module nesting', () {
      const source = '''
// MODULE(push): begin
// MODULE(push): begin
// MODULE(push): end
// MODULE(push): end''';
      final (_, errors) = scanMarkers(source, knownIds: _ids);
      expect(errors.first.message, contains('nested in itself'));
    });
  });
}
