// Moneta Trail Currency Formatter Unit Tests
// Tests Decimal-Safe Minor Units Formatting Across Multiple Currencies

import 'package:flutter_test/flutter_test.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';

void main() {
  group('CurrencyFormatter Unit Tests', () {
    test('Formats USD Cents Amount Correctly', () {
      final String formatted = CurrencyFormatter.formatCents(1245000, currencyCode: 'USD');
      expect(formatted, contains('12,450.00'));
    });

    test('Formats Negative Expense Amount Correctly', () {
      final String formatted = CurrencyFormatter.formatCents(-125000, currencyCode: 'USD');
      expect(formatted, contains('-'));
      expect(formatted, contains('1,250.00'));
    });

    test('Parses Double String Input To Integer Minor Units Cents', () {
      final int cents = CurrencyFormatter.parseToCents('142.50');
      expect(cents, equals(14250));
    });
  });
}
