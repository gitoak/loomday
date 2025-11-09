// ignore_for_file: public_member_api_docs

import 'dart:async';

import '../config/env.dart';
import '../features/feature_flags.dart';

/// Represents remote configuration payload returned by the backend.
class RemoteConfigPayload {
  const RemoteConfigPayload({
    this.flagOverrides = const <String, Object?>{},
    this.environmentOverrides,
    this.fetchedAt,
  });

  final FeatureFlagValueMap flagOverrides;
  final EnvironmentOverrides? environmentOverrides;
  final DateTime? fetchedAt;

  bool get isEmpty =>
      flagOverrides.isEmpty && environmentOverrides?.isEmpty != false;
}

/// Client responsible for loading dynamic configuration from a remote service.
abstract class RemoteConfigClient {
  Future<RemoteConfigPayload> fetch();

  Stream<RemoteConfigPayload> get onRefresh;
}

/// Default no-op implementation that always returns empty payloads.
class NoopRemoteConfigClient implements RemoteConfigClient {
  const NoopRemoteConfigClient();

  @override
  Future<RemoteConfigPayload> fetch() async => const RemoteConfigPayload();

  @override
  Stream<RemoteConfigPayload> get onRefresh =>
      const Stream<RemoteConfigPayload>.empty();
}
