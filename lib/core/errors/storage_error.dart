// ignore_for_file: public_member_api_docs

import 'app_error.dart';

/// Errors related to local storage, databases, or file systems.
final class StorageError extends AppError {
  const StorageError._({
    required super.code,
    required super.message,
    super.cause,
    super.stackTrace,
  });

  const StorageError.notFound({
    final String message = 'Requested item was not found.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'storage.not_found',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const StorageError.corrupted({
    final String message = 'Stored data is corrupted.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'storage.corrupted',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const StorageError.permissionDenied({
    final String message = 'Storage permission denied.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'storage.permission_denied',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const StorageError.writeFailed({
    final String message = 'Failed to write to storage.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'storage.write_failed',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );
}