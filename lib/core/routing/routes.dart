/// Defines the app's navigation routes and their properties.
enum AppRoute {
  /// Home screen route.
  home('/', 0),

  /// Settings screen route.
  settings('/settings', 1);

  const AppRoute(this.path, this.navIndex);

  /// The route path used in GoRouter.
  final String path;

  /// The index used in bottom navigation bar.
  final int navIndex;

  /// Gets the AppRoute from a path string.
  static AppRoute? fromPath(final String path) {
    return AppRoute.values.firstWhere(
      (final route) => route.path == path,
      orElse: () => throw ArgumentError('Unknown route path: $path'),
    );
  }

  /// Gets the AppRoute from a navigation index.
  static AppRoute fromNavIndex(final int index) {
    return AppRoute.values.firstWhere(
      (final route) => route.navIndex == index,
      orElse: () => throw ArgumentError('Unknown nav index: $index'),
    );
  }
}
