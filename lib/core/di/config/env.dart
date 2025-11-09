// ignore_for_file: public_member_api_docs, prefer_final_parameters

import 'dart:collection';

import '../features/feature_flags.dart';
import 'flavor.dart';

/// Describes the payment backend the app should communicate with.
enum PaymentEnvironment { sandbox, live }

/// Captures retry semantics for network calls.
class RetryPolicy {
  const RetryPolicy({
    required this.maxAttempts,
    required this.backoffBase,
    required this.maxBackoff,
  });

  final int maxAttempts;
  final Duration backoffBase;
  final Duration maxBackoff;

  RetryPolicy copyWith({
    int? maxAttempts,
    Duration? backoffBase,
    Duration? maxBackoff,
  }) {
    return RetryPolicy(
      maxAttempts: maxAttempts ?? this.maxAttempts,
      backoffBase: backoffBase ?? this.backoffBase,
      maxBackoff: maxBackoff ?? this.maxBackoff,
    );
  }
}

/// Network-related settings for a given environment.
class NetworkConfig {
  const NetworkConfig({
    required this.apiBaseUrl,
    required this.requestTimeout,
    required this.connectTimeout,
    required this.retryPolicy,
  });

  final Uri apiBaseUrl;
  final Duration requestTimeout;
  final Duration connectTimeout;
  final RetryPolicy retryPolicy;

  NetworkConfig copyWith({
    Uri? apiBaseUrl,
    Duration? requestTimeout,
    Duration? connectTimeout,
    RetryPolicy? retryPolicy,
  }) {
    return NetworkConfig(
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      requestTimeout: requestTimeout ?? this.requestTimeout,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      retryPolicy: retryPolicy ?? this.retryPolicy,
    );
  }
}

/// Telemetry and analytics controls per environment.
class TelemetryConfig {
  const TelemetryConfig({
    required this.enabled,
    required this.crashReportingEnabled,
  });

  final bool enabled;
  final bool crashReportingEnabled;

  TelemetryConfig copyWith({bool? enabled, bool? crashReportingEnabled}) {
    return TelemetryConfig(
      enabled: enabled ?? this.enabled,
      crashReportingEnabled:
          crashReportingEnabled ?? this.crashReportingEnabled,
    );
  }
}

/// Represents a full set of configuration knobs for a build flavor.
class AppEnvironment {
  const AppEnvironment({
    required this.flavor,
    required this.displayName,
    required NetworkConfig network,
    required this.paymentEnvironment,
    required TelemetryConfig telemetry,
    required FeatureFlagValueMap flagDefaults,
  }) : _network = network,
       _telemetry = telemetry,
       _flagDefaults = flagDefaults;

  final AppFlavor flavor;
  final String displayName;
  final PaymentEnvironment paymentEnvironment;
  final NetworkConfig _network;
  final TelemetryConfig _telemetry;
  final FeatureFlagValueMap _flagDefaults;

  NetworkConfig get network => _network;
  TelemetryConfig get telemetry => _telemetry;
  FeatureFlagValueMap get flagDefaults =>
      UnmodifiableMapView<String, Object?>(_flagDefaults);

  AppEnvironment copyWith({
    NetworkConfig? network,
    PaymentEnvironment? paymentEnvironment,
    TelemetryConfig? telemetry,
    FeatureFlagValueMap? flagDefaults,
    String? displayName,
  }) {
    return AppEnvironment(
      flavor: flavor,
      displayName: displayName ?? this.displayName,
      network: network ?? _network,
      paymentEnvironment: paymentEnvironment ?? this.paymentEnvironment,
      telemetry: telemetry ?? _telemetry,
      flagDefaults: flagDefaults ?? _flagDefaults,
    );
  }

  static AppEnvironment defaultsFor(final AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return AppEnvironment(
          flavor: flavor,
          displayName: 'Development',
          network: NetworkConfig(
            apiBaseUrl: Uri.parse('https://dev-api.loomday.app'),
            requestTimeout: const Duration(seconds: 30),
            connectTimeout: const Duration(seconds: 10),
            retryPolicy: const RetryPolicy(
              maxAttempts: 3,
              backoffBase: Duration(milliseconds: 250),
              maxBackoff: Duration(seconds: 5),
            ),
          ),
          paymentEnvironment: PaymentEnvironment.sandbox,
          telemetry: const TelemetryConfig(
            enabled: false,
            crashReportingEnabled: false,
          ),
          flagDefaults: <String, Object?>{
            FeatureFlagRegistry.newWeekView.id: false,
            FeatureFlagRegistry.enableTelemetryV2.id: false,
            FeatureFlagRegistry.syncBatchSize.id: 10,
          },
        );
      case AppFlavor.stage:
        return AppEnvironment(
          flavor: flavor,
          displayName: 'Staging',
          network: NetworkConfig(
            apiBaseUrl: Uri.parse('https://stage-api.loomday.app'),
            requestTimeout: const Duration(seconds: 25),
            connectTimeout: const Duration(seconds: 8),
            retryPolicy: const RetryPolicy(
              maxAttempts: 4,
              backoffBase: Duration(milliseconds: 300),
              maxBackoff: Duration(seconds: 6),
            ),
          ),
          paymentEnvironment: PaymentEnvironment.sandbox,
          telemetry: const TelemetryConfig(
            enabled: true,
            crashReportingEnabled: true,
          ),
          flagDefaults: <String, Object?>{
            FeatureFlagRegistry.newWeekView.id: true,
            FeatureFlagRegistry.enableTelemetryV2.id: true,
            FeatureFlagRegistry.syncBatchSize.id: 15,
          },
        );
      case AppFlavor.prod:
        return AppEnvironment(
          flavor: flavor,
          displayName: 'Production',
          network: NetworkConfig(
            apiBaseUrl: Uri.parse('https://api.loomday.app'),
            requestTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 6),
            retryPolicy: const RetryPolicy(
              maxAttempts: 5,
              backoffBase: Duration(milliseconds: 350),
              maxBackoff: Duration(seconds: 8),
            ),
          ),
          paymentEnvironment: PaymentEnvironment.live,
          telemetry: const TelemetryConfig(
            enabled: true,
            crashReportingEnabled: true,
          ),
          flagDefaults: <String, Object?>{
            FeatureFlagRegistry.newWeekView.id: true,
            FeatureFlagRegistry.enableTelemetryV2.id: true,
            FeatureFlagRegistry.syncBatchSize.id: 20,
          },
        );
      case AppFlavor.demo:
        return AppEnvironment(
          flavor: flavor,
          displayName: 'Demo',
          network: NetworkConfig(
            apiBaseUrl: Uri.parse('https://demo-api.loomday.app'),
            requestTimeout: const Duration(seconds: 30),
            connectTimeout: const Duration(seconds: 8),
            retryPolicy: const RetryPolicy(
              maxAttempts: 3,
              backoffBase: Duration(milliseconds: 250),
              maxBackoff: Duration(seconds: 5),
            ),
          ),
          paymentEnvironment: PaymentEnvironment.sandbox,
          telemetry: const TelemetryConfig(
            enabled: false,
            crashReportingEnabled: false,
          ),
          flagDefaults: <String, Object?>{
            FeatureFlagRegistry.newWeekView.id: true,
            FeatureFlagRegistry.enableTelemetryV2.id: false,
            FeatureFlagRegistry.syncBatchSize.id: 10,
          },
        );
      case AppFlavor.e2e:
        return AppEnvironment(
          flavor: flavor,
          displayName: 'E2E',
          network: NetworkConfig(
            apiBaseUrl: Uri.parse('https://e2e-api.loomday.app'),
            requestTimeout: const Duration(seconds: 15),
            connectTimeout: const Duration(seconds: 5),
            retryPolicy: const RetryPolicy(
              maxAttempts: 2,
              backoffBase: Duration(milliseconds: 150),
              maxBackoff: Duration(seconds: 3),
            ),
          ),
          paymentEnvironment: PaymentEnvironment.sandbox,
          telemetry: const TelemetryConfig(
            enabled: false,
            crashReportingEnabled: false,
          ),
          flagDefaults: <String, Object?>{
            FeatureFlagRegistry.newWeekView.id: false,
            FeatureFlagRegistry.enableTelemetryV2.id: false,
            FeatureFlagRegistry.syncBatchSize.id: 5,
          },
        );
    }
  }
}

/// Overrides applied on top of the base environment, e.g. sourced from local files.
class EnvironmentOverrides {
  const EnvironmentOverrides({
    this.apiBaseUrl,
    this.paymentEnvironment,
    this.telemetryEnabled,
    this.crashReportingEnabled,
    this.requestTimeout,
    this.connectTimeout,
    this.retryMaxAttempts,
    this.retryBackoffBase,
    this.retryMaxBackoff,
    FeatureFlagValueMap? flagOverrides,
  }) : _flagOverrides = flagOverrides;

  final Uri? apiBaseUrl;
  final PaymentEnvironment? paymentEnvironment;
  final bool? telemetryEnabled;
  final bool? crashReportingEnabled;
  final Duration? requestTimeout;
  final Duration? connectTimeout;
  final int? retryMaxAttempts;
  final Duration? retryBackoffBase;
  final Duration? retryMaxBackoff;
  final FeatureFlagValueMap? _flagOverrides;

  FeatureFlagValueMap? get flagOverrides {
    final overrides = _flagOverrides;
    if (overrides == null) {
      return null;
    }
    return UnmodifiableMapView<String, Object?>(overrides);
  }

  bool get isEmpty {
    final overrides = _flagOverrides;
    return apiBaseUrl == null &&
        paymentEnvironment == null &&
        telemetryEnabled == null &&
        crashReportingEnabled == null &&
        requestTimeout == null &&
        connectTimeout == null &&
        retryMaxAttempts == null &&
        retryBackoffBase == null &&
        retryMaxBackoff == null &&
        (overrides == null || overrides.isEmpty);
  }

  EnvironmentOverrides merge(final EnvironmentOverrides? other) {
    if (other == null) {
      return this;
    }
    final mergedFlags = <String, Object?>{};
    final selfOverrides = _flagOverrides;
    if (selfOverrides != null) {
      mergedFlags.addAll(selfOverrides);
    }
    final otherOverrides = other._flagOverrides;
    if (otherOverrides != null) {
      mergedFlags.addAll(otherOverrides);
    }
    return EnvironmentOverrides(
      apiBaseUrl: other.apiBaseUrl ?? apiBaseUrl,
      paymentEnvironment: other.paymentEnvironment ?? paymentEnvironment,
      telemetryEnabled: other.telemetryEnabled ?? telemetryEnabled,
      crashReportingEnabled:
          other.crashReportingEnabled ?? crashReportingEnabled,
      requestTimeout: other.requestTimeout ?? requestTimeout,
      connectTimeout: other.connectTimeout ?? connectTimeout,
      retryMaxAttempts: other.retryMaxAttempts ?? retryMaxAttempts,
      retryBackoffBase: other.retryBackoffBase ?? retryBackoffBase,
      retryMaxBackoff: other.retryMaxBackoff ?? retryMaxBackoff,
      flagOverrides: mergedFlags.isEmpty ? null : mergedFlags,
    );
  }

  factory EnvironmentOverrides.fromJson(final Map<String, Object?> json) {
    Duration? parseDuration(final Object? value) {
      if (value is int) {
        return Duration(milliseconds: value);
      }
      if (value is num) {
        return Duration(milliseconds: value.toInt());
      }
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return Duration(milliseconds: parsed);
        }
      }
      return null;
    }

    Uri? parseUri(final Object? value) {
      if (value is String && value.isNotEmpty) {
        return Uri.parse(value);
      }
      return null;
    }

    PaymentEnvironment? parsePayment(final Object? value) {
      if (value is String) {
        switch (value.toLowerCase().trim()) {
          case 'live':
            return PaymentEnvironment.live;
          case 'sandbox':
            return PaymentEnvironment.sandbox;
        }
      }
      return null;
    }

    FeatureFlagValueMap? parseFlags(final Object? value) {
      if (value is Map) {
        return <String, Object?>{
          for (final entry in value.entries)
            if (entry.key is String) entry.key as String: entry.value,
        };
      }
      return null;
    }

    return EnvironmentOverrides(
      apiBaseUrl: parseUri(json['apiBaseUrl']),
      paymentEnvironment: parsePayment(json['paymentEnvironment']),
      telemetryEnabled: json['telemetryEnabled'] as bool?,
      crashReportingEnabled: json['crashReportingEnabled'] as bool?,
      requestTimeout: parseDuration(json['requestTimeoutMs']),
      connectTimeout: parseDuration(json['connectTimeoutMs']),
      retryMaxAttempts: (json['retryMaxAttempts'] as num?)?.toInt(),
      retryBackoffBase: parseDuration(json['retryBackoffBaseMs']),
      retryMaxBackoff: parseDuration(json['retryMaxBackoffMs']),
      flagOverrides: parseFlags(json['flagOverrides']),
    );
  }

  Map<String, Object?> toJson() {
    final overrides = _flagOverrides;
    return <String, Object?>{
      if (apiBaseUrl != null) 'apiBaseUrl': apiBaseUrl.toString(),
      if (paymentEnvironment != null)
        'paymentEnvironment': paymentEnvironment!.name,
      if (telemetryEnabled != null) 'telemetryEnabled': telemetryEnabled,
      if (crashReportingEnabled != null)
        'crashReportingEnabled': crashReportingEnabled,
      if (requestTimeout != null)
        'requestTimeoutMs': requestTimeout!.inMilliseconds,
      if (connectTimeout != null)
        'connectTimeoutMs': connectTimeout!.inMilliseconds,
      if (retryMaxAttempts != null) 'retryMaxAttempts': retryMaxAttempts,
      if (retryBackoffBase != null)
        'retryBackoffBaseMs': retryBackoffBase!.inMilliseconds,
      if (retryMaxBackoff != null)
        'retryMaxBackoffMs': retryMaxBackoff!.inMilliseconds,
      if (overrides != null && overrides.isNotEmpty)
        'flagOverrides': Map<String, Object?>.from(overrides),
    };
  }

  AppEnvironment applyTo(final AppEnvironment environment) {
    var network = environment.network;
    if (apiBaseUrl != null ||
        requestTimeout != null ||
        connectTimeout != null ||
        retryMaxAttempts != null ||
        retryBackoffBase != null ||
        retryMaxBackoff != null) {
      final retryPolicy = network.retryPolicy.copyWith(
        maxAttempts: retryMaxAttempts,
        backoffBase: retryBackoffBase,
        maxBackoff: retryMaxBackoff,
      );
      network = network.copyWith(
        apiBaseUrl: apiBaseUrl ?? network.apiBaseUrl,
        requestTimeout: requestTimeout ?? network.requestTimeout,
        connectTimeout: connectTimeout ?? network.connectTimeout,
        retryPolicy: retryPolicy,
      );
    }

    var telemetry = environment.telemetry;
    if (telemetryEnabled != null || crashReportingEnabled != null) {
      telemetry = telemetry.copyWith(
        enabled: telemetryEnabled,
        crashReportingEnabled: crashReportingEnabled,
      );
    }

    final mergedFlags = Map<String, Object?>.from(environment.flagDefaults);
    final overrides = _flagOverrides;
    if (overrides != null) {
      mergedFlags.addAll(overrides);
    }

    return environment.copyWith(
      network: network,
      paymentEnvironment: paymentEnvironment ?? environment.paymentEnvironment,
      telemetry: telemetry,
      flagDefaults: mergedFlags,
    );
  }
}
