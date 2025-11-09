// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the build flavor derived from compile-time definitions.

@ProviderFor(appFlavor)
const appFlavorProvider = AppFlavorProvider._();

/// Provides the build flavor derived from compile-time definitions.

final class AppFlavorProvider
    extends $FunctionalProvider<AppFlavor, AppFlavor, AppFlavor>
    with $Provider<AppFlavor> {
  /// Provides the build flavor derived from compile-time definitions.
  const AppFlavorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appFlavorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appFlavorHash();

  @$internal
  @override
  $ProviderElement<AppFlavor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppFlavor create(Ref ref) {
    return appFlavor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppFlavor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppFlavor>(value),
    );
  }
}

String _$appFlavorHash() => r'4d11b400cc23e7d4abef40e2c630a054be882824';

/// Provides a shared [SharedPreferences] instance.

@ProviderFor(sharedPreferences)
const sharedPreferencesProvider = SharedPreferencesProvider._();

/// Provides a shared [SharedPreferences] instance.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// Provides a shared [SharedPreferences] instance.
  const SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'c91af20d23d473d310b1b04b2b693d2ef4d93c8b';

/// Provides a store that handles local configuration overrides.

@ProviderFor(localConfigStore)
const localConfigStoreProvider = LocalConfigStoreProvider._();

/// Provides a store that handles local configuration overrides.

final class LocalConfigStoreProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocalConfigStore>,
          LocalConfigStore,
          FutureOr<LocalConfigStore>
        >
    with $FutureModifier<LocalConfigStore>, $FutureProvider<LocalConfigStore> {
  /// Provides a store that handles local configuration overrides.
  const LocalConfigStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localConfigStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localConfigStoreHash();

  @$internal
  @override
  $FutureProviderElement<LocalConfigStore> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocalConfigStore> create(Ref ref) {
    return localConfigStore(ref);
  }
}

String _$localConfigStoreHash() => r'7de7bed1565fe0306a62919f2c23a642f8f962da';

/// Provides the remote configuration client. Override in production to supply a real implementation.

@ProviderFor(remoteConfigClient)
const remoteConfigClientProvider = RemoteConfigClientProvider._();

/// Provides the remote configuration client. Override in production to supply a real implementation.

final class RemoteConfigClientProvider
    extends
        $FunctionalProvider<
          RemoteConfigClient,
          RemoteConfigClient,
          RemoteConfigClient
        >
    with $Provider<RemoteConfigClient> {
  /// Provides the remote configuration client. Override in production to supply a real implementation.
  const RemoteConfigClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteConfigClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteConfigClientHash();

  @$internal
  @override
  $ProviderElement<RemoteConfigClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RemoteConfigClient create(Ref ref) {
    return remoteConfigClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteConfigClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteConfigClient>(value),
    );
  }
}

String _$remoteConfigClientHash() =>
    r'fe0355322e0e9b5482d18dcd30e34cc98b04f6fe';

/// Manages layered configuration from build, local, and remote sources.

@ProviderFor(ConfigurationController)
const configurationControllerProvider = ConfigurationControllerProvider._();

/// Manages layered configuration from build, local, and remote sources.
final class ConfigurationControllerProvider
    extends
        $AsyncNotifierProvider<ConfigurationController, ConfigurationSnapshot> {
  /// Manages layered configuration from build, local, and remote sources.
  const ConfigurationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configurationControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$configurationControllerHash();

  @$internal
  @override
  ConfigurationController create() => ConfigurationController();
}

String _$configurationControllerHash() =>
    r'387f1d19fb747fbf8f4d8728e2587fd83888c3fb';

/// Manages layered configuration from build, local, and remote sources.

abstract class _$ConfigurationController
    extends $AsyncNotifier<ConfigurationSnapshot> {
  FutureOr<ConfigurationSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<ConfigurationSnapshot>, ConfigurationSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ConfigurationSnapshot>,
                ConfigurationSnapshot
              >,
              AsyncValue<ConfigurationSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provides the resolved configuration snapshot or sensible defaults while loading.

@ProviderFor(configurationSnapshot)
const configurationSnapshotProvider = ConfigurationSnapshotProvider._();

/// Provides the resolved configuration snapshot or sensible defaults while loading.

final class ConfigurationSnapshotProvider
    extends
        $FunctionalProvider<
          ConfigurationSnapshot,
          ConfigurationSnapshot,
          ConfigurationSnapshot
        >
    with $Provider<ConfigurationSnapshot> {
  /// Provides the resolved configuration snapshot or sensible defaults while loading.
  const ConfigurationSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configurationSnapshotProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$configurationSnapshotHash();

  @$internal
  @override
  $ProviderElement<ConfigurationSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConfigurationSnapshot create(Ref ref) {
    return configurationSnapshot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConfigurationSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConfigurationSnapshot>(value),
    );
  }
}

String _$configurationSnapshotHash() =>
    r'331993a846bb60d34204332e2b27836043c990b6';

/// Provides the active application environment.

@ProviderFor(env)
const envProvider = EnvProvider._();

/// Provides the active application environment.

final class EnvProvider
    extends $FunctionalProvider<AppEnvironment, AppEnvironment, AppEnvironment>
    with $Provider<AppEnvironment> {
  /// Provides the active application environment.
  const EnvProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'envProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$envHash();

  @$internal
  @override
  $ProviderElement<AppEnvironment> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppEnvironment create(Ref ref) {
    return env(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppEnvironment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppEnvironment>(value),
    );
  }
}

String _$envHash() => r'584a8ac95f02b7d642d50db39bd8b3c8001681b7';

/// Provides the resolved feature flag snapshot.

@ProviderFor(featureFlagSnapshot)
const featureFlagSnapshotProvider = FeatureFlagSnapshotProvider._();

/// Provides the resolved feature flag snapshot.

final class FeatureFlagSnapshotProvider
    extends
        $FunctionalProvider<
          FeatureFlagSnapshot,
          FeatureFlagSnapshot,
          FeatureFlagSnapshot
        >
    with $Provider<FeatureFlagSnapshot> {
  /// Provides the resolved feature flag snapshot.
  const FeatureFlagSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureFlagSnapshotProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureFlagSnapshotHash();

  @$internal
  @override
  $ProviderElement<FeatureFlagSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FeatureFlagSnapshot create(Ref ref) {
    return featureFlagSnapshot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeatureFlagSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeatureFlagSnapshot>(value),
    );
  }
}

String _$featureFlagSnapshotHash() =>
    r'09f260c0aabf3b01352980e8061d70ca868d4213';

/// Reads a typed feature flag value.

@ProviderFor(featureFlagValue)
const featureFlagValueProvider = FeatureFlagValueFamily._();

/// Reads a typed feature flag value.

final class FeatureFlagValueProvider<T> extends $FunctionalProvider<T, T, T>
    with $Provider<T> {
  /// Reads a typed feature flag value.
  const FeatureFlagValueProvider._({
    required FeatureFlagValueFamily super.from,
    required FeatureFlagDefinition<T> super.argument,
  }) : super(
         retry: null,
         name: r'featureFlagValueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$featureFlagValueHash();

  @override
  String toString() {
    return r'featureFlagValueProvider'
        '<${T}>'
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<T> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  T create(Ref ref) {
    final argument = this.argument as FeatureFlagDefinition<T>;
    return featureFlagValue<T>(ref, argument);
  }

  $R _captureGenerics<$R>($R Function<T>() cb) {
    return cb<T>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(T value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<T>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FeatureFlagValueProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$featureFlagValueHash() => r'74b33e09c0e00302fc0904488e9e19ad61a02c57';

/// Reads a typed feature flag value.

final class FeatureFlagValueFamily extends $Family {
  const FeatureFlagValueFamily._()
    : super(
        retry: null,
        name: r'featureFlagValueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Reads a typed feature flag value.

  FeatureFlagValueProvider<T> call<T>(FeatureFlagDefinition<T> flag) =>
      FeatureFlagValueProvider<T>._(argument: flag, from: this);

  @override
  String toString() => r'featureFlagValueProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    T Function<T>(Ref ref, FeatureFlagDefinition<T> args) create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as FeatureFlagValueProvider;
      return provider._captureGenerics(<T>() {
        provider as FeatureFlagValueProvider<T>;
        final argument = provider.argument as FeatureFlagDefinition<T>;
        return provider
            .$view(create: (ref) => create(ref, argument))
            .$createElement(pointer);
      });
    },
  );
}

/// Provides the shared application logger configured for the active environment.

@ProviderFor(logger)
const loggerProvider = LoggerProvider._();

/// Provides the shared application logger configured for the active environment.

final class LoggerProvider
    extends $FunctionalProvider<AppLogger, AppLogger, AppLogger>
    with $Provider<AppLogger> {
  /// Provides the shared application logger configured for the active environment.
  const LoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loggerHash();

  @$internal
  @override
  $ProviderElement<AppLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLogger create(Ref ref) {
    return logger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLogger>(value),
    );
  }
}

String _$loggerHash() => r'd4d270be2d555e8359b9a05ae077d7ad078fcf9b';

/// Provides the locale service that encapsulates locale change logic.

@ProviderFor(localeService)
const localeServiceProvider = LocaleServiceProvider._();

/// Provides the locale service that encapsulates locale change logic.

final class LocaleServiceProvider
    extends $FunctionalProvider<LocaleService, LocaleService, LocaleService>
    with $Provider<LocaleService> {
  /// Provides the locale service that encapsulates locale change logic.
  const LocaleServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeServiceHash();

  @$internal
  @override
  $ProviderElement<LocaleService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocaleService create(Ref ref) {
    return localeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocaleService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocaleService>(value),
    );
  }
}

String _$localeServiceHash() => r'09dc3b38bfc7e28649c9977b4a4bb95907bd93b5';

/// Controls the currently selected locale for the application.

@ProviderFor(LocaleController)
const localeControllerProvider = LocaleControllerProvider._();

/// Controls the currently selected locale for the application.
final class LocaleControllerProvider
    extends $NotifierProvider<LocaleController, Locale?> {
  /// Controls the currently selected locale for the application.
  const LocaleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeControllerHash();

  @$internal
  @override
  LocaleController create() => LocaleController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$localeControllerHash() => r'9a15762cae595824fb37810aaedfd77ad6dd4f8d';

/// Controls the currently selected locale for the application.

abstract class _$LocaleController extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
