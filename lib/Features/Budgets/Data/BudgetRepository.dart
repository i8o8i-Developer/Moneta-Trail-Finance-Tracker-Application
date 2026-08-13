// Moneta Trail Category Budget Limit Repository
// Queries Budget Allowances And Calculates Remaining Allowances

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Features/Records/Data/RecordsRepository.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref.watch(databaseProvider));
});

class BudgetRepository {
  final AppDatabase _db;

  BudgetRepository(this._db);

  // Streams All Set Category Budgets For Selected Month
  Stream<List<Budget>> watchMonthlyBudgets(String month) {
    return (_db.select(_db.budgetTable)..where((b) => b.month.equals(month))).watch();
  }

  // Sets Or Updates A Category Budget
  Future<void> setBudget({
    required int categoryId,
    required String month,
    required int limitAmountCents,
  }) async {
    print('Updating Category Budget For Category ID $categoryId In Month $month');

    final existing = await (_db.select(_db.budgetTable)
          ..where((b) => b.categoryId.equals(categoryId) & b.month.equals(month)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.budgetTable)..where((b) => b.id.equals(existing.id)))
          .write(BudgetTableCompanion(limitAmountCents: Value(limitAmountCents)));
    } else {
      await _db.into(_db.budgetTable).insert(
            BudgetTableCompanion.insert(
              categoryId: categoryId,
              month: month,
              limitAmountCents: limitAmountCents,
            ),
          );
    }
  }

  // Calculates Total Spent Amount For A Category In Month
  Future<int> getCategorySpent(int categoryId, DateTime month) async {
    final DateTime start = DateTime(month.year, month.month, 1);
    final DateTime end = DateTime(month.year, month.month + 1, 1).subtract(const Duration(milliseconds: 1));

    final txs = await (_db.select(_db.transactionEntryTable)
          ..where((t) =>
              t.categoryId.equals(categoryId) &
              t.type.equals('Expense') &
              t.occurredAt.isBetweenValues(start, end)))
        .get();

    return txs.fold<int>(0, (sum, item) => sum + item.amountCents);
  }

  // Deletes A Category Budget Allowance
  Future<void> deleteBudget(int budgetId) async {
    print('Deleting Category Budget ID $budgetId');
    await (_db.delete(_db.budgetTable)..where((b) => b.id.equals(budgetId))).go();
  }
}
