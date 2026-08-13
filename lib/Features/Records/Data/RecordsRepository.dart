// Moneta Trail Records And Transaction Repository
// Interacts With Drift TransactionEntryTable Backed By Local SQLite Engine

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final recordsRepositoryProvider = Provider<RecordsRepository>((ref) {
  return RecordsRepository(ref.watch(databaseProvider));
});

class RecordsRepository {
  final AppDatabase _db;

  RecordsRepository(this._db);

  // Streams All Transactions For Specified Month
  Stream<List<TransactionEntry>> watchMonthlyTransactions(DateTime month) {
    final DateTime start = DateTime(month.year, month.month, 1);
    final DateTime end = DateTime(month.year, month.month + 1, 1).subtract(const Duration(milliseconds: 1));

    return (_db.select(_db.transactionEntryTable)
          ..where((t) => t.occurredAt.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm(expression: t.occurredAt, mode: OrderingMode.desc)]))
        .watch();
  }

  // Streams All Transactions For Specific Account
  Stream<List<TransactionEntry>> watchAccountTransactions(int accountId) {
    return (_db.select(_db.transactionEntryTable)
          ..where((t) => t.accountId.equals(accountId) | t.toAccountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm(expression: t.occurredAt, mode: OrderingMode.desc)]))
        .watch();
  }

  // Inserts A New Transaction Entry And Updates Associated Account Balance
  Future<void> createTransaction({
    required int accountId,
    int? toAccountId,
    int? categoryId,
    required String type,
    required int amountCents,
    String? notes,
    required DateTime occurredAt,
  }) async {
    print('Creating New Transaction Record In Local Database');

    await _db.into(_db.transactionEntryTable).insert(
          TransactionEntryTableCompanion.insert(
            accountId: accountId,
            toAccountId: Value(toAccountId),
            categoryId: Value(categoryId),
            type: type,
            amountCents: amountCents,
            notes: Value(notes),
            occurredAt: occurredAt,
            createdAt: DateTime.now(),
          ),
        );

    // Update Account Balances Based On Transaction Type
    final account = await (_db.select(_db.financialAccountTable)..where((a) => a.id.equals(accountId))).getSingle();

    if (type == 'Expense') {
      final int newBal = account.balanceCents - amountCents;
      await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(accountId)))
          .write(FinancialAccountTableCompanion(balanceCents: Value(newBal)));
    } else if (type == 'Income') {
      final int newBal = account.balanceCents + amountCents;
      await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(accountId)))
          .write(FinancialAccountTableCompanion(balanceCents: Value(newBal)));
    } else if (type == 'Transfer' && toAccountId != null) {
      // Deduct From Source Account
      final int newSourceBal = account.balanceCents - amountCents;
      await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(accountId)))
          .write(FinancialAccountTableCompanion(balanceCents: Value(newSourceBal)));

      // Add To Target Account
      final toAccount = await (_db.select(_db.financialAccountTable)..where((a) => a.id.equals(toAccountId))).getSingle();
      final int newTargetBal = toAccount.balanceCents + amountCents;
      await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(toAccountId)))
          .write(FinancialAccountTableCompanion(balanceCents: Value(newTargetBal)));
    }
  }

  // Deletes A Transaction Entry And Safely Reverts Account Balances
  Future<void> deleteTransaction(int id) async {
    print('Deleting Transaction Record ID: $id');
    final tx = await (_db.select(_db.transactionEntryTable)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (tx != null) {
      final account = await (_db.select(_db.financialAccountTable)..where((a) => a.id.equals(tx.accountId))).getSingleOrNull();
      if (account != null) {
        if (tx.type == 'Expense') {
          final int newBal = account.balanceCents + tx.amountCents;
          await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(tx.accountId)))
              .write(FinancialAccountTableCompanion(balanceCents: Value(newBal)));
        } else if (tx.type == 'Income') {
          final int newBal = account.balanceCents - tx.amountCents;
          await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(tx.accountId)))
              .write(FinancialAccountTableCompanion(balanceCents: Value(newBal)));
        } else if (tx.type == 'Transfer' && tx.toAccountId != null) {
          final int newSourceBal = account.balanceCents + tx.amountCents;
          await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(tx.accountId)))
              .write(FinancialAccountTableCompanion(balanceCents: Value(newSourceBal)));

          final toAccount = await (_db.select(_db.financialAccountTable)..where((a) => a.id.equals(tx.toAccountId!))).getSingleOrNull();
          if (toAccount != null) {
            final int newTargetBal = toAccount.balanceCents - tx.amountCents;
            await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(tx.toAccountId!)))
                .write(FinancialAccountTableCompanion(balanceCents: Value(newTargetBal)));
          }
        }
      }
      await (_db.delete(_db.transactionEntryTable)..where((t) => t.id.equals(id))).go();
    }
  }
}
