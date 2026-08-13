// Moneta Trail Budget Remaining Calculation Unit Tests
// Tests Progress Percentage And Budget Overrun Threshold Math

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Budget Math Unit Tests', () {
    test('Calculates Correct Progress Percentage Within Budget Limit', () {
      const int spent = 42500; // $425.00
      const int limit = 50000; // $500.00
      final double ratio = spent / limit;
      expect(ratio, equals(0.85));
    });

    test('Detects Over Budget Threshold When Spent Exceeds Limit', () {
      const int spent = 38000; // $380.00
      const int limit = 35000; // $350.00
      final bool isOver = spent > limit;
      expect(isOver, isTrue);
    });
  });
}
