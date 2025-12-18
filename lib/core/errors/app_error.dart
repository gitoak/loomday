// ignore_for_file: public_member_api_docs

/// Base error type for all application domains.
abstract base class AppError implements Exception {
  const AppError({
    required this.code,
    required this.message,
    this.cause,
    this.stackTrace,
  });

  /// Stable machine-readable code (e.g., `network.timeout`).
  final String code;

  /// Human-readable message suitable for logging.
  final String message;

  /// Optional underlying error that triggered this error.
  final Object? cause;

  /// Captured stack trace for diagnostics (Option B: include stack trace).
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppError($code): $message';
}