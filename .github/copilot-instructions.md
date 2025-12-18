# Copilot Instructions for loomday

These notes help AI coding agents work productively in this Flutter repo by encoding the actual patterns and workflows used here. Prefer the examples and files referenced below over generic Flutter advice.

## Tech Stack & Architecture
- Flutter app with `hooks_riverpod` v3 + codegen and `go_router`.
- App entry wraps `MyApp` in `ProviderScope` [lib/main.dart](../lib/main.dart); `MyApp` wires providers, router, theme, and i18n [lib/app.dart](../lib/app.dart).
- DI and app-wide providers live in [lib/core/di/providers.dart](../lib/core/di/providers.dart) (uses `part 'providers.g.dart'` → run codegen after edits).
- Routing uses a single `ShellRoute` with bottom nav; routes enumerated in [lib/core/routing/routes.dart](../lib/core/routing/routes.dart) and configured in [lib/core/routing/app_router.dart](../lib/core/routing/app_router.dart).
- Theming is centralized in `appThemeProvider` and helpers under [lib/core/theme/](../lib/core/theme/).
- Localization via Flutter gen-l10n with deferred loading; ARB files in [lib/l10n/](../lib/l10n/) and delegate in [lib/l10n/app_localizations.dart](../lib/l10n/app_localizations.dart).
- Configuration system layers build → local → remote:
  - Build defaults by flavor in [lib/core/di/config/env.dart](../lib/core/di/config/env.dart) and [lib/core/di/config/flavor.dart](../lib/core/di/config/flavor.dart)
  - Local overrides persisted via `SharedPreferences` in [lib/core/di/storage/local_config_store.dart](../lib/core/di/storage/local_config_store.dart)
  - Remote config via `RemoteConfigClient` (noop by default) in [lib/core/di/storage/remote_config_client.dart](../lib/core/di/storage/remote_config_client.dart)
  - Resolved snapshot in [lib/core/di/config/configuration_snapshot.dart](../lib/core/di/config/configuration_snapshot.dart)
- Feature flags are strongly typed in [lib/core/di/features/feature_flags.dart](../lib/core/di/features/feature_flags.dart); resolved via `ConfigurationController` in providers.

## Flavors & Environments
- Flavors: `dev`, `stage`, `prod`, `demo`, `e2e`; default is `dev`.
- Select via `--dart-define=APP_ENV=<flavor>`; used by `appFlavorProvider` and downstream env/flags.

## Developer Workflows
- Run app (default dev):
  - `flutter run`
  - With flavor: `flutter run --dart-define=APP_ENV=stage`
- Riverpod codegen (required after modifying annotations in `providers.dart`):
  - Build once: `dart run build_runner build --delete-conflicting-outputs`
  - Watch: `dart run build_runner watch --delete-conflicting-outputs`
- Localization (after editing ARB files):
  - `flutter gen-l10n`
- Linting/format/fixes (enforced by pre-commit hooks, see [hooks/README.md](../hooks/README.md)):
  - `dart format .`
  - `dart analyze --fatal-infos`
  - `dart fix --dry-run` (and `dart fix --apply`)

## Conventions & Patterns
- Widgets:
  - Use `HookConsumerWidget` for screens needing hooks + providers.
  - App bootstraps providers and router in [lib/app.dart](../lib/app.dart) using:
    - `appRouterProvider`, `envProvider`, `appThemeProvider`, `localeControllerProvider`, `loggerProvider`.
- Routing:
  - Define new enum values in [routes.dart](../lib/core/routing/routes.dart) and add matching `GoRoute` in [app_router.dart](../lib/core/routing/app_router.dart).
  - Bottom nav is derived from `AppRoute.navIndex`; update both enum and router when adding tabs.
- Feature flags:
  - Declare in `FeatureFlagRegistry` [feature_flags.dart](../lib/core/di/features/feature_flags.dart).
  - Read values with `ref.watch(featureFlagValueProvider(FeatureFlagRegistry.enableTelemetryV2))`.
  - Build defaults come from the active `AppEnvironment`; local/remote overrides merge on top.
- Configuration:
  - Use `configurationSnapshotProvider` for the resolved snapshot; access `envProvider` for the active `AppEnvironment`.
  - `RemoteConfigClient` is a provider (`remoteConfigClientProvider`) designed for override in non-prod builds.
- Localization:
  - Add keys to ARB files in [lib/l10n](../lib/l10n) and re-run `flutter gen-l10n`.
  - Change locale at runtime via `ref.read(localeControllerProvider.notifier).changeLocale(Locale('de'))` (see [language_selector.dart](../lib/features/settings/presentation/widgets/language_selector.dart)).
- Logging:
  - Use `loggerProvider` to get an `AppLogger`, and scope it via `.scoped('domain')`. Prod lowers verbosity (see provider wiring in [providers.dart](../lib/core/di/providers.dart)).
- Project structure:
  - Shared infra in [lib/core](../lib/core); features under [lib/features](../lib/features) with `presentation/` for screens/widgets.

## Non-Obvious Details
- Strict analysis rules are enabled in [analysis_options.yaml](../analysis_options.yaml): `strict-casts`, `unawaited_futures`, `discarded_futures`, `require_trailing_commas`, etc. Respect these to avoid CI/hook failures.
- gen-l10n uses deferred loading per [l10n.yaml](../l10n.yaml); keep imports consistent with generated files.

## Example: Adding a Screen with a Flag
1) Declare a flag in [feature_flags.dart](../lib/core/di/features/feature_flags.dart) and set build defaults per flavor in [env.dart](../lib/core/di/config/env.dart).
2) Create screen in a feature module (e.g., [lib/features/home/presentation/home_screen.dart](../lib/features/home/presentation/home_screen.dart)) using `HookConsumerWidget` if state is needed.
3) Add a route in [routes.dart](../lib/core/routing/routes.dart) and wire it in [app_router.dart](../lib/core/routing/app_router.dart).
4) Read the flag where needed: `final enabled = ref.watch(featureFlagValueProvider(FeatureFlagRegistry.newWeekView));`
5) If you edited annotations/providers, run build runner.

## New Feature Template (Screen + Router)
Use this as a starting point when adding a feature screen.

1) Add enum route (must be in `AppRoute` or `MainScaffold` will throw on unknown paths):

```dart
// lib/core/routing/routes.dart
enum AppRoute {
  home('/', 0),
  settings('/settings', 1),
  feature('/feature', 0); // reuse navIndex of the owning tab (e.g., Home)
  // If adding a new tab, give it the next index and update BottomNavigationBar.
  const AppRoute(this.path, this.navIndex);
  final String path;
  final int navIndex;
  // keep helpers as-is
}
```

2) Wire route:

```dart
// lib/core/routing/app_router.dart (inside ShellRoute.routes)
GoRoute(
  path: AppRoute.feature.path,
  builder: (ctx, state) => const FeatureScreen(),
),
```

3) Create the screen:

```dart
// lib/features/feature/presentation/feature_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/di/providers.dart';
import '../../../core/di/features/feature_flags.dart';

class FeatureScreen extends HookConsumerWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final enabled = ref.watch(
      featureFlagValueProvider(FeatureFlagRegistry.newWeekView),
    );
    final logger = ref.read(loggerProvider).scoped('feature');
    logger.d('FeatureScreen opened', context: {'flag.newWeekView': enabled});

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(enabled ? Icons.check_circle : Icons.block, size: 64),
            const SizedBox(height: 12),
            Text(enabled ? 'Feature ON' : 'Feature OFF'),
          ],
        ),
      ),
    );
  }
}
```

4) Add localized strings if needed in [lib/l10n/app_en.arb](../lib/l10n/app_en.arb) and [lib/l10n/app_de.arb](../lib/l10n/app_de.arb), then regenerate: `flutter gen-l10n`.

5) If this should be a new bottom tab:
- Add a `BottomNavigationBarItem` in `MainScaffold` matching the new route label and icon.
- Ensure the enum entry has a unique `navIndex` matching the new tab’s position.

6) Run and verify

```bash
flutter run --dart-define=APP_ENV=dev
```

## Quick Links
- Entry: [lib/main.dart](../lib/main.dart), [lib/app.dart](../lib/app.dart)
- DI/providers: [lib/core/di/providers.dart](../lib/core/di/providers.dart)
- Router: [lib/core/routing/app_router.dart](../lib/core/routing/app_router.dart)
- Theme: [lib/core/theme/app_theme.dart](../lib/core/theme/app_theme.dart)
- i18n: [lib/l10n/](../lib/l10n), [lib/core/i18n/locale_service.dart](../lib/core/i18n/locale_service.dart)
- Flags/Config: [lib/core/di/features/feature_flags.dart](../lib/core/di/features/feature_flags.dart), [lib/core/di/config/env.dart](../lib/core/di/config/env.dart)
- Hooks: [hooks/README.md](../hooks/README.md)
