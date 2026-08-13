// Moneta Trail Inter Typography Scale Definitions
// Ground Truth Type System Matching Extracted Design Tokens

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Display Hero Text Style
  static TextStyle displayHero({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 40.0,
      fontWeight: FontWeight.w700,
      height: 48.0 / 40.0,
      letterSpacing: -0.8,
      color: color,
    );
  }

  // Display Hero Mobile Text Style
  static TextStyle displayHeroMobile({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      height: 40.0 / 32.0,
      letterSpacing: -0.64,
      color: color,
    );
  }

  // Headline Medium Text Style
  static TextStyle headlineMd({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      height: 28.0 / 20.0,
      color: color,
    );
  }

  // Numeric Data Text Style (Tabular Figures)
  static TextStyle numericData({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      height: 24.0 / 18.0,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: color,
    );
  }

  // Body Large Text Style
  static TextStyle bodyLg({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      height: 24.0 / 16.0,
      color: color,
    );
  }

  // Body Small Text Style
  static TextStyle bodySm({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 20.0 / 14.0,
      color: color,
    );
  }

  // Label Caps Text Style
  static TextStyle labelCaps({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
      height: 16.0 / 12.0,
      letterSpacing: 0.6,
      color: color,
    );
  }
}
