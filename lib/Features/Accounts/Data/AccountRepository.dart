// Moneta Trail Financial Account Repository
// Handles Account Persistence, Balance Calculation, And Inter-Account Transfers

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Features/Records/Data/RecordsRepository.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(ref.watch(databaseProvider));
});

class AccountRepository {
  final AppDatabase _db;

  AccountRepository(this._db);

  // Streams All Active Non-Deleted Accounts
  Stream<List<FinancialAccount>> watchAccounts() {
    return (_db.select(_db.financialAccountTable)
          ..where((a) => a.isDeleted.equals(false)))
        .watch();
  }

  // Gets Single Account By ID
  Future<FinancialAccount?> getAccountById(int id) async {
    return (_db.select(_db.financialAccountTable)..where((a) => a.id.equals(id))).getSingleOrNull();
  }

  // Adds New Financial Account
  Future<int> createAccount({
    required String name,
    required String type,
    String iconName = 'account_balance',
    required int balanceCents,
    int? creditLimitCents,
    String? dueDate,
  }) async {
    print('Creating New Account: $name');
    return await _db.into(_db.financialAccountTable).insert(
          FinancialAccountTableCompanion.insert(
            name: name,
            type: type,
            iconName: Value(iconName),
            balanceCents: Value(balanceCents),
            creditLimitCents: Value(creditLimitCents),
            dueDate: Value(dueDate),
          ),
        );
  }

  // Transfers Funds Double-Entry Between Accounts
  Future<void> transferFunds({
    required int fromAccountId,
    required int toAccountId,
    required int amountCents,
  }) async {
    print('Executing Inter-Account Transfer From $fromAccountId To $toAccountId');
    final DateTime now = DateTime.now();

    await _db.into(_db.transactionEntryTable).insert(
          TransactionEntryTableCompanion.insert(
            accountId: fromAccountId,
            toAccountId: Value(toAccountId),
            type: 'Transfer',
            amountCents: amountCents,
            notes: const Value('Account Transfer'),
            occurredAt: now,
            createdAt: now,
          ),
        );

    final fromAccount = await getAccountById(fromAccountId);
    final toAccount = await getAccountById(toAccountId);

    if (fromAccount != null && toAccount != null) {
      await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(fromAccountId)))
          .write(FinancialAccountTableCompanion(balanceCents: Value(fromAccount.balanceCents - amountCents)));

      await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(toAccountId)))
          .write(FinancialAccountTableCompanion(balanceCents: Value(toAccount.balanceCents + amountCents)));
    }
  }

  // Deposits Money / Adds Funds To Account
  Future<void> depositMoney({
    required int accountId,
    required int amountCents,
    String? note,
    DateTime? occurredAt,
  }) async {
    print('Depositing Money To Account ID $accountId');
    final DateTime now = occurredAt ?? DateTime.now();
    await _db.into(_db.transactionEntryTable).insert(
          TransactionEntryTableCompanion.insert(
            accountId: accountId,
            type: 'Income',
            amountCents: amountCents,
            notes: Value(note ?? 'Account Deposit'),
            occurredAt: now,
            createdAt: DateTime.now(),
          ),
        );

    final account = await getAccountById(accountId);
    if (account != null) {
      final int newBal = account.balanceCents + amountCents;
      await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(accountId)))
          .write(FinancialAccountTableCompanion(balanceCents: Value(newBal)));
    }
  }

  // Updates Existing Financial Account Details
  Future<void> updateAccount({
    required int accountId,
    required String name,
    required String type,
    String? iconName,
    String? dueDate,
    required int balanceCents,
  }) async {
    print('Updating Account ID $accountId');
    await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(accountId))).write(
          FinancialAccountTableCompanion(
            name: Value(name),
            type: Value(type),
            iconName: iconName != null ? Value(iconName) : const Value.absent(),
            dueDate: dueDate != null ? Value(dueDate) : const Value.absent(),
            balanceCents: Value(balanceCents),
          ),
        );
  }

  // Deletes Financial Account (Soft Delete)
  Future<void> deleteAccount(int accountId) async {
    print('Deleting Account ID $accountId');
    await (_db.update(_db.financialAccountTable)..where((a) => a.id.equals(accountId)))
        .write(const FinancialAccountTableCompanion(isDeleted: Value(true)));
  }
}
