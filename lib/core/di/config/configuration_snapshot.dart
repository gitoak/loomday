// ignore_for_file: public_member_api_docs, prefer_final_parameters

import '../features/feature_flags.dart';
import 'env.dart';

/// Holds the resolved configuration after applying build, local, and remote sources.
class ConfigurationSnapshot {
  const ConfigurationSnapshot({
    required this.environment,
    required this.flags,
    required this.resolvedAt,
    this.localEnvironmentOverrides,
    this.remoteEnvironmentOverrides,
    this.localFlagOverrides = const <String, Object?>{},
    this.remoteFlagOverrides = const <String, Object?>{},
    this.lastRemoteSync,
  });

  final AppEnvironment environment;
  final FeatureFlagSnapshot flags;
  final DateTime resolvedAt;
  final EnvironmentOverrides? localEnvironmentOverrides;
  final EnvironmentOverrides? remoteEnvironmentOverrides;
  final FeatureFlagValueMap localFlagOverrides;
  final FeatureFlagValueMap remoteFlagOverrides;
  final DateTime? lastRemoteSync;

  bool get hasLocalOverrides =>
      (localEnvironmentOverrides != null &&
          !localEnvironmentOverrides!.isEmpty) ||
      localFlagOverrides.isNotEmpty;

  bool get hasRemoteOverrides =>
      (remoteEnvironmentOverrides != null &&
          !remoteEnvironmentOverrides!.isEmpty) ||
      remoteFlagOverrides.isNotEmpty;

  ConfigurationSnapshot copyWith({
    AppEnvironment? environment,
    FeatureFlagSnapshot? flags,
    DateTime? resolvedAt,
    EnvironmentOverrides? localEnvironmentOverrides,
    EnvironmentOverrides? remoteEnvironmentOverrides,
    FeatureFlagValueMap? localFlagOverrides,
    FeatureFlagValueMap? remoteFlagOverrides,
    DateTime? lastRemoteSync,
  }) {
    return ConfigurationSnapshot(
      environment: environment ?? this.environment,
      flags: flags ?? this.flags,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      localEnvironmentOverrides:
          localEnvironmentOverrides ?? this.localEnvironmentOverrides,
      remoteEnvironmentOverrides:
          remoteEnvironmentOverrides ?? this.remoteEnvironmentOverrides,
      localFlagOverrides: localFlagOverrides ?? this.localFlagOverrides,
      remoteFlagOverrides: remoteFlagOverrides ?? this.remoteFlagOverrides,
      lastRemoteSync: lastRemoteSync ?? this.lastRemoteSync,
    );
  }
}
