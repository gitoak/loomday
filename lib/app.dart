import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/di/providers.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

/// Main App Widget
class MyApp extends ConsumerWidget {
  /// Constructor
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final env = ref.watch(envProvider);
    final themeSet = ref.watch(appThemeProvider);

    ref.read(loggerProvider).d('Booting app with env: ${env.name}');

    return MaterialApp.router(
      debugShowCheckedModeBanner: env.name != 'prod',
      routerConfig: router,
      theme: themeSet.light,
      darkTheme: themeSet.dark,
      locale: AppLocalizations.supportedLocales.last,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
