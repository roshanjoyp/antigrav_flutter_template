import 'package:craft_flutter_template/core/config/firebase/firebase_config.dart';
import 'package:craft_flutter_template/core/config/revenuecat/revenuecat_config.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';

/// Whether [module]'s setup steps and readiness items apply in this
/// build, derived from the compile-time module switches.
///
/// The runtime mirror of the doctor CLI's source parsing: push rides on
/// the Firebase switch, core is always on.
bool isModuleEnabled(SetupModule module) => switch (module) {
  SetupModule.core => true,
  SetupModule.firebase || SetupModule.push => FirebaseConfig.enabled,
  SetupModule.revenuecat => RevenueCatConfig.enabled,
};
