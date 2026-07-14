import 'package:craft_flutter_template/app/bootstrap.dart';
import 'package:craft_flutter_template/core/core.dart';

/// Staging entry point.
///
/// ```sh
/// flutter run --flavor staging --target lib/main_staging.dart
/// ```
void main() => bootstrap(AppEnv.staging);
