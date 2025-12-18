// ignore_for_file: public_member_api_docs

import 'app_error.dart';

/// Errors originating from network interactions.
final class NetworkError extends AppError {
  const NetworkError._({
    required super.code,
    required super.message,
    super.cause,
    super.stackTrace,
  });

  const NetworkError.connection({
    final String message = 'Network connection unavailable.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'network.connection',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const NetworkError.timeout({
    final String message = 'Network request timed out.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'network.timeout',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const NetworkError.serverError({
    final String message = 'Server responded with an error.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'network.server_error',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const NetworkError.unauthorized({
    final String message = 'Request is not authorized.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'network.unauthorized',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );
}