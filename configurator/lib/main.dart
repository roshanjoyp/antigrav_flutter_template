import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:craft_configurator/app/configurator_app.dart';

/// Entry point: the whole app lives under one [ProviderScope].
void main() {
  runApp(const ProviderScope(child: ConfiguratorApp()));
}
