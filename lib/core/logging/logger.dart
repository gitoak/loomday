import 'dart:collection';

import 'package:flutter/foundation.dart';

/// Supported log severity levels ordered by importance.
enum LogLevel {
  /// Debug level.
  debug,

  /// Info level.
  info,

  /// Warning level.
  warning,

  /// Error level.
  error,

  /// Critical level.
  critical,
}

/// Provides comparison methods for log levels.
extension LogLevelComparison on LogLevel {
  /// Returns a short uppercase label (e.g. `DBG`).
  String get label {
    switch (this) {
      case LogLevel.debug:
        return 'DBG';
      case LogLevel.info:
        return 'INF';
      case LogLevel.warning:
        return 'WRN';
      case LogLevel.error:
        return 'ERR';
      case LogLevel.critical:
        return 'CRT';
    }
  }

  /// Whether this level should be logged given a minimum threshold.
  bool allows(final LogLevel threshold) => index >= threshold.index;
}

/// Immutable log entry carrying structured metadata.
class LogEntry {
  /// Creates a log entry.
  LogEntry({
    required this.level,
    required this.message,
    required this.timestamp,
    required this.loggerName,
    final Map<String, Object?>? context,
    this.error,
    this.stackTrace,
  }) : context = UnmodifiableMapView(context ?? const <String, Object?>{});

  /// The log level.
  final LogLevel level;

  /// The log message.
  final String message;

  /// The timestamp of the log entry.
  final DateTime timestamp;

  /// The name of the logger.
  final String loggerName;

  /// Additional context information.
  final Map<String, Object?> context;

  /// The error object, if any.
  final Object? error;

  /// The stack trace, if any.
  final StackTrace? stackTrace;

  /// Formats the entry for console output.
  String format({final bool includeTimestamp = true}) {
    final buffer = StringBuffer();

    if (includeTimestamp) {
      buffer
        ..write(timestamp.toIso8601String())
        ..write(' ');
    }

    buffer
      ..write('[')
      ..write(level.label)
      ..write('] ')
      ..write(loggerName)
      ..write(' - ')
      ..write(message);

    if (context.isNotEmpty) {
      buffer.write(' {');
      var first = true;
      context.forEach((final key, final value) {
        if (!first) {
          buffer.write(', ');
        }
        first = false;
        buffer
          ..write(key)
          ..write('=')
          ..write(value);
      });
      buffer.write('}');
    }

    if (error != null) {
      buffer
        ..write(' | error=')
        ..write(error);
    }

    if (stackTrace != null) {
      buffer
        ..write('\n')
        ..write(stackTrace);
    }

    return buffer.toString();
  }
}

/// Output target for log entries.
abstract class LogSink {
  /// Writes a log entry to the sink.
  void write(final LogEntry entry);
}

/// Default console sink using Flutter's debugPrint with batching support.
class ConsoleLogSink implements LogSink {
  /// Creates a console log sink.
  const ConsoleLogSink({this.includeTimestamp = true});

  /// Whether to include timestamps in the output.
  final bool includeTimestamp;

  @override
  void write(final LogEntry entry) {
    debugPrint(entry.format(includeTimestamp: includeTimestamp));
  }
}

/// Shared logger with level filtering, structured context, and scoped children.
class AppLogger {
  /// Creates an app logger.
  AppLogger({
    this.name = 'app',
    this.minLevel = LogLevel.debug,
    final LogLevel? stackTraceLevel,
    final List<LogSink>? sinks,
    final Map<String, Object?>? context,
  }) : stackTraceLevel = stackTraceLevel ?? LogLevel.error,
       sinks = List.unmodifiable(sinks ?? const <LogSink>[ConsoleLogSink()]),
       baseContext = Map.unmodifiable(context ?? const <String, Object?>{});

  /// The name of the logger.
  final String name;

  /// The minimum log level.
  final LogLevel minLevel;

  /// The level at which to include stack traces.
  final LogLevel stackTraceLevel;

  /// The list of log sinks.
  final List<LogSink> sinks;

  /// The base context.
  final Map<String, Object?> baseContext;

  /// Creates a child logger that inherits sinks and context.
  AppLogger scoped(final String scope, {final Map<String, Object?>? context}) {
    return AppLogger(
      name: '$name.$scope',
      minLevel: minLevel,
      stackTraceLevel: stackTraceLevel,
      sinks: sinks,
      context: {...baseContext, if (context != null) ...context},
    );
  }

  /// Emits a debug message.
  void debug(final String message, {final Map<String, Object?>? context}) {
    _log(LogLevel.debug, message, context: context);
  }

  /// Emits an info message.
  void info(final String message, {final Map<String, Object?>? context}) {
    _log(LogLevel.info, message, context: context);
  }

  /// Emits a warning message.
  void warning(
    final String message, {
    final Object? error,
    final Map<String, Object?>? context,
  }) {
    _log(LogLevel.warning, message, error: error, context: context);
  }

  /// Emits an error message.
  void error(
    final String message, {
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  }) {
    _log(
      LogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// Emits a critical failure message.
  void critical(
    final String message, {
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  }) {
    _log(
      LogLevel.critical,
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// Shorthand for [debug].
  void d(final String message, {final Map<String, Object?>? context}) =>
      debug(message, context: context);

  /// Shorthand for [info].
  void i(final String message, {final Map<String, Object?>? context}) =>
      info(message, context: context);

  /// Shorthand for [warning].
  void w(
    final String message, {
    final Object? error,
    final Map<String, Object?>? context,
  }) => warning(message, error: error, context: context);

  /// Shorthand for [error].
  void e(
    final String message, {
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  }) => this.error(
    message,
    error: error,
    stackTrace: stackTrace,
    context: context,
  );

  void _log(
    final LogLevel level,
    final String message, {
    final Map<String, Object?>? context,
    final Object? error,
    StackTrace? stackTrace,
  }) {
    if (!level.allows(minLevel)) {
      return;
    }

    final combinedContext = <String, Object?>{
      ...baseContext,
      if (context != null && context.isNotEmpty) ...context,
    };

    stackTrace ??= _resolveStackTrace(level, error);

    final entry = LogEntry(
      level: level,
      message: message,
      timestamp: DateTime.now().toUtc(),
      loggerName: name,
      context: combinedContext,
      error: error,
      stackTrace: stackTrace,
    );

    for (final sink in sinks) {
      sink.write(entry);
    }
  }

  StackTrace? _resolveStackTrace(final LogLevel level, final Object? err) {
    if (err is Error && err.stackTrace != null) {
      return err.stackTrace;
    }

    if (level.index >= stackTraceLevel.index) {
      return StackTrace.current;
    }

    return null;
  }
}
