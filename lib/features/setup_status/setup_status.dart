/// Barrel export for the dev-only Setup Status feature.
///
/// Runs the setup manifest's runtime checks (Firebase init, anonymous
/// auth, FCM token) and lists manual console steps. Routed only in
/// debug builds.
library;

export 'package:craft_flutter_template/features/setup_status/domain/runtime_check_entity.dart';
export 'package:craft_flutter_template/features/setup_status/presentation/setup_status_controller.dart';
export 'package:craft_flutter_template/features/setup_status/presentation/setup_status_screen.dart';
