import 'package:flutter_test/flutter_test.dart';

import '../../../lib/core/errors/app_error.dart';
import '../../../lib/core/errors/auth_error.dart';
import '../../../lib/core/errors/network_error.dart';
import '../../../lib/core/errors/storage_error.dart';
import '../../../lib/core/errors/sync_error.dart';
import '../../../lib/core/errors/validation_error.dart';

void main() {
  group('AppError', () {
    test('toString includes code and message', () {
      const error = NetworkError.timeout(message: 'Timed out');

      final rendered = error.toString();

      expect(rendered, contains('network.timeout'));
      expect(rendered, contains('Timed out'));
    });
  });

  group('NetworkError', () {
    test('provides stable codes and default messages', () {
      const connection = NetworkError.connection();
      const timeout = NetworkError.timeout();
      const server = NetworkError.serverError();
      const unauthorized = NetworkError.unauthorized();

      expect(connection.code, 'network.connection');
      expect(connection.message, 'Network connection unavailable.');

      expect(timeout.code, 'network.timeout');
      expect(timeout.message, 'Network request timed out.');

      expect(server.code, 'network.server_error');
      expect(server.message, 'Server responded with an error.');

      expect(unauthorized.code, 'network.unauthorized');
      expect(unauthorized.message, 'Request is not authorized.');
    });

    test('captures cause and stackTrace when provided', () {
      final stack = StackTrace.current;
      final cause = Exception('cause');
      final error = NetworkError.serverError(cause: cause, stackTrace: stack);

      expect(error.cause, same(cause));
      expect(error.stackTrace, same(stack));
    });
  });

  group('StorageError', () {
    test('provides stable codes and default messages', () {
      const notFound = StorageError.notFound();
      const corrupted = StorageError.corrupted();
      const permission = StorageError.permissionDenied();
      const writeFailed = StorageError.writeFailed();

      expect(notFound.code, 'storage.not_found');
      expect(notFound.message, 'Requested item was not found.');

      expect(corrupted.code, 'storage.corrupted');
      expect(corrupted.message, 'Stored data is corrupted.');

      expect(permission.code, 'storage.permission_denied');
      expect(permission.message, 'Storage permission denied.');

      expect(writeFailed.code, 'storage.write_failed');
      expect(writeFailed.message, 'Failed to write to storage.');
    });
  });

  group('AuthError', () {
    test('provides stable codes and default messages', () {
      const invalid = AuthError.invalidCredentials();
      const expired = AuthError.tokenExpired();
      const notAuth = AuthError.notAuthenticated();
      const notAuthorized = AuthError.notAuthorized();

      expect(invalid.code, 'auth.invalid_credentials');
      expect(invalid.message, 'Invalid credentials provided.');

      expect(expired.code, 'auth.token_expired');
      expect(expired.message, 'Authentication token has expired.');

      expect(notAuth.code, 'auth.not_authenticated');
      expect(notAuth.message, 'No authenticated session present.');

      expect(notAuthorized.code, 'auth.not_authorized');
      expect(notAuthorized.message, 'Authenticated user is not authorized.');
    });
  });

  group('SyncError', () {
    test('provides stable codes and default messages', () {
      const conflict = SyncError.conflict();
      const versionMismatch = SyncError.versionMismatch();
      const offline = SyncError.offline();
      const queueFailed = SyncError.queueFailed();

      expect(conflict.code, 'sync.conflict');
      expect(conflict.message, 'Sync conflict detected.');

      expect(versionMismatch.code, 'sync.version_mismatch');
      expect(versionMismatch.message, 'Version mismatch during sync.');

      expect(offline.code, 'sync.offline');
      expect(offline.message, 'Device is offline; sync deferred.');

      expect(queueFailed.code, 'sync.queue_failed');
      expect(queueFailed.message, 'Failed to enqueue item for sync.');
    });
  });

  group('ValidationError', () {
    test('wraps field errors in an unmodifiable view', () {
      final source = <String, String>{'field': 'required'};
      final error = ValidationError(fieldErrors: source);

      expect(error.fieldErrors['field'], 'required');
      expect(() => error.fieldErrors['field'] = 'changed', throwsUnsupportedError);

      source['field'] = 'mutated';
      expect(error.fieldErrors['field'], 'required');
    });

    test('preserves custom message and cause data', () {
      final stack = StackTrace.current;
      final cause = Exception('cause');
      final error = ValidationError(
        fieldErrors: const <String, String>{'name': 'too short'},
        message: 'Bad input',
        cause: cause,
        stackTrace: stack,
      );

      expect(error.code, 'validation.failed');
      expect(error.message, 'Bad input');
      expect(error.cause, same(cause));
      expect(error.stackTrace, same(stack));
    });
  });
}
