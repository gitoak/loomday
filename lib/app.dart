import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/di/providers.dart';
import 'core/routing/app_router.dart';

/// Main App Widget
class MyApp extends ConsumerWidget {
  /// Constructor
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final env = ref.watch(envProvider);

    ref.read(loggerProvider).d('Booting app with env: ${env.name}');

    return MaterialApp.router(
      debugShowCheckedModeBanner: env.name != 'prod',
      routerConfig: router,
    );
  }
}
