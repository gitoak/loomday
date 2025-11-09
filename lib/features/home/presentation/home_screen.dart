import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Home Screen
class HomeScreen extends StatelessWidget {
  /// Constructor
  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.home, size: 96),
            const SizedBox(height: 16),
            Text(
              t.homeTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
