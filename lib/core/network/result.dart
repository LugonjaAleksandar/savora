import 'package:savora/core/network/app_failure.dart';

/// Either a value or an [AppFailure] — callers are forced by the compiler to
/// handle both branches via an exhaustive `switch`.
sealed class Result<T> {
  const Result();

  /// Transforms the success value, passing failures through untouched.
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final T data) => Success<R>(transform(data)),
      Failure<T>(:final AppFailure failure) => Failure<R>(failure),
    };
  }
}

final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final AppFailure failure;

  const Failure(this.failure);
}
