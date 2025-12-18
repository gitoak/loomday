# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
# Run the app (default dev flavor)
flutter run

# Run with specific flavor
flutter run --dart-define=APP_ENV=dev
flutter run --dart-define=APP_ENV=stage
flutter run --dart-define=APP_ENV=prod

# Code generation (required after modifying @riverpod providers)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
dart run build_runner watch --delete-conflicting-outputs

# Generate localization files (after editing .arb files)
flutter gen-l10n

# Format code
dart format .

# Static analysis
dart analyze --fatal-infos

# Check for auto-fixable issues
dart fix --dry-run

# Apply auto-fixes
dart fix --apply
```

## Git Hooks

Install hooks after cloning: `./hooks/install.sh` (Linux/macOS) or `.\hooks\install.ps1` (Windows)

Pre-commit hook runs `dart format`, `dart analyze --fatal-infos`, and `dart fix --dry-run`.

## Architecture

### State Management: Riverpod 3 with Hooks

- Uses `hooks_riverpod` with code generation (`riverpod_annotation`, `riverpod_generator`)
- All providers are in `*.g.dart` files - run `build_runner` after changes
- App wrapped in `ProviderScope` in `main.dart`
- Use `HookConsumerWidget` for new screens; access state via `ref.watch`/`ref.read`

### Project Structure

```
lib/
├── core/                    # Shared infrastructure
│   ├── di/                  # Dependency injection & providers
│   │   ├── config/          # Flavor, environment, configuration snapshot
│   │   ├── features/        # Feature flags system
│   │   ├── storage/         # Local/remote config stores
│   │   └── providers.dart   # Central provider definitions
│   ├── i18n/                # Locale service & controller
│   ├── logging/             # AppLogger
│   ├── routing/             # GoRouter setup
│   └── theme/               # Colors, typography, spacing, shadows
├── features/                # Feature modules
│   └── [feature]/
│       └── presentation/    # Screens and widgets
├── l10n/                    # Generated localizations
└── app.dart                 # MyApp widget (MaterialApp.router)
```

### Configuration System

Three-layer configuration (build → local → remote):
- **Build layer**: Compile-time defaults from `AppEnvironment.defaultsFor(flavor)`
- **Local layer**: SharedPreferences overrides via `LocalConfigStore`
- **Remote layer**: Remote config via `RemoteConfigClient` (noop by default)

App flavors: `dev`, `stage`, `prod`, `demo`, `e2e` - set via `--dart-define=APP_ENV=<flavor>`

### Localization

- ARB files in `lib/l10n/` (template: `app_en.arb`)
- Supported locales: English (`en`), German (`de`)
- Access via `AppLocalizations.of(context)` or import generated classes
- Locale state managed by `LocaleController` provider with persistence

### Key Providers

- `envProvider` - Current `AppEnvironment`
- `loggerProvider` - Scoped `AppLogger` instance
- `localeControllerProvider` - Locale state management
- `featureFlagSnapshotProvider` - Feature flags
- `appRouterProvider` - GoRouter instance
- `appThemeProvider` - Light/dark theme set

## Code Style

Strict analysis enabled (`analysis_options.yaml`):
- `strict-casts` and `strict-raw-types` enabled
- Public API documentation required (`public_member_api_docs`)
- `prefer_final_parameters` enforced
- `unawaited_futures` and `discarded_futures` are errors
- `require_trailing_commas` for better diffs
