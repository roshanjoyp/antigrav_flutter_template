/// A structured exception type used across all repository and service boundaries.
///
/// Wraps the original error with a human-readable [message], an optional
/// machine-readable [code] (e.g. `'auth/user-not-found'`), the [originalError]
/// that caused this exception, and its [stackTrace].
///
/// Never throw raw [Exception] or [Error] from a repository — always wrap
/// in [AppException] and return it inside a [Failure].
class AppException implements Exception {
  /// Creates an [AppException] with the given details.
  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  /// A human-readable description of what went wrong.
  final String message;

  /// An optional machine-readable error code for programmatic handling.
  ///
  /// Recommended format: `'domain/error-name'`, e.g. `'auth/user-not-found'`.
  final String? code;

  /// The original error or exception that caused this [AppException], if any.
  final Object? originalError;

  /// The stack trace captured at the point the error occurred, if available.
  final StackTrace? stackTrace;

  @override
  String toString() {
    final buffer = StringBuffer('AppException: $message');
    if (code != null) buffer.write(' (code: $code)');
    if (originalError != null) buffer.write('\nCaused by: $originalError');
    return buffer.toString();
  }
}

// -----------------------------------------------------------------------------

/// Represents the outcome of an operation that can either succeed or fail.
///
/// All repository methods must return `Result<T>` instead of throwing
/// exceptions. This forces call sites to explicitly handle both outcomes
/// and eliminates silent error swallowing.
///
/// Use the factory constructors on [Success] and [Failure] to create
/// instances, or the helper methods [Result.isSuccess], [Result.isFailure],
/// [Result.getOrNull], [Result.getOrElse], and [Result.fold] to consume them.
///
/// Example:
/// ```dart
/// Future<Result<User>> fetchUser(String id) async {
///   try {
///     final user = await _api.getUser(id);
///     return Success(user);
///   } catch (e, st) {
///     return Failure(AppException(
///       message: 'Failed to fetch user',
///       code: 'user/fetch-failed',
///       originalError: e,
///       stackTrace: st,
///     ));
///   }
/// }
///
/// // At the call site:
/// final result = await fetchUser('123');
/// result.fold(
///   onSuccess: (user) => print(user.name),
///   onFailure: (e) => print(e.message),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Returns `true` if this result is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if this result is a [Failure].
  bool get isFailure => this is Failure<T>;

  /// Returns the success value, or `null` if this is a [Failure].
  T? getOrNull() => switch (this) {
        Success<T>(value: final v) => v,
        Failure<T>() => null,
      };

  /// Returns the success value, or [fallback] if this is a [Failure].
  T getOrElse(T fallback) => switch (this) {
        Success<T>(value: final v) => v,
        Failure<T>() => fallback,
      };

  /// Transforms this result by applying one of two functions depending
  /// on whether it is a [Success] or a [Failure].
  ///
  /// Both [onSuccess] and [onFailure] must return the same type [R].
  ///
  /// Example:
  /// ```dart
  /// final label = result.fold(
  ///   onSuccess: (user) => 'Welcome, ${user.name}',
  ///   onFailure: (e) => 'Error: ${e.message}',
  /// );
  /// ```
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(AppException exception) onFailure,
  }) =>
      switch (this) {
        Success<T>(value: final v) => onSuccess(v),
        Failure<T>(exception: final e) => onFailure(e),
      };

  /// Transforms the success value using [transform], leaving
  /// any [Failure] untouched.
  ///
  /// Useful for mapping repository results to different types
  /// without unwrapping manually.
  ///
  /// Example:
  /// ```dart
  /// final result = await fetchUser('123');
  /// final nameResult = result.mapSuccess((user) => user.name);
  /// ```
  Result<R> mapSuccess<R>(R Function(T value) transform) =>
      switch (this) {
        Success<T>(value: final v) => Success(transform(v)),
        Failure<T>(exception: final e) => Failure(e),
      };
}

// -----------------------------------------------------------------------------

/// The successful outcome of a [Result].
///
/// Carries the [value] produced by the operation.
final class Success<T> extends Result<T> {
  /// Creates a [Success] result carrying [value].
  const Success(this.value);

  /// The value returned by the successful operation.
  final T value;
}

// -----------------------------------------------------------------------------

/// The failed outcome of a [Result].
///
/// Carries an [AppException] describing what went wrong.
final class Failure<T> extends Result<T> {
  /// Creates a [Failure] result carrying [exception].
  const Failure(this.exception);

  /// The exception describing why the operation failed.
  final AppException exception;
}
