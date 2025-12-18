// ignore_for_file: public_member_api_docs

import 'app_error.dart';

/// Errors arising from synchronization processes.
final class SyncError extends AppError {
  const SyncError._({
    required super.code,
    required super.message,
    super.cause,
    super.stackTrace,
  });

  const SyncError.conflict({
    final String message = 'Sync conflict detected.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'sync.conflict',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const SyncError.versionMismatch({
    final String message = 'Version mismatch during sync.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'sync.version_mismatch',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const SyncError.offline({
    final String message = 'Device is offline; sync deferred.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'sync.offline',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );

  const SyncError.queueFailed({
    final String message = 'Failed to enqueue item for sync.',
    final Object? cause,
    final StackTrace? stackTrace,
  }) : this._(
          code: 'sync.queue_failed',
          message: message,
          cause: cause,
          stackTrace: stackTrace,
        );
}