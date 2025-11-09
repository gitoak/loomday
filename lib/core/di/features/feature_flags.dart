// ignore_for_file: public_member_api_docs, prefer_final_parameters

import 'dart:collection';

/// Identifies the priority order for feature flag overrides.
enum FeatureFlagLayer { buildDefaults, localOverrides, remoteOverrides }

/// Type alias for raw flag values keyed by their identifier.
typedef FeatureFlagValueMap = Map<String, Object?>;

/// Describes a strongly typed feature flag.
class FeatureFlagDefinition<T> {
  const FeatureFlagDefinition({
    required this.id,
    required this.description,
    required this.defaultValue,
    this.exposureLoggingKey,
    this.allowRemoteOverride = true,
  });

  /// Unique identifier for the flag.
  final String id;

  /// Human-readable description of the flag purpose.
  final String description;

  /// Default value baked into the app binary.
  final T defaultValue;

  /// Optional key used by observability tooling to group experiments.
  final String? exposureLoggingKey;

  /// Indicates if the flag may be controlled via remote config.
  final bool allowRemoteOverride;
}

/// Registry that holds all compile-time flag definitions.
class FeatureFlagRegistry {
  FeatureFlagRegistry._();

  static const FeatureFlagDefinition<bool> newWeekView =
      FeatureFlagDefinition<bool>(
        id: 'calendar.new_week_view',
        description:
            'Enables the new calendar week layout for a limited cohort.',
        defaultValue: false,
        exposureLoggingKey: 'calendar_experiment',
      );

  static const FeatureFlagDefinition<bool> enableTelemetryV2 =
      FeatureFlagDefinition<bool>(
        id: 'telemetry.v2_pipeline',
        description: 'Switch telemetry events to the v2 ingestion pipeline.',
        defaultValue: false,
      );

  static const FeatureFlagDefinition<int> syncBatchSize =
      FeatureFlagDefinition<int>(
        id: 'sync.batch_size',
        description: 'Controls how many items are synced per batch.',
        defaultValue: 20,
      );

  static const Iterable<FeatureFlagDefinition<dynamic>> values =
      <FeatureFlagDefinition<dynamic>>[
        newWeekView,
        enableTelemetryV2,
        syncBatchSize,
      ];

  static Map<String, FeatureFlagDefinition<dynamic>> get _byId =>
      _cachedById ??= {for (final flag in values) flag.id: flag};
  static Map<String, FeatureFlagDefinition<dynamic>>? _cachedById;

  /// Returns the registered definition for [id] if available.
  static FeatureFlagDefinition<dynamic>? lookup(final String id) => _byId[id];
}

/// Captures the resolved state of feature flags after applying overrides.
class FeatureFlagSnapshot {
  FeatureFlagSnapshot._({
    required Map<String, Object?> resolved,
    required Map<String, Object?> build,
    required Map<String, Object?> local,
    required Map<String, Object?> remote,
    required this.resolvedAt,
    required List<String> unknownKeys,
  }) : resolvedValues = UnmodifiableMapView<String, Object?>(resolved),
       buildLayer = UnmodifiableMapView<String, Object?>(build),
       localLayer = UnmodifiableMapView<String, Object?>(local),
       remoteLayer = UnmodifiableMapView<String, Object?>(remote),
       unknownFlagIds = List.unmodifiable(unknownKeys);

  /// All values after applying overrides in priority order.
  final UnmodifiableMapView<String, Object?> resolvedValues;

  /// Build-time defaults baked into the app.
  final UnmodifiableMapView<String, Object?> buildLayer;

  /// Locally overridden values (e.g. developer overrides on the device).
  final UnmodifiableMapView<String, Object?> localLayer;

  /// Remote config overrides.
  final UnmodifiableMapView<String, Object?> remoteLayer;

  /// Timestamp when the snapshot was produced.
  final DateTime resolvedAt;

  /// Flags that were present in overrides but unknown to the registry.
  final List<String> unknownFlagIds;

  /// Reads a typed flag value with fallback to the compile-time default.
  T get<T>(final FeatureFlagDefinition<T> flag) {
    final value = resolvedValues[flag.id];
    if (value is T) {
      return value;
    }
    return flag.defaultValue;
  }

  /// Builds a new snapshot by applying overrides in the defined order.
  factory FeatureFlagSnapshot.resolve({
    required FeatureFlagValueMap build,
    FeatureFlagValueMap? local,
    FeatureFlagValueMap? remote,
    DateTime? resolvedAt,
  }) {
    final merged = <String, Object?>{};
    final buildCopy = Map<String, Object?>.from(build);
    final localCopy = Map<String, Object?>.from(local ?? const {});
    final remoteCopy = Map<String, Object?>.from(remote ?? const {});

    void apply(final FeatureFlagValueMap source) {
      for (final entry in source.entries) {
        merged[entry.key] = entry.value;
      }
    }

    apply(buildCopy);
    apply(localCopy);
    apply(remoteCopy);

    final unknown = <String>[];
    for (final key in merged.keys) {
      if (FeatureFlagRegistry.lookup(key) == null) {
        unknown.add(key);
      }
    }

    return FeatureFlagSnapshot._(
      resolved: merged,
      build: buildCopy,
      local: localCopy,
      remote: remoteCopy,
      resolvedAt: resolvedAt ?? DateTime.now().toUtc(),
      unknownKeys: unknown,
    );
  }

  /// Serializes the snapshot for debugging or persistence.
  Map<String, Object?> toJson() => <String, Object?>{
    'resolvedAt': resolvedAt.toIso8601String(),
    'resolved': Map<String, Object?>.from(resolvedValues),
    'build': Map<String, Object?>.from(buildLayer),
    'local': Map<String, Object?>.from(localLayer),
    'remote': Map<String, Object?>.from(remoteLayer),
    if (unknownFlagIds.isNotEmpty) 'unknown': List<String>.from(unknownFlagIds),
  };
}
