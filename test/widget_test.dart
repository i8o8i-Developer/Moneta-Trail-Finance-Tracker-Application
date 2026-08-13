// Moneta Trail Basic Widget Smoke Test
// Verifies Application Launch And Initial Route Rendering

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneta_trail/main.dart';

void main() {
  testWidgets('Moneta Trail Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MonetaTrailApp()));
    await tester.pump(const Duration(milliseconds: 1800));

    expect(find.byType(MonetaTrailApp), findsOneWidget);
  });
}
