import 'package:craft_flutter_template/core/setup/manifests/core_manifest.dart';
import 'package:craft_flutter_template/core/setup/manifests/firebase_manifest.dart';
import 'package:craft_flutter_template/core/setup/manifests/push_manifest.dart';
import 'package:craft_flutter_template/core/setup/manifests/revenuecat_manifest.dart';
import 'package:craft_flutter_template/core/setup/setup_step.dart';

export 'package:craft_flutter_template/core/setup/setup_step.dart';

/// Aggregated view over every module's setup-step manifest.
///
/// Single source of truth for the doctor CLI (`tool/doctor.dart`), the
/// in-app Setup Status screen, and (later) the v2 generator. Add new
/// modules by creating a manifest in `lib/core/setup/manifests/` and
/// listing it here.
class SetupManifest {
  /// Not instantiable — all members are static.
  const SetupManifest._();

  /// Every declared setup step across all modules, in module order.
  static const List<SetupStep> allSteps = [
    ...coreSetupSteps,
    ...firebaseSetupSteps,
    ...revenuecatSetupSteps,
    ...pushSetupSteps,
  ];

  /// The steps declared for [module].
  static List<SetupStep> stepsForModule(SetupModule module) =>
      allSteps.where((SetupStep step) => step.module == module).toList();

  /// The steps verified the given way ([SetupCheckKind]).
  static List<SetupStep> stepsOfKind(SetupCheckKind kind) =>
      allSteps.where((SetupStep step) => step.kind == kind).toList();

  /// Looks up a step by its stable [SetupStep.id], or `null` if the id
  /// is not declared in any manifest.
  static SetupStep? byId(String id) {
    for (final SetupStep step in allSteps) {
      if (step.id == id) return step;
    }
    return null;
  }
}
