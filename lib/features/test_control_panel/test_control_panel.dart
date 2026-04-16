/// Barrel export for the test control panel feature.
///
/// Exports [TestScreen] and all six per-service test widgets.
/// This feature is developer-only and should not be accessible
/// in production builds.
library;

// Screen
export 'package:antigrav_flutter_template/features/test_control_panel/presentation/test_screen.dart';

// Per-service test widgets
export 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/analytics_test_widget.dart';
export 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/connectivity_test_widget.dart';
export 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/crash_test_widget.dart';
export 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/log_test_widget.dart';
export 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/permissions_test_widget.dart';
export 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/update_test_widget.dart';
