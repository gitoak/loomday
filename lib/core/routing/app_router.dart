import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

/// AppRouter-Provider
final appRouterProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (final ctx, final state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (final ctx, final state) => const SettingsScreen(),
      ),
    ],
  );
});
