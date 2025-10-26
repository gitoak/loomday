import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'app.dart';
import 'core/di/env.dart';
import 'core/di/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      overrides: [envProvider.overrideWithValue(AppEnvironment.development)],
      child: const MyApp(),
    ),
  );
}
