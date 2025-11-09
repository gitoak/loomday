// ignore_for_file: public_member_api_docs, prefer_final_parameters

import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../i18n/locale_service.dart';
import '../logging/logger.dart';
import 'config/configuration_snapshot.dart';
import 'config/env.dart';
import 'config/flavor.dart';
import 'features/feature_flags.dart';
import 'storage/local_config_store.dart';
import 'storage/remote_config_client.dart';

part 'providers.g.dart';

// ignore: do_not_use_environment
const String _appFlavorName = String.fromEnvironment(
  'APP_ENV',
  defaultValue: 'dev',
);

/// Provides the build flavor derived from compile-time definitions.
@Riverpod(keepAlive: true)
AppFlavor appFlavor(final Ref ref) => AppFlavorX.parse(_appFlavorName);

/// Provides a shared [SharedPreferences] instance.
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(final Ref ref) {
  return SharedPreferences.getInstance();
}

/// Provides a store that handles local configuration overrides.
@Riverpod(keepAlive: true)
Future<LocalConfigStore> localConfigStore(final Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return LocalConfigStore(prefs);
}

/// Provides the remote configuration client. Override in production to supply a real implementation.
@Riverpod(keepAlive: true)
RemoteConfigClient remoteConfigClient(final Ref ref) =>
    const NoopRemoteConfigClient();

/// Manages layered configuration from build, local, and remote sources.
@Riverpod(keepAlive: true)
class ConfigurationController extends _$ConfigurationController {
  StreamSubscription<RemoteConfigPayload>? _remoteSubscription;

  @override
  Future<ConfigurationSnapshot> build() async {
    final flavor = ref.watch(appFlavorProvider);
    final localStore = await ref.watch(localConfigStoreProvider.future);
    final remoteClient = ref.watch(remoteConfigClientProvider);

    await _remoteSubscription?.cancel();
    final initial = await _resolve(
      flavor: flavor,
      localStore: localStore,
      remoteClient: remoteClient,
    );

    _remoteSubscription = remoteClient.onRefresh.listen((payload) async {
      try {
        final refreshed = await _resolve(
          flavor: ref.read(appFlavorProvider),
          localStore: localStore,
          remoteClient: remoteClient,
          remotePayload: payload,
        );
        state = AsyncValue.data(refreshed);
      } on Object catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    });

    ref.onDispose(() {
      unawaited(_remoteSubscription?.cancel());
      _remoteSubscription = null;
    });

    return initial;
  }

  Future<void> refreshRemote() async {
    final flavor = ref.read(appFlavorProvider);
    final localStore = await ref.read(localConfigStoreProvider.future);
    final remoteClient = ref.read(remoteConfigClientProvider);
    final refreshed = await _resolve(
      flavor: flavor,
      localStore: localStore,
      remoteClient: remoteClient,
    );
    state = AsyncValue.data(refreshed);
  }

  Future<void> reloadLocalOverrides() async {
    await refreshRemote();
  }

  Future<ConfigurationSnapshot> _resolve({
    required final AppFlavor flavor,
    required final LocalConfigStore localStore,
    required final RemoteConfigClient remoteClient,
    final RemoteConfigPayload? remotePayload,
  }) async {
    final baseEnvironment = AppEnvironment.defaultsFor(flavor);

    final localEnvOverrides = localStore.readEnvironmentOverrides();
    final localFlagOverrides = localStore.readFlagOverrides();

    RemoteConfigPayload payload;
    if (remotePayload != null) {
      payload = remotePayload;
    } else {
      try {
        payload = await remoteClient.fetch();
      } on Object catch (_) {
        payload = const RemoteConfigPayload();
      }
    }

    final remoteEnvOverrides = payload.environmentOverrides;
    final remoteFlagOverrides = Map<String, Object?>.from(
      payload.flagOverrides,
    );

    var environment = baseEnvironment;
    if (localEnvOverrides != null && !localEnvOverrides.isEmpty) {
      environment = localEnvOverrides.applyTo(environment);
    }
    if (remoteEnvOverrides != null && !remoteEnvOverrides.isEmpty) {
      environment = remoteEnvOverrides.applyTo(environment);
    }

    final buildLayer = Map<String, Object?>.from(baseEnvironment.flagDefaults);

    final localLayer = <String, Object?>{};
    final localFlagOverridesFromEnv = localEnvOverrides?.flagOverrides;
    if (localFlagOverridesFromEnv != null) {
      localLayer.addAll(localFlagOverridesFromEnv);
    }
    localLayer.addAll(localFlagOverrides);

    final remoteLayer = <String, Object?>{};
    final remoteFlagOverridesFromEnv = remoteEnvOverrides?.flagOverrides;
    if (remoteFlagOverridesFromEnv != null) {
      remoteLayer.addAll(remoteFlagOverridesFromEnv);
    }
    remoteLayer.addAll(remoteFlagOverrides);

    final flagSnapshot = FeatureFlagSnapshot.resolve(
      build: buildLayer,
      local: localLayer,
      remote: remoteLayer,
    );

    environment = environment.copyWith(
      flagDefaults: Map<String, Object?>.from(flagSnapshot.resolvedValues),
    );

    return ConfigurationSnapshot(
      environment: environment,
      flags: flagSnapshot,
      resolvedAt: flagSnapshot.resolvedAt,
      localEnvironmentOverrides: localEnvOverrides,
      remoteEnvironmentOverrides: remoteEnvOverrides,
      localFlagOverrides: Map<String, Object?>.from(localFlagOverrides),
      remoteFlagOverrides: remoteFlagOverrides,
      lastRemoteSync: payload.fetchedAt ?? DateTime.now().toUtc(),
    );
  }
}

/// Provides the resolved configuration snapshot or sensible defaults while loading.
@Riverpod(keepAlive: true)
ConfigurationSnapshot configurationSnapshot(final Ref ref) {
  final flavor = ref.watch(appFlavorProvider);
  final baseEnvironment = AppEnvironment.defaultsFor(flavor);
  final baseFlags = FeatureFlagSnapshot.resolve(
    build: Map<String, Object?>.from(baseEnvironment.flagDefaults),
  );
  final asyncSnapshot = ref.watch(configurationControllerProvider);
  return asyncSnapshot.maybeWhen(
    data: (final snapshot) => snapshot,
    orElse: () => ConfigurationSnapshot(
      environment: baseEnvironment,
      flags: baseFlags,
      resolvedAt: baseFlags.resolvedAt,
    ),
  );
}

/// Provides the active application environment.
@Riverpod(keepAlive: true)
AppEnvironment env(final Ref ref) =>
    ref.watch(configurationSnapshotProvider).environment;

/// Provides the resolved feature flag snapshot.
@Riverpod(keepAlive: true)
FeatureFlagSnapshot featureFlagSnapshot(final Ref ref) =>
    ref.watch(configurationSnapshotProvider).flags;

/// Reads a typed feature flag value.
@riverpod
T featureFlagValue<T>(final Ref ref, final FeatureFlagDefinition<T> flag) {
  final snapshot = ref.watch(featureFlagSnapshotProvider);
  return snapshot.get(flag);
}

/// Provides the shared application logger configured for the active environment.
@Riverpod(keepAlive: true)
AppLogger logger(final Ref ref) {
  final environment = ref.watch(envProvider);
  final isProd =
      environment.flavor == AppFlavor.prod || environment.telemetry.enabled;

  return AppLogger(
    name: 'loomday',
    minLevel: isProd ? LogLevel.info : LogLevel.debug,
    stackTraceLevel: isProd ? LogLevel.error : LogLevel.warning,
    context: <String, Object?>{
      'environment': environment.displayName,
      'flavor': environment.flavor.name,
      'apiBaseUrl': environment.network.apiBaseUrl.toString(),
    },
  );
}

/// Provides the locale service that encapsulates locale change logic.
@Riverpod(keepAlive: true)
LocaleService localeService(final Ref ref) {
  final logger = ref.watch(loggerProvider).scoped('i18n');
  return LocaleService(logger: logger);
}

/// Controls the currently selected locale for the application.
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Locale? build() {
    return ref.read(localeServiceProvider).currentLocale;
  }

  /// The available locale options.
  UnmodifiableListView<Locale?> get options =>
      ref.read(localeServiceProvider).options;

  /// Changes the current locale to the given value.
  Future<void> changeLocale(final Locale? locale) async {
    final service = ref.read(localeServiceProvider);
    await service.changeLocale(locale);
    state = service.currentLocale;
  }
}
