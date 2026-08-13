// Moneta Trail Currency And Financial Amount Formatter Utility
// Converts Integer Minor Units (Cents) To Formatted Currency Strings

import 'package:intl/intl.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';

class CurrencyFormatter {
  // Formats Integer Minor Units (Cents) Into Localized Currency Display String
  static String formatCents(
    int centsAmount, {
    required String currencyCode,
    bool showSign = false,
  }) {
    final double mainAmount = centsAmount / 100.0;
    final String symbol = AppTokens.currencySymbols[currencyCode] ?? '\$';

    final NumberFormat formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );

    final String formatted = formatter.format(mainAmount.abs());

    if (centsAmount < 0) {
      return '-$formatted';
    } else if (centsAmount > 0 && showSign) {
      return '+$formatted';
    }
    return formatted;
  }

  // Formats Raw Currency Double Value Into Standard Representation
  static String formatAmount(
    double amount, {
    required String currencyCode,
  }) {
    final int cents = (amount * 100).round();
    return formatCents(cents, currencyCode: currencyCode);
  }

  // Converts Floating Amount Input String Into Minor Units Integer
  static int parseToCents(String inputAmount) {
    if (inputAmount.isEmpty) return 0;
    final double? parsed = double.tryParse(inputAmount.replaceAll(',', ''));
    if (parsed == null) return 0;
    return (parsed * 100).round();
  }
}
