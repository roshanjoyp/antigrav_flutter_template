import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_controller.g.dart';

class AppConfigState {
  final ThemeMode themeMode;
  final Locale locale;

  const AppConfigState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
  });

  AppConfigState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return AppConfigState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

@riverpod
class AppConfigController extends _$AppConfigController {
  @override
  AppConfigState build() {
    return const AppConfigState();
  }

  void toggleTheme() {
    state = state.copyWith(
      themeMode: state.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void toggleLocale() {
    state = state.copyWith(
      locale: state.locale.languageCode == 'en'
          ? const Locale('es')
          : const Locale('en'),
    );
  }

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
  }
}
