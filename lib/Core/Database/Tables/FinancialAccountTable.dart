// Moneta Trail Financial Accounts Drift Table Definition
// Stores Connected Cash Wallets, Bank Accounts, Savings, And Credit Cards

import 'package:drift/drift.dart';

@DataClassName('FinancialAccount')
class FinancialAccountTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // 'Cash', 'Bank', 'Card', 'Savings'
  TextColumn get iconName => text().withDefault(const Constant('account_balance_wallet'))();
  IntColumn get balanceCents => integer().withDefault(const Constant(0))();
  IntColumn get creditLimitCents => integer().nullable()();
  TextColumn get dueDate => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}
