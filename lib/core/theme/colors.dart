import 'package:flutter/material.dart';

/// AppColors contains static color tokens for both light and dark themes.
class AppColors {
  // -------------------
  // Light theme colors
  // -------------------
  /// lightBackground FFF8FAF9
	static const Color lightBackground = Color(0xFFF8FAF9);
  /// lightSurface FFFFFF
	static const Color lightSurface = Color(0xFFFFFFFF);
  /// lightPrimary 2A7F62
	static const Color lightPrimary = Color(0xFF2A7F62);
  /// lightPrimaryHover 3EA68A
	static const Color lightPrimaryHover = Color(0xFF3EA68A);
  /// lightAccent FFF595E
	static const Color lightAccent = Color(0xFFFF595E);
  /// lightAccentHover E35055
	static const Color lightAccentHover = Color(0xFFE35055);
  /// lightTextPrimary 0D3B66
	static const Color lightTextPrimary = Color(0xFF0D3B66);
  /// lightTextSecondary 3A506B
	static const Color lightTextSecondary = Color(0xFF3A506B);
  /// lightBorder C0C5C1
	static const Color lightBorder = Color(0xFFC0C5C1);
  /// lightError E53E3E
	static const Color lightError = Color(0xFFE53E3E);
  /// lightSuccess 2A9D8F
	static const Color lightSuccess = Color(0xFF2A9D8F);
  /// lightInfo 3B82F6
	static const Color lightInfo = Color(0xFF3B82F6);

  // DEFAULT: Colors for text/icons on colored backgrounds (light theme)
  /// lightOnPrimary FFFFFF (default - white text on primary)
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  /// lightOnAccent FFFFFF (default - white text on accent)
  static const Color lightOnAccent = Color(0xFFFFFFFF);
  /// lightOnError FFFFFF (default - white text on error)
  static const Color lightOnError = Color(0xFFFFFFFF);

  // -------------------
  // Dark theme colors
  // -------------------
  /// darkBackground 0B1320
	static const Color darkBackground = Color(0xFF0B1320);
  /// darkSurface 1A2433
	static const Color darkSurface = Color(0xFF1A2433);
  /// darkPrimary 3EA68A
	static const Color darkPrimary = Color(0xFF3EA68A);
  /// darkPrimaryHover 2A7F62
	static const Color darkPrimaryHover = Color(0xFF2A7F62);
  /// darkAccent FF7A7E
	static const Color darkAccent = Color(0xFFFF7A7E);
  /// darkAccentHover FF595E
	static const Color darkAccentHover = Color(0xFFFF595E);
  /// darkTextPrimary E6E8EB
	static const Color darkTextPrimary = Color(0xFFE6E8EB);
  /// darkTextSecondary A9B0B6
	static const Color darkTextSecondary = Color(0xFFA9B0B6);
  /// darkBorder 2D3A4A
	static const Color darkBorder = Color(0xFF2D3A4A);
  /// darkError FF6B6B
	static const Color darkError = Color(0xFFFF6B6B);
  /// darkSuccess 4FD1C5
	static const Color darkSuccess = Color(0xFF4FD1C5);
  /// darkInfo 60A5FA
	static const Color darkInfo = Color(0xFF60A5FA);

  // DEFAULT: Colors for text/icons on colored backgrounds (dark theme)
  /// darkOnPrimary FFFFFF (default - white text on primary)
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  /// darkOnAccent 0B1320 (default - dark text on accent)
  static const Color darkOnAccent = Color(0xFF0B1320);
  /// darkOnError 0B1320 (default - dark text on error)
  static const Color darkOnError = Color(0xFF0B1320);
}
