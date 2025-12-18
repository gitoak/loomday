import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import '../../../lib/core/logging/logger.dart';
import '../../../lib/core/types/async_result.dart';
import '../../../lib/core/types/result.dart';

void main() {
  group('guard', () {
    test('returns success when the callback completes', () async {
      final result = await guard<int, String>(
        () => 3,
        (final error, final stackTrace) => 'mapped',
      );

      expect(result, isA<Success<int, String>>());
      expect(result.value, 3);
    });

    test('maps thrown errors and logs with stack trace', () async {
      final entries = <LogEntry>[];
      final logger = AppLogger(
        minLevel: LogLevel.debug,
        sinks: <LogSink>[_FakeLogSink(entries)],
      );

      StackTrace? capturedStack;
      final result = await guard<int, String>(
        () => throw StateError('failure'),
        (final error, final stackTrace) {
          capturedStack = stackTrace;
          return 'mapped';
        },
        logger: logger,
      );

      expect(result, isA<Failure<int, String>>());
      expect(result.error, 'mapped');
      expect(capturedStack, isNotNull);

      expect(entries, hasLength(1));
      final entry = entries.first;
      expect(entry.level, LogLevel.error);
      expect(entry.message, 'result.guard');
      expect(entry.error, isA<StateError>());
      expect(entry.stackTrace, isNotNull);
    });
  });

  group('FutureResultX', () {
    test('map transforms success values asynchronously', () async {
      final result = await Future<Result<int, String>>.value(
        const Success<int, String>(value: 2),
      ).map((final value) => value * 3);

      expect(result, isA<Success<int, String>>());
      expect(result.value, 6);
    });

    test('mapError transforms failures asynchronously', () async {
      final result = await Future<Result<int, String>>.value(
        const Failure<int, String>(error: 'err'),
      ).mapError((final error) => error.length);

      expect(result, isA<Failure<int, int>>());
      expect(result.error, 3);
    });

    test('andThen chains only on success', () async {
      var nextCalled = false;
      final success = await Future<Result<int, String>>.value(
        const Success<int, String>(value: 1),
      ).andThen((final value) {
        nextCalled = true;
        return Result<int, String>.success(value + 1);
      });

      expect(nextCalled, isTrue);
      expect(success.value, 2);

      nextCalled = false;
      final failure = await Future<Result<int, String>>.value(
        const Failure<int, String>(error: 'err'),
      ).andThen((final _) {
        nextCalled = true;
        return const Success<int, String>(value: 0);
      });

      expect(nextCalled, isFalse);
      expect(failure.error, 'err');
    });
  });

  group('Result.toAsyncValue', () {
    test('converts success to AsyncData', () {
      const result = Success<int, String>(value: 7);
      final asyncValue = result.toAsyncValue(mapError: (final error) => error);

      expect(asyncValue, isA<AsyncData<int>>());
      expect(asyncValue.requireValue, 7);
    });

    test('converts failure to AsyncError using mapped error', () {
      final stack = StackTrace.current;
      final result = Failure<_ErrorWithStack, _ErrorWithStack>(
        error: _ErrorWithStack(stack),
      );

      final asyncValue = result.toAsyncValue(mapError: (final error) => error);

      expect(asyncValue, isA<AsyncError<_ErrorWithStack>>());
      asyncValue.when(
        data: (_) => fail('expected error'),
        error: (final error, final stackTrace) {
          expect(error, isA<_ErrorWithStack>());
          expect(stackTrace, same(stack));
        },
        loading: () => fail('unexpected loading'),
      );
    });

    test('honors provided stack trace when mapping failure', () {
      const result = Failure<String, String>(error: 'failure');
      final overrideStack = StackTrace.fromString('custom');

      final asyncValue = result.toAsyncValue(
        mapError: (final error) => 'mapped $error',
        stackTrace: overrideStack,
      );

      asyncValue.when(
        data: (_) => fail('expected error'),
        error: (final error, final stackTrace) {
          expect(error, 'mapped failure');
          expect(stackTrace, same(overrideStack));
        },
        loading: () => fail('unexpected loading'),
      );
    });
  });

  group('AsyncValue.toResult', () {
    test('converts data to Success', () {
      const asyncValue = AsyncData<int>(4);
      final result = asyncValue.toResult<String>(
        (final error, final stackTrace) => '$error',
      );

      expect(result, isA<Success<int, String>>());
      expect(result.value, 4);
    });

    test('converts error to Failure via mapper', () {
      final trace = StackTrace.current;
      final asyncValue = AsyncError<int>(Exception('fail'), trace);

      final result = asyncValue.toResult<String>(
        (final error, final stackTrace) => '${error.toString()} @ $stackTrace',
      );

      expect(result, isA<Failure<int, String>>());
      expect(result.error, contains('Exception: fail'));
      expect(result.error, contains(trace.toString()));
    });

    test('converts loading to Failure with StateError', () {
      const asyncValue = AsyncLoading<int>();
      Object? capturedError;
      StackTrace? capturedStack;

      final result = asyncValue.toResult<String>(
        (final error, final stackTrace) {
          capturedError = error;
          capturedStack = stackTrace;
          return 'still loading';
        },
      );

      expect(result, isA<Failure<int, String>>());
      expect(result.error, 'still loading');
      expect(capturedError, isA<StateError>());
      expect((capturedError! as StateError).message, 'Value is still loading.');
      expect(capturedStack, StackTrace.empty);
    });
  });
}

class _FakeLogSink implements LogSink {
  _FakeLogSink(this.entries);

  final List<LogEntry> entries;

  @override
  void write(final LogEntry entry) {
    entries.add(entry);
  }
}

class _ErrorWithStack extends Error {
  _ErrorWithStack(this._stackTrace);

  final StackTrace _stackTrace;

  @override
  StackTrace? get stackTrace => _stackTrace;
}
