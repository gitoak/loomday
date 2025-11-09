import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../l10n/app_localizations.dart';

/// AppRouter-Provider
final appRouterProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (final context, final state, final child) {
          return MainScaffold(child: child);
        },
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
      ),
    ],
  );
});

/// Main Scaffold with bottom navigation
class MainScaffold extends StatelessWidget {
  /// Constructor
  const MainScaffold({super.key, required this.child});

  /// The child widget
  final Widget child;

  /// Builds the widget
  @override
  Widget build(final BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = location == '/' ? 0 : 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedIndex == 0 ? t.appTitle : t.settingsTitle),
        centerTitle: true,
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: t.homeTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: t.settingsTitle,
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (final index) {
          if (index == 0) {
            context.go('/');
          } else if (index == 1) {
            context.go('/settings');
          }
        },
      ),
    );
  }
}
