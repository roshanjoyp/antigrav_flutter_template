import 'package:antigrav_flutter_template/app/config/app_config_controller.dart';
import 'package:antigrav_flutter_template/app/router/app_router.dart';
import 'package:antigrav_flutter_template/app/theme/app_theme.dart';
import 'package:antigrav_flutter_template/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The root widget of the application.
///
/// Configures [MaterialApp.router] with the active theme, locale, and router
/// from Riverpod providers. All app-wide configuration (theme mode, locale)
/// is driven by [AppConfigController].
///
/// **Adding a new locale:** add a `Locale` entry to `supportedLocales` and
/// create the corresponding ARB file in `lib/l10n/` before shipping.
class App extends ConsumerWidget {
  /// Creates the root [App] widget.
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
      themeAnimationStyle: AnimationStyle.noAnimation,
      locale: appConfig.locale,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Supported locales — add a new [Locale] entry here each time a
      // new language is fully translated and its ARB file is added to
      // lib/l10n/. English is the only required default. Do not add a
      // locale here unless the corresponding ARB file exists and is
      // complete — Flutter will throw at runtime if a locale is listed
      // but has no delegate data.
      supportedLocales: const [
        Locale('en'), // English — default, always required
      ],
    );
  }
}
