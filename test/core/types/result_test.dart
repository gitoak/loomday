import 'package:flutter_test/flutter_test.dart';

import '../../../lib/core/types/result.dart';

void main() {
  group('Result', () {
    test('reports success and failure states', () {
      const success = Success<int, String>(value: 1);
      const failure = Failure<int, String>(error: 'oops');

      expect(success.isSuccess, isTrue);
      expect(success.isFailure, isFalse);

      expect(failure.isSuccess, isFalse);
      expect(failure.isFailure, isTrue);
    });

    test('unwrap throws when accessing mismatched state', () {
      const success = Success<int, String>(value: 1);
      const failure = Failure<int, String>(error: 'oops');

      expect(() => failure.value, throwsStateError);
      expect(() => success.error, throwsStateError);
    });

    test('map transforms success values and preserves failures', () {
      const success = Success<int, String>(value: 2);
      const failure = Failure<int, String>(error: 'err');
      var mapped = success.map((final value) => value * 2);

      expect(mapped, isA<Success<int, String>>());
      expect(mapped.value, 4);

      var mapperCalled = false;
      mapped = failure.map((final _) {
        mapperCalled = true;
        return 0;
      });

      expect(mapperCalled, isFalse);
      expect(mapped, isA<Failure<int, String>>());
      expect(mapped.error, 'err');
    });

    test('mapError transforms failures and preserves successes', () {
      const success = Success<int, String>(value: 3);
      const failure = Failure<int, String>(error: 'err');
      var mapped = success.mapError((final error) => error.length);

      expect(mapped, isA<Success<int, int>>());
      expect(mapped.value, 3);

      var mapperCalled = false;
      mapped = failure.mapError((final error) {
        mapperCalled = true;
        return error.length;
      });

      expect(mapperCalled, isTrue);
      expect(mapped, isA<Failure<int, int>>());
      expect(mapped.error, 3);
    });

    test('andThen chains on success and short-circuits on failure', () {
      const success = Success<int, String>(value: 1);
      const failure = Failure<int, String>(error: 'err');

      final chainedSuccess = success.andThen<int>(
        (final value) => Result<int, String>.success(value + 1),
      );

      expect(chainedSuccess, isA<Success<int, String>>());
      expect(chainedSuccess.value, 2);

      var nextCalled = false;
      final chainedFailure = failure.andThen<int>((final _) {
        nextCalled = true;
        return const Success<int, String>(value: 0);
      });

      expect(nextCalled, isFalse);
      expect(chainedFailure, isA<Failure<int, String>>());
      expect(chainedFailure.error, 'err');
    });

    test('fold reduces to a single value for both states', () {
      const success = Success<int, String>(value: 5);
      const failure = Failure<int, String>(error: 'err');

      final fromSuccess = success.fold(
        onSuccess: (final value) => value + 1,
        onFailure: (final _) => -1,
      );

      final fromFailure = failure.fold(
        onSuccess: (final value) => value + 1,
        onFailure: (final _) => -1,
      );

      expect(fromSuccess, 6);
      expect(fromFailure, -1);
    });
  });
}
