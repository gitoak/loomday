// ignore_for_file: public_member_api_docs

/// A typed result that models either a success value or an error value.
///
/// This uses a simple factory-based API (Option B) to keep ergonomics light
/// while still enabling mapping and chaining helpers.
sealed class Result<T, E> {
  const Result._();

  /// Creates a successful result.
  factory Result.success({required final T value}) = Success<T, E>;

  /// Creates a failed result.
  factory Result.failure({required final E error}) = Failure<T, E>;

  /// True when this is [Success].
  bool get isSuccess => this is Success<T, E>;

  /// True when this is [Failure].
  bool get isFailure => this is Failure<T, E>;

  /// Unwraps the success value or throws a [StateError] if this is a failure.
  T get value {
    switch (this) {
      case Success<T, E>(value: final value):
        return value;
      case Failure<T, E>():
        throw StateError('Tried to read value from a failure result.');
    }
  }

  /// Unwraps the error value or throws a [StateError] if this is a success.
  E get error {
    switch (this) {
      case Failure<T, E>(error: final error):
        return error;
      case Success<T, E>():
        throw StateError('Tried to read error from a success result.');
    }
  }

  /// Applies a mapper to the success value, preserving the error otherwise.
  Result<R, E> map<R>(final R Function(T value) mapper) {
    switch (this) {
      case Success<T, E>(value: final value):
        return Result<R, E>.success(value: mapper(value));
      case Failure<T, E>(error: final error):
        return Result<R, E>.failure(error: error);
    }
  }

  /// Applies a mapper to the error value, preserving the success otherwise.
  Result<T, F> mapError<F>(final F Function(E error) mapper) {
    switch (this) {
      case Success<T, E>(value: final value):
        return Result<T, F>.success(value: value);
      case Failure<T, E>(error: final error):
        return Result<T, F>.failure(error: mapper(error));
    }
  }

  /// Chains another result-producing function when this is a success.
  Result<R, E> andThen<R>(final Result<R, E> Function(T value) next) {
    switch (this) {
      case Success<T, E>(value: final value):
        return next(value);
      case Failure<T, E>(error: final error):
        return Result<R, E>.failure(error: error);
    }
  }

  /// Folds the result into a single value.
  R fold<R>({
    required final R Function(T value) onSuccess,
    required final R Function(E error) onFailure,
  }) {
    switch (this) {
      case Success<T, E>(value: final value):
        return onSuccess(value);
      case Failure<T, E>(error: final error):
        return onFailure(error);
    }
  }
}

/// Successful result containing [value].
final class Success<T, E> extends Result<T, E> {
  const Success({required this.value}) : super._();

  final T value;
}

/// Failed result containing [error].
final class Failure<T, E> extends Result<T, E> {
  const Failure({required this.error}) : super._();

  final E error;
}