import 'package:craft_configurator/features/configurator/domain/configuration_entity.dart';
import 'package:craft_configurator/features/configurator/domain/module_catalogue.dart';
import 'package:craft_configurator/features/configurator/domain/setup_step_entity.dart';

/// One line of a code-style preview pane.
class PreviewLine {
  /// Creates a preview line; [added] lines render emphasized with a `+`.
  const PreviewLine(this.text, {this.added = false});

  /// The literal text of the line.
  final String text;

  /// Whether this line is contributed by the current selection.
  final bool added;
}

/// Pure derivations that turn a [ConfigurationEntity] into the three
/// preview panes and the summary line — the live mirror of what the
/// generator will produce.
abstract final class PreviewDerivations {
  /// Deduped, sorted dependencies added by the enabled modules.
  static List<String> addedDeps(ConfigurationEntity config) {
    final Set<String> deps = {
      for (final m in config.enabledModules) ...m.pubspecDeps,
    };
    return deps.toList()..sort();
  }

  /// Setup steps of every enabled module, in catalogue order.
  static List<SetupStepEntity> steps(ConfigurationEntity config) {
    return [for (final m in config.enabledModules) ...m.steps];
  }

  /// The `n modules · n dependencies · n setup steps` line.
  static String summary(ConfigurationEntity config) {
    final int modules = config.enabledModules.length;
    final int deps = kBaseDeps.length + addedDeps(config).length;
    final int stepCount = steps(config).length;
    return '$modules modules · $deps dependencies · $stepCount setup steps';
  }

  /// Lines of the Files tab: dimmed base tree + added module paths.
  static List<PreviewLine> fileTree(ConfigurationEntity config) {
    return [
      PreviewLine('${config.projectName}/'),
      for (final line in kBaseTree) PreviewLine('  $line'),
      for (final m in config.enabledModules)
        for (final path in m.addedFiles) PreviewLine(path, added: true),
    ];
  }

  /// Lines of the pubspec tab: dimmed base deps + added module deps.
  static List<PreviewLine> pubspec(ConfigurationEntity config) {
    return [
      PreviewLine('name: ${config.projectName}'),
      const PreviewLine(''),
      const PreviewLine('dependencies:'),
      for (final dep in kBaseDeps) PreviewLine('  $dep'),
      for (final dep in addedDeps(config)) PreviewLine(dep, added: true),
    ];
  }
}
