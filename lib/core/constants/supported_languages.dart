import '../errors/validation_error.dart';

/// Supported languages in the app.
/// This enum should be updated when adding new languages to keep the code type-safe.
enum SupportedLanguage {
  /// English
  en('en'),

  /// German
  de('de');

  const SupportedLanguage(this.languageCode);

  /// The language code.
  final String languageCode;

  /// Gets the SupportedLanguage from a language code.
  static SupportedLanguage fromLanguageCode(final String code) {
    return SupportedLanguage.values.firstWhere(
      (final lang) => lang.languageCode == code,
      orElse: () => throw ValidationError(
        fieldErrors: <String, String>{'languageCode': code},
      ),
    );
  }
}
