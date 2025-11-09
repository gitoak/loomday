import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/supported_languages.dart';
import '../../../../core/di/providers.dart';
import '../../../../l10n/app_localizations.dart';

/// Settings tile allowing the user to switch the app language at runtime.
class LanguageSelector extends HookConsumerWidget {
  /// Creates a language selector widget.
  const LanguageSelector({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);
    final controller = ref.read(localeControllerProvider.notifier);
    final options = controller.options;
    final currentLabel = _labelFor(locale, loc);

    Future<void> showPicker() async {
      final selection = await showModalBottomSheet<_LocaleSelection>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (final sheetContext) =>
            _LanguagePickerSheet(options: options, current: locale, loc: loc),
      );

      if (selection != null && selection.locale != locale) {
        unawaited(controller.changeLocale(selection.locale));
      }
    }

    return ListTile(
      onTap: showPicker,
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      leading: const _TileIcon(icon: Icons.translate),
      title: Text(loc.settingsLanguage),
      trailing: _SelectionPill(label: currentLabel),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(final BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: colors.onSecondaryContainer),
    );
  }
}

class _SelectionPill extends StatelessWidget {
  const _SelectionPill({required this.label});

  final String label;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet({
    required this.options,
    required this.current,
    required this.loc,
  });

  final List<Locale?> options;
  final Locale? current;
  final AppLocalizations loc;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  loc.settingsLanguage,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
            for (var index = 0; index < options.length; index++) ...[
              _LanguageOptionTile(
                label: _labelFor(options[index], loc),
                selected: options[index] == current,
                onTap: () =>
                    Navigator.of(context).pop(_LocaleSelection(options[index])),
              ),
              if (index < options.length - 1) const Divider(height: 0),
            ],
          ],
        ),
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ListTile(
      onTap: onTap,
      selected: selected,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: selected ? colors.primary : null,
          fontWeight: selected ? FontWeight.w600 : null,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_rounded, color: colors.primary)
          : const SizedBox(width: 24, height: 24),
    );
  }
}

class _LocaleSelection {
  const _LocaleSelection(this.locale);

  final Locale? locale;
}

String _labelFor(final Locale? option, final AppLocalizations loc) {
  if (option == null) {
    return loc.settingsLanguageSystem;
  }

  final language = SupportedLanguage.fromLanguageCode(option.languageCode);
  switch (language) {
    case SupportedLanguage.en:
      return loc.settingsLanguageEnglish;
    case SupportedLanguage.de:
      return loc.settingsLanguageGerman;
  }
}
