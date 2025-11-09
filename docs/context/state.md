# Loomday State Architecture Plan

## Why This Matters

- Current state patterns are inconsistent and require boilerplate; Riverpod 3.x with hooks and generators reduces code and improves testability.
- Feature-first architecture keeps shared services in `lib/core` and isolates feature logic under `lib/features`, aligning with clean architecture layers.
- A unified state approach enables logging and localization to remain cross-cutting concerns while keeping feature state self-contained.

## Guiding Principles

1. **Feature-first structure**: Presentation → providers → domain → data inside each feature, with shared utilities living in `lib/core`.
2. **Codegen by default**: Prefer `@riverpod` functional providers and `Notifier` classes; legacy `StateNotifierProvider` should only exist temporarily during the migration.
3. **Hooks-friendly UI**: Adopt `HookConsumerWidget` for new screens and refactors to leverage `useEffect`, `useState`, and `ref` access without boilerplate.
4. **Single source of truth**: State lives in providers; widgets read via `ref.watch` or `ref.listen`. No more singleton globals or manually passed dependencies.
5. **Observability-first**: Providers integrate with a shared logger, and localization updates emit structured log events for diagnostics.

## Implementation Roadmap

### 1. Foundations

- **Dependencies**: Add `hooks_riverpod`, `riverpod_annotation`, and `riverpod_generator` to `pubspec.yaml`; ensure `build_runner` is available as a dev dependency.
- **CI/Tooling**: Add `dart run build_runner build --delete-conflicting-outputs` to CI, and document `dart run build_runner watch` for local dev.
- **ProviderScope**: Verify `main.dart` wraps `MyApp` with `ProviderScope`; plan overrides strategy for integration tests.

### 2. Project Structure Alignment

- Audit `lib/` for compliance with feature-first layout. Consolidate shared providers under `lib/core/di/` and domain-specific providers inside each feature folder.
- For each feature, create `presentation/`, `domain/`, `data/` subfolders if missing. Move existing controllers/state objects accordingly.

### 3. Introduce Generated Providers

- Create or update `lib/core/di/providers.dart` (and feature-specific provider files) with `part 'xyz.g.dart';` declarations.
- Convert simple derived values to functional `@riverpod` providers; e.g., environment config, app configuration.
- Replace `StateNotifier` classes with `Notifier` subclasses (`class FooController extends _$FooController`). Keep mutations inside notifier methods and access other providers via `ref`.
- Enable `@Riverpod(keepAlive: true)` for app-wide singletons (logger, env, router); leave others auto-disposed to reclaim resources.

### 4. UI Migration to Hooks

- For new and refactored screens, use `HookConsumerWidget` instead of `StatefulWidget` or `ConsumerWidget` when hook utilities simplify lifecycle or local state.
- Adopt patterns: `final controller = ref.watch(counterProvider);`, `ref.listen` in `useEffect` for one-off side effects, `useState` for ephemeral UI state (text fields, tab indices).
- Provide lightweight documentation/snippets in `docs/context/` for common hooks patterns to support onboarding.

### 5. Logging Integration

- Define `AppLogger` in `lib/core/logging/logger.dart` with debug/info/error helpers (wrapping `debugPrint` or a richer logging backend).
- Expose via `@Riverpod(keepAlive: true) AppLogger logger(LoggerRef ref) => AppLogger();` in `lib/core/di/providers.dart`.
- In provider methods, prefer `ref.read(loggerProvider).d(...)` to log state transitions and errors; avoid `ref.watch` to prevent rebuilds.
- Encourage feature teams to structure log messages (`feature:action:detail`) and capture key metadata (ids, counts). Document expectations in logging guidelines.
- For testing, demonstrate overriding `loggerProvider` with a spy or mock to assert log output.

### 6. Localization State with Riverpod

- Create `LocaleController` notifier:
  ```dart
  @riverpod
  class LocaleController extends _$LocaleController {
    @override
    Locale? build() => null; // system default
    Future<void> changeLocale(Locale? locale) async {
      state = locale;
      // TODO: persist change (SharedPreferences) in follow-up step
      ref.read(loggerProvider).i('locale.change:${locale?.languageCode ?? 'system'}');
    }
  }
  ```
- Update `MyApp` (or `app.dart`) to watch `localeControllerProvider` and pass it to `MaterialApp.router.locale`.
- Build `LanguageSelector` widget inside `features/settings/presentation/` that watches the provider and writes changes via the notifier.
- Plan persistence: integrate `SharedPreferences` (or preferred storage) in a separate task so `LocaleController.build` initializes from saved value.
- Localize dropdown labels via `AppLocalizations` to ensure language names translate correctly.

### 7. Future Feature Patterns

- **New feature checklist**:
  - Define domain logic (entities/use cases) under `feature/domain` with pure Dart.
  - Expose state via `@riverpod` providers in `feature/presentation/providers/` or similar.
  - Keep data-layer clients isolated; expose repositories through providers so Notifiers can read them via `ref`.
  - For async workflows, use `AsyncNotifier` and handle loading/error states centrally.
- **Cross-feature concerns**: Introduce shared providers (e.g., authentication state, analytics) in `core`. Ensure features depend on abstractions from `core` rather than other features directly.
- **Hot reload resilience**: Favor Notifiers over manual `StateNotifierProvider` to benefit from Riverpod's state-preserving hot reload.

### 8. Testing & Quality

- Write unit tests for Notifiers verifying state transitions and logging side effects (via provider overrides).
- Add widget tests for HookConsumerWidget screens, using `ProviderScope(overrides: [...])` to inject fake dependencies.
- Apply `ref.listen` in integration-level tests to assert state flows without UI coupling.

### 9. Rollout Strategy

- Incrementally migrate existing providers feature-by-feature; avoid wholesale rewrites.
- Document migration progress in `docs/context/riverpod-migration.md` (future file) to track remaining tasks and blockers.
- Schedule knowledge sharing sessions; pair program on first few conversions to socialize patterns.
- Monitor build times post-codegen introduction; adjust CI caching if needed.

## Open Questions

- Which features are highest priority for migration (based on current bugs or velocity pain points)?
- Do we need additional observability (e.g., structured logging backend) before scaling log usage?
- Should localization persistence integrate with existing settings storage or introduce a new persistence abstraction?

## References

- Riverpod 3 documentation: https://riverpod.dev/docs
- Code generation guide: https://codewithandrea.com/articles/flutter-riverpod-generator/
- Clean architecture template: https://dev.to/ssoad/flutter-riverpod-clean-architecture-the-ultimate-production-ready-template-for-scalable-apps-gdh
