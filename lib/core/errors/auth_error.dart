// ignore_for_file: public_member_api_docs

import 'app_error.dart';

/// Errors originating from authentication and authorization flows.
final class AuthError extends AppError {
  const AuthError._({
    required super.code,
    required super.message,
    super.cause,
    super.stackTrace,
  });

  const AuthError.invalidCredentials({
    final String message = 'Invalid credentials provided.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'auth.invalid_credentials',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const AuthError.tokenExpired({
    final String message = 'Authentication token has expired.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'auth.token_expired',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const AuthError.notAuthenticated({
    final String message = 'No authenticated session present.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'auth.not_authenticated',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const AuthError.notAuthorized({
    final String message = 'Authenticated user is not authorized.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'auth.not_authorized',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );
}