import 'package:flutter/material.dart';

/// AppTypography contains static text style tokens for consistent typography across the app.
class AppTypography {
  /// Display text style
  static TextStyle get display => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3,
      );

  /// Title text style
  static TextStyle get title => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.2,
      );

  /// Body text style
  static TextStyle get body => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  /// Label text style
  static TextStyle get label => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.1,
      );
}
