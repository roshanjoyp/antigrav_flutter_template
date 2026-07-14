import 'package:craft_flutter_template/app/bootstrap.dart';
import 'package:craft_flutter_template/core/core.dart';

/// Production entry point.
///
/// ```sh
/// flutter build apk --flavor prod --target lib/main_prod.dart
/// flutter build ipa --flavor prod --target lib/main_prod.dart
/// ```
void main() => bootstrap(AppEnv.production);
