import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'colors.dart';
import 'radius.dart';
import 'shadows.dart';
import 'spacing.dart';
import 'typography.dart';

/// AppThemeSet holds both light and dark ThemeData instances.
class AppThemeSet {
  /// Creates an instance of AppThemeSet with the given light and dark themes.
  const AppThemeSet({required this.light, required this.dark});
  /// light theme data
  final ThemeData light;
  /// dark theme data
  final ThemeData dark;
}

/// Provider for the application's theme set (light and dark themes).
final appThemeProvider = Provider<AppThemeSet>((final ref) {
  final baseLight = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightAccent,
      onSecondary: AppColors.lightOnAccent,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightBorder,
      tertiary: AppColors.lightSuccess,
      onTertiary: AppColors.lightOnPrimary,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    dividerColor: AppColors.lightBorder,
    textTheme: TextTheme(
      headlineSmall: AppTypography.display.copyWith(color: AppColors.lightTextPrimary),
      titleMedium: AppTypography.title.copyWith(color: AppColors.lightTextPrimary),
      bodyMedium: AppTypography.body.copyWith(color: AppColors.lightTextPrimary),
      labelMedium: AppTypography.label.copyWith(color: AppColors.lightTextPrimary),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.lightPrimary,
      size: 24.0, // DEFAULT
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: Elevation.none,
      centerTitle: false, // DEFAULT
      titleTextStyle: AppTypography.title.copyWith(color: AppColors.lightTextPrimary),
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corners.lg),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
      elevation: Elevation.none,
      margin: EdgeInsets.zero,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corners.xl),
      ),
      elevation: Elevation.lg,
      titleTextStyle: AppTypography.title.copyWith(color: AppColors.lightTextPrimary),
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.lightTextSecondary),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightSurface,
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.lightTextPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
      behavior: SnackBarBehavior.floating, // DEFAULT
      elevation: Elevation.md,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        borderSide: const BorderSide(color: AppColors.lightError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        borderSide: const BorderSide(color: AppColors.lightError, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      hintStyle: AppTypography.body.copyWith(color: AppColors.lightTextSecondary),
      labelStyle: AppTypography.label.copyWith(color: AppColors.lightTextSecondary),
      errorStyle: AppTypography.label.copyWith(color: AppColors.lightError),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.lightPrimaryHover;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightBorder; // DEFAULT
          }
          return AppColors.lightPrimary;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.lightOnPrimary),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Corners.md),
          ),
        ),
        textStyle: WidgetStateProperty.all(AppTypography.label),
        elevation: WidgetStateProperty.all(Elevation.none),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightBorder; // DEFAULT
          }
          return AppColors.lightSurface;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.lightPrimary),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Corners.md),
          ),
        ),
        textStyle: WidgetStateProperty.all(AppTypography.label),
        elevation: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.hovered)) {
            return Elevation.md;
          }
          return Elevation.sm; // DEFAULT
        }),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.lightPrimary),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Corners.md),
          ),
        ),
        side: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.hovered)) {
            return const BorderSide(color: AppColors.lightPrimaryHover, width: 2);
          }
          return const BorderSide(color: AppColors.lightPrimary);
        }),
        textStyle: WidgetStateProperty.all(AppTypography.label),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.lightPrimaryHover;
          }
          return AppColors.lightPrimary;
        }),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        ),
        textStyle: WidgetStateProperty.all(AppTypography.label),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurface,
      deleteIconColor: AppColors.lightTextSecondary,
      disabledColor: AppColors.lightBorder, // DEFAULT
      selectedColor: AppColors.lightPrimary,
      secondarySelectedColor: AppColors.lightAccent,
      labelPadding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      padding: const EdgeInsets.all(Spacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corners.sm),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
      labelStyle: AppTypography.label.copyWith(color: AppColors.lightTextPrimary),
      secondaryLabelStyle: AppTypography.label.copyWith(color: AppColors.lightTextPrimary),
      brightness: Brightness.light,
    ),
  );

  final baseDark = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkAccent,
      onSecondary: AppColors.darkOnAccent,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
      tertiary: AppColors.darkSuccess,
      onTertiary: AppColors.darkOnPrimary,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    dividerColor: AppColors.darkBorder,
    textTheme: TextTheme(
      headlineSmall: AppTypography.display.copyWith(color: AppColors.darkTextPrimary),
      titleMedium: AppTypography.title.copyWith(color: AppColors.darkTextPrimary),
      bodyMedium: AppTypography.body.copyWith(color: AppColors.darkTextPrimary),
      labelMedium: AppTypography.label.copyWith(color: AppColors.darkTextPrimary),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.darkPrimary,
      size: 24.0, // DEFAULT
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: Elevation.none,
      centerTitle: false, // DEFAULT
      titleTextStyle: AppTypography.title.copyWith(color: AppColors.darkTextPrimary),
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corners.lg),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
      elevation: Elevation.none,
      margin: EdgeInsets.zero,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corners.xl),
      ),
      elevation: Elevation.lg,
      titleTextStyle: AppTypography.title.copyWith(color: AppColors.darkTextPrimary),
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.darkTextSecondary),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkSurface,
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.darkTextPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
      behavior: SnackBarBehavior.floating, // DEFAULT
      elevation: Elevation.md,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        borderSide: const BorderSide(color: AppColors.darkError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corners.md),
        borderSide: const BorderSide(color: AppColors.darkError, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      hintStyle: AppTypography.body.copyWith(color: AppColors.darkTextSecondary),
      labelStyle: AppTypography.label.copyWith(color: AppColors.darkTextSecondary),
      errorStyle: AppTypography.label.copyWith(color: AppColors.darkError),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.darkPrimaryHover;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.darkBorder; // DEFAULT
          }
          return AppColors.darkPrimary;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.darkOnPrimary),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Corners.md),
          ),
        ),
        textStyle: WidgetStateProperty.all(AppTypography.label),
        elevation: WidgetStateProperty.all(Elevation.none),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.darkBorder; // DEFAULT
          }
          return AppColors.darkSurface;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.darkPrimary),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Corners.md),
          ),
        ),
        textStyle: WidgetStateProperty.all(AppTypography.label),
        elevation: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.hovered)) {
            return Elevation.md;
          }
          return Elevation.sm; // DEFAULT
        }),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.darkPrimary),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Corners.md),
          ),
        ),
        side: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.hovered)) {
            return const BorderSide(color: AppColors.darkPrimaryHover, width: 2);
          }
          return const BorderSide(color: AppColors.darkPrimary);
        }),
        textStyle: WidgetStateProperty.all(AppTypography.label),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.darkPrimaryHover;
          }
          return AppColors.darkPrimary;
        }),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        ),
        textStyle: WidgetStateProperty.all(AppTypography.label),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurface,
      deleteIconColor: AppColors.darkTextSecondary,
      disabledColor: AppColors.darkBorder, // DEFAULT
      selectedColor: AppColors.darkPrimary,
      secondarySelectedColor: AppColors.darkAccent,
      labelPadding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      padding: const EdgeInsets.all(Spacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corners.sm),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
      labelStyle: AppTypography.label.copyWith(color: AppColors.darkTextPrimary),
      secondaryLabelStyle: AppTypography.label.copyWith(color: AppColors.darkTextPrimary),
      brightness: Brightness.dark,
    ),
  );

  return AppThemeSet(light: baseLight, dark: baseDark);
});
