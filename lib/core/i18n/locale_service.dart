import 'dart:collection';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../logging/logger.dart';

/// Handles locale selection logic and future persistence concerns.
class LocaleService {
  /// Creates a locale service.
  LocaleService({final Locale? initialLocale, required final AppLogger logger})
    : _locale = initialLocale,
      _logger = logger.scoped('i18n.locale'),
      _options = UnmodifiableListView<Locale?>(<Locale?>[
        null,
        ...AppLocalizations.supportedLocales,
      ]);

  Locale? _locale;
  final AppLogger _logger;
  final UnmodifiableListView<Locale?> _options;

  /// List of selectable locales, including `null` for system default.
  UnmodifiableListView<Locale?> get options => _options;

  /// Currently selected locale, or `null` when following the system.
  Locale? get currentLocale => _locale;

  /// Applies a new locale selection and emits structured logs.
  Future<void> changeLocale(final Locale? locale) async {
    if (_locale == locale) {
      return;
    }

    _locale = locale;

    _logger.info(
      'locale.change',
      context: <String, Object?>{
        'languageCode': locale?.languageCode ?? 'system',
        'countryCode': locale?.countryCode ?? 'system',
      },
    );

    // TODO: persist selection via storage layer.
  }
}
