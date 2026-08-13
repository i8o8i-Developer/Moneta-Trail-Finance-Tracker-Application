// Moneta Trail Category Budget Limit Drift Table Definition
// Tracks Monthly Category Spending Allowances And Limits

import 'package:drift/drift.dart';

@DataClassName('Budget')
class BudgetTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer()();
  TextColumn get month => text()(); // Format 'YYYY-MM'
  IntColumn get limitAmountCents => integer()();
}
