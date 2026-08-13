// Moneta Trail Financial Transaction Entry Drift Table Definition
// Stores Individual Expense, Income, And Internal Account Transfer Records

import 'package:drift/drift.dart';

@DataClassName('TransactionEntry')
class TransactionEntryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer()();
  IntColumn get toAccountId => integer().nullable()(); // Nullable, Used For Transfers
  IntColumn get categoryId => integer().nullable()();
  TextColumn get type => text()(); // 'Income', 'Expense', 'Transfer'
  IntColumn get amountCents => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}
