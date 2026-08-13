// Moneta Trail Drift AppDatabase Class
// Type-Safe Relational Database Engine Over Local SQLite

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:moneta_trail/Core/Database/Tables/AppProfileTable.dart';
import 'package:moneta_trail/Core/Database/Tables/FinancialAccountTable.dart';
import 'package:moneta_trail/Core/Database/Tables/CategoryTable.dart';
import 'package:moneta_trail/Core/Database/Tables/TransactionEntryTable.dart';
import 'package:moneta_trail/Core/Database/Tables/BudgetTable.dart';

part 'AppDatabase.g.dart';

@DriftDatabase(tables: [
  AppProfileTable,
  FinancialAccountTable,
  CategoryTable,
  TransactionEntryTable,
  BudgetTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Seed Initial Default Data On First Application Launch
        await _seedInitialData();
      },
    );
  }

  // Seed Default Categories And Primary Accounts
  Future<void> _seedInitialData() async {
    // Seed Clean Default Accounts
    await into(financialAccountTable).insert(
      FinancialAccountTableCompanion.insert(
        name: 'Cash Wallet',
        type: 'Cash',
        iconName: const Value('account_balance_wallet'),
        balanceCents: const Value(0),
      ),
    );

    await into(financialAccountTable).insert(
      FinancialAccountTableCompanion.insert(
        name: 'Main Bank Account',
        type: 'Bank',
        iconName: const Value('account_balance'),
        balanceCents: const Value(0),
      ),
    );

    await into(financialAccountTable).insert(
      FinancialAccountTableCompanion.insert(
        name: 'Platinum Credit Card',
        type: 'Card',
        iconName: const Value('credit_card'),
        balanceCents: const Value(0),
        creditLimitCents: const Value(500000), // $5,000.00 limit
        dueDate: const Value('Monthly'),
      ),
    );

    await into(financialAccountTable).insert(
      FinancialAccountTableCompanion.insert(
        name: 'Savings Account',
        type: 'Savings',
        iconName: const Value('savings'),
        balanceCents: const Value(0),
      ),
    );

    // Seed Clean Default Categories
    final List<CategoryTableCompanion> defaultCategories = [
      CategoryTableCompanion.insert(name: 'Housing & Rent', iconName: 'home', colorHex: '#3B82F6', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Food & Dining', iconName: 'restaurant', colorHex: '#F59E0B', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Groceries', iconName: 'local_grocery_store', colorHex: '#10B981', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Transportation', iconName: 'directions_car', colorHex: '#8B5CF6', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Shopping', iconName: 'shopping_bag', colorHex: '#06B6D4', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Entertainment', iconName: 'movie', colorHex: '#EC4899', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Utilities', iconName: 'lightbulb', colorHex: '#005AC2', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Health & Medical', iconName: 'medical_services', colorHex: '#EF4444', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Travel & Flights', iconName: 'flight', colorHex: '#0284C7', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Education', iconName: 'school', colorHex: '#6366F1', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Subscriptions', iconName: 'subscriptions', colorHex: '#D97706', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Pets', iconName: 'pets', colorHex: '#14B8A6', type: 'Expense', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Salary', iconName: 'attach_money', colorHex: '#10B981', type: 'Income', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Investments', iconName: 'trending_up', colorHex: '#005AC2', type: 'Income', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Freelance', iconName: 'work', colorHex: '#8B5CF6', type: 'Income', isDefault: const Value(true)),
      CategoryTableCompanion.insert(name: 'Gift & Bonus', iconName: 'card_giftcard', colorHex: '#EC4899', type: 'Income', isDefault: const Value(true)),
    ];

    for (final cat in defaultCategories) {
      await into(categoryTable).insert(cat);
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moneta_trail.sqlite'));
    return NativeDatabase(file);
  });
}
