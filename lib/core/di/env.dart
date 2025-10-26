/// Defines different application environments such as development and production.
class AppEnvironment {
  /// The name of the environment.
  final String name;

  /// The base URL for API requests.
  final String apiBaseUrl;

  /// Flag to enable or disable analytics.
  final bool enableAnalytics;

  /// Constructor for [AppEnvironment].
  const AppEnvironment({
    required this.name,
    required this.apiBaseUrl,
    this.enableAnalytics = false,
  });

  /// Development environment configuration.
  static const development = AppEnvironment(
    name: 'Development',
    apiBaseUrl: '',
  );

  /// Production environment configuration.
  static const production = AppEnvironment(
    name: 'Production',
    apiBaseUrl: '',
    enableAnalytics: true,
  );
}
