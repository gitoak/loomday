// ignore_for_file: public_member_api_docs, prefer_final_parameters

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../config/env.dart';
import '../features/feature_flags.dart';

/// Persists developer and QA overrides on the local device.
class LocalConfigStore {
  LocalConfigStore(this._preferences);

  final SharedPreferences _preferences;

  static const String _envKey = 'loomday.config.environment';
  static const String _flagsKey = 'loomday.config.flags';

  EnvironmentOverrides? readEnvironmentOverrides() {
    final raw = _preferences.getString(_envKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, Object?>) {
        return EnvironmentOverrides.fromJson(decoded);
      }
      if (decoded is Map<String, dynamic>) {
        return EnvironmentOverrides.fromJson(decoded);
      }
    } on Object catch (_) {
      // Intentionally swallow parse errors; invalid overrides should not break the app.
    }
    return null;
  }

  FeatureFlagValueMap readFlagOverrides() {
    final raw = _preferences.getString(_flagsKey);
    if (raw == null || raw.isEmpty) {
      return <String, Object?>{};
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, Object?>) {
        return Map<String, Object?>.from(decoded);
      }
      if (decoded is Map<String, dynamic>) {
        return Map<String, Object?>.from(decoded);
      }
    } on Object catch (_) {
      // Ignore parsing issues and fall back to defaults.
    }
    return <String, Object?>{};
  }

  Future<void> writeEnvironmentOverrides(
    final EnvironmentOverrides overrides,
  ) async {
    if (overrides.isEmpty) {
      await _preferences.remove(_envKey);
      return;
    }
    final payload = jsonEncode(overrides.toJson());
    await _preferences.setString(_envKey, payload);
  }

  Future<void> writeFlagOverrides(final FeatureFlagValueMap values) async {
    if (values.isEmpty) {
      await _preferences.remove(_flagsKey);
      return;
    }
    final payload = jsonEncode(values);
    await _preferences.setString(_flagsKey, payload);
  }

  Future<void> clear() async {
    await _preferences.remove(_envKey);
    await _preferences.remove(_flagsKey);
  }
}
