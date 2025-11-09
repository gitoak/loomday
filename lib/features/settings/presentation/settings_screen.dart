import 'package:flutter/material.dart';

import 'widgets/language_selector.dart';

/// Settings Screen
class SettingsScreen extends StatelessWidget {
  /// Constructor
  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline;
    final borderColor = outline.withAlpha(Color.getAlphaFromOpacity(0.3));

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: borderColor),
            ),
            elevation: 0,
            child: const LanguageSelector(),
          ),
        ],
      ),
    );
  }
}
