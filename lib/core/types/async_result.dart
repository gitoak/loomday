// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:riverpod/riverpod.dart';

import '../logging/logger.dart';
import 'result.dart';

/// Wraps a throwing function into a [Result].
///
/// Pass an [AppLogger] to log failures; stays silent when logger is null.
Future<Result<T, E>> guard<T, E>(
  final FutureOr<T> Function() run,
  final E Function(Object error, StackTrace stackTrace) onError, {
  final AppLogger? logger,
}) async {
  try {
    final value = await run();
    return Result<T, E>.success(value: value);
  } on Object catch (error, stackTrace) {
    logger?.error('result.guard', error: error, stackTrace: stackTrace);
    return Result<T, E>.failure(error: onError(error, stackTrace));
  }
}

extension FutureResultX<T, E> on Future<Result<T, E>> {
  Future<Result<R, E>> map<R>(final R Function(T value) mapper) async {
    final result = await this;
    return result.map(mapper);
  }

  Future<Result<T, F>> mapError<F>(final F Function(E error) mapper) async {
    final result = await this;
    return result.mapError(mapper);
  }

  Future<Result<R, E>> andThen<R>(
    final FutureOr<Result<R, E>> Function(T value) next,
  ) async {
    final result = await this;
    switch (result) {
      case Success<T, E>(value: final value):
        return next(value);
      case Failure<T, E>(error: final error):
        return Result<R, E>.failure(error: error);
    }
  }
}

extension ResultAsyncValueX<T, E> on Result<T, E> {
  AsyncValue<T> toAsyncValue({
    required final Object Function(E error) mapError,
    final StackTrace? stackTrace,
  }) {
    switch (this) {
      case Success<T, E>(value: final value):
        return AsyncValue<T>.data(value);
      case Failure<T, E>(error: final error):
        final mapped = mapError(error);
        final resolvedStackTrace =
            stackTrace ?? _stackFromError(mapped) ?? StackTrace.empty;
        return AsyncValue<T>.error(mapped, resolvedStackTrace);
    }
  }
}

extension AsyncValueResultX<T> on AsyncValue<T> {
  Result<T, E> toResult<E>(
    final E Function(Object error, StackTrace? stackTrace) mapError,
  ) {
    switch (this) {
      case AsyncData<T>(value: final value):
        return Result<T, E>.success(value: value);
      case AsyncError<T>(error: final error, stackTrace: final stackTrace):
        return Result<T, E>.failure(error: mapError(error, stackTrace));
      case AsyncLoading<T>():
        return Result<T, E>.failure(
          error: mapError(
            StateError('Value is still loading.'),
            StackTrace.empty,
          ),
        );
    }
  }
}

StackTrace? _stackFromError(final Object error) {
  if (error is Error) {
    return error.stackTrace;
  }
  return null;
}