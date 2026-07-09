/// Barrel export for the auth feature.
///
/// Exports the domain interface, domain entity, and data layer provider
/// for the auth feature. Generated files and internal implementation
/// details are not exported.
library;

// Domain
export 'package:craft_flutter_template/features/auth/domain/auth_repository.dart';
export 'package:craft_flutter_template/features/auth/domain/user_entity.dart';

// Data — exported for the Riverpod provider (authRepositoryProvider)
export 'package:craft_flutter_template/features/auth/data/auth_repository_impl.dart';

// Data — Firebase implementation, used to override authRepositoryProvider
// when Firebase is enabled (see docs/setup/FIREBASE_SETUP.md)
export 'package:craft_flutter_template/features/auth/data/firebase_auth_repository_impl.dart';
