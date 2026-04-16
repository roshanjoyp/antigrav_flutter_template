/// Barrel export for the startup feature.
///
/// Exports [StartupView], the entry-point screen used by the router.
/// [StartupController] is intentionally not exported — it is an internal
/// implementation detail consumed only by [StartupView].
library;

export 'package:antigrav_flutter_template/features/startup/presentation/startup_view.dart';
