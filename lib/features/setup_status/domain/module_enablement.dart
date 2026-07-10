import 'package:craft_flutter_template/core/config/firebase/firebase_config.dart';
import 'package:craft_flutter_template/core/config/revenuecat/revenuecat_config.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';

/// Whether [module]'s setup steps and readiness items apply in this
/// build, derived from the compile-time module switches.
///
/// The runtime mirror of the doctor CLI's source parsing: push rides on
/// the Firebase switch, core is always on.
///
/// Written as an if-chain (not a switch) on purpose: each module's arm
/// is independent, so the generator can remove one without touching the
/// others or fighting switch exhaustiveness. Modules absent from the
/// chain fall through to `false`.
bool isModuleEnabled(SetupModule module) {
  if (module == SetupModule.core) return true;
  if (module == SetupModule.firebase) return FirebaseConfig.enabled;
  if (module == SetupModule.push) return FirebaseConfig.enabled;
  if (module == SetupModule.revenuecat) return RevenueCatConfig.enabled;
  return false;
}
