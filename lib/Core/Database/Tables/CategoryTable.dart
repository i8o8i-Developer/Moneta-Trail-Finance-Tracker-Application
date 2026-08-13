// Moneta Trail Transaction Categories Drift Table Definition
// Stores Expense And Income Categorization Attributes

import 'package:drift/drift.dart';

@DataClassName('Category')
class CategoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get iconName => text()();
  TextColumn get colorHex => text()();
  TextColumn get type => text()(); // 'Income', 'Expense'
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}
