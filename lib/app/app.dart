import 'package:antigrav_flutter_template/app/config/app_config_controller.dart';
import 'package:antigrav_flutter_template/app/router/app_router.dart';
import 'package:antigrav_flutter_template/app/theme/app_theme.dart';
import 'package:antigrav_flutter_template/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final appConfig = ref.watch(appConfigControllerProvider);

    return MaterialApp.router(
      title: 'AntiGrav Template',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appConfig.themeMode,
      locale: appConfig.locale,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
    );
  }
}
