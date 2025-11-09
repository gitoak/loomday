import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../i18n/locale_service.dart';
import '../logging/logger.dart';
import 'env.dart';

part 'providers.g.dart';

/// Provides the active application environment.
@Riverpod(keepAlive: true)
AppEnvironment env(final Ref ref) => AppEnvironment.development;

/// Provides the shared application logger configured for the active environment.
@Riverpod(keepAlive: true)
AppLogger logger(final Ref ref) {
  final environment = ref.watch(envProvider);
  final normalizedName = environment.name.toLowerCase();
  final isProd = environment.enableAnalytics || normalizedName.contains('prod');

  return AppLogger(
    name: 'loomday',
    minLevel: isProd ? LogLevel.info : LogLevel.debug,
    stackTraceLevel: isProd ? LogLevel.error : LogLevel.warning,
    context: <String, Object?>{'environment': environment.name},
  );
}

/// Provides the locale service that encapsulates locale change logic.
@Riverpod(keepAlive: true)
LocaleService localeService(final Ref ref) {
  final logger = ref.watch(loggerProvider).scoped('i18n');
  return LocaleService(logger: logger);
}

/// Controls the currently selected locale for the application.
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Locale? build() {
    return ref.read(localeServiceProvider).currentLocale;
  }

  /// The available locale options.
  UnmodifiableListView<Locale?> get options =>
      ref.read(localeServiceProvider).options;

  /// Changes the current locale to the given value.
  Future<void> changeLocale(final Locale? locale) async {
    final service = ref.read(localeServiceProvider);
    await service.changeLocale(locale);
    state = service.currentLocale;
  }
}
