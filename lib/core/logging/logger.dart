/// Simple logger class
class AppLogger {
  /// Log debug message
  void d(final Object message) {
    // ignore: avoid_print
    print('[D] $message');
  }

  /// Log error message
  void e(final Object message, [final Object? err, final StackTrace? st]) {
    // ignore: avoid_print
    print('[E] $message ${err ?? ''} ${st ?? ''}');
  }
}
