import 'package:craft_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:craft_flutter_template/core/services/network_service/dio_network_service_impl.dart';
import 'package:craft_flutter_template/core/services/network_service/network_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

/// Provider overrides that swap the stub network service for the
/// Dio-backed implementation.
///
/// `bootstrap.dart` applies [networkServiceOverrides] to the root
/// `ProviderContainer` only when `NetworkConfig.enabled` is `true`, so
/// pointing the app at a real backend (see
/// lib/core/config/network/network_config.dart) rebinds every
/// repository built on `networkServiceProvider` with no call-site
/// changes anywhere.
List<Override> networkServiceOverrides() => <Override>[
  networkServiceProvider.overrideWith(
    (Ref ref) => DioNetworkService.fromConfig(
      ref.watch(logServiceProvider),
      // To attach bearer tokens once your backend issues them, pass a
      // tokenProvider that reads the current session, e.g.:
      //   tokenProvider: () => ref.read(authRepositoryProvider).idToken(),
    ),
  ),
];
