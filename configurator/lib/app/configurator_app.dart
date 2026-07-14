import 'package:flutter/material.dart';

import 'package:craft_configurator/app/theme/app_theme.dart';
import 'package:craft_configurator/features/configurator/presentation/configurator_screen.dart';

/// Root widget: single dark theme, single screen.
class ConfiguratorApp extends StatelessWidget {
  /// Creates the app.
  const ConfiguratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRAFT — Flutter starter, configured not cloned',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const ConfiguratorScreen(),
    );
  }
}
