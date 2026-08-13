// Moneta Trail Application Color Palette And Theme Swatches
// Dark Obsidian Theme Tokens Across All Components

import 'package:flutter/material.dart';

class AppColors {
  // Primary Green Swatches (Growth & Income)
  static const Color primaryBase = Color(0xFF059669);
  static const Color primaryContainer = Color(0xFF10B981);
  static const Color primaryFixed = Color(0xFF6FFBBE);
  static const Color primaryFixedDim = Color(0xFF34D399);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF00422B);

  // Secondary Red Swatches (Expenses & Alerts)
  static const Color secondaryBase = Color(0xFFDC2626);
  static const Color secondaryContainer = Color(0xFFEF4444);
  static const Color secondaryFixed = Color(0xFFFFDAD7);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Tertiary Blue Swatches (Utilities & Transfers)
  static const Color tertiaryBase = Color(0xFF2563EB);
  static const Color tertiaryContainer = Color(0xFF3B82F6);
  static const Color tertiaryFixed = Color(0xFFD8E2FF);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // Surface & Neutral Swatches (Sleek Rich Dark Side Palette)
  static const Color lightSurface = Color(0xFF0B0F17); // Dark Midnight Obsidian
  static const Color lightSurfaceLow = Color(0xFF111827); // Dark Charcoal Slate
  static const Color lightSurfaceContainer = Color(0xFF151D2A); // Container Surface
  static const Color lightSurfaceContainerHigh = Color(0xFF1E293B);
  static const Color lightSurfaceContainerHighest = Color(0xFF334155);
  static const Color lightOnSurface = Color(0xFFF8FAFC); // Crisp Bright White Text
  static const Color lightOnSurfaceVariant = Color(0xFF94A3B8); // Muted Text
  static const Color lightOutline = Color(0xFF334155);
  static const Color lightOutlineVariant = Color(0xFF1E293B);

  // Dark Mode Surfaces & Neutrals
  static const Color darkSurface = Color(0xFF0B0F17); // Dark Midnight Obsidian
  static const Color darkSurfaceLow = Color(0xFF111827);
  static const Color darkSurfaceContainer = Color(0xFF151D2A);
  static const Color darkSurfaceHigh = Color(0xFF1E293B);
  static const Color darkSurfaceContainerHigh = Color(0xFF334155);
  static const Color darkOnSurface = Color(0xFFF8FAFC);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkOutline = Color(0xFF334155);

  // Vibrant Punchy Category Color Map
  static const Map<String, Color> categoryColors = {
    'housing': Color(0xFF3B82F6),
    'groceries': Color(0xFF10B981),
    'dining': Color(0xFFF59E0B),
    'transportation': Color(0xFF8B5CF6),
    'entertainment': Color(0xFFEC4899),
    'clothing': Color(0xFF06B6D4),
    'pets': Color(0xFF14B8A6),
    'health': Color(0xFFEF4444),
    'salary': Color(0xFF10B981),
    'investments': Color(0xFF3B82F6),
  };
}
