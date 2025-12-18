// ignore_for_file: public_member_api_docs

import 'dart:collection';

import 'app_error.dart';

/// Field-level validation errors with optional field-specific messages.
final class ValidationError extends AppError {
  ValidationError({
    required Map<String, String> fieldErrors,
    final String message = 'Validation failed.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : _fieldErrors = Map<String, String>.unmodifiable(fieldErrors),
       super(
         code: 'validation.failed',
         message: message,
         cause: cause,
         stackTrace: stackTrace,
       );

  final Map<String, String> _fieldErrors;

  /// Read-only access to the field error map.
  UnmodifiableMapView<String, String> get fieldErrors =>
      UnmodifiableMapView<String, String>(_fieldErrors);
}