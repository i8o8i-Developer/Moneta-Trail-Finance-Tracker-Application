// Moneta Trail Local Data Backup And CSV Export Service
// Handles Local JSON Import/Export Files And CSV Generation

import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';

class BackupService {
  final AppDatabase _db;

  BackupService(this._db);

  // Exports Transaction History Feed To CSV File Format
  Future<void> exportTransactionsCsv() async {
    try {
      final transactions = await _db.select(_db.transactionEntryTable).get();
      final accounts = await _db.select(_db.financialAccountTable).get();
      final categories = await _db.select(_db.categoryTable).get();

      final Map<int, String> accountMap = {for (var a in accounts) a.id: a.name};
      final Map<int, String> categoryMap = {for (var c in categories) c.id: c.name};

      final List<List<dynamic>> csvRows = [
        ['ID', 'Date', 'Type', 'Account', 'To Account', 'Category', 'Amount (Cents)', 'Notes'],
      ];

      for (final t in transactions) {
        csvRows.add([
          t.id,
          DateFormat('yyyy-MM-dd HH:mm').format(t.occurredAt),
          t.type,
          accountMap[t.accountId] ?? 'Unknown Account',
          t.toAccountId != null ? (accountMap[t.toAccountId!] ?? '') : '',
          t.categoryId != null ? (categoryMap[t.categoryId!] ?? '') : '',
          t.amountCents,
          t.notes ?? '',
        ]);
      }

      final String csvData = const ListToCsvConverter().convert(csvRows);
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/Moneta_Trail_Transactions_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
      
      final File csvFile = File(filePath);
      await csvFile.writeAsString(csvData);

      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Moneta Trail Transaction Feed Export',
      );
    } catch (e) {
      print('Failed To Export CSV File: $e');
      rethrow;
    }
  }

  // Exports Complete Relational Database State To Timestamped JSON File
  Future<void> exportJsonBackup() async {
    try {
      final profiles = await _db.select(_db.appProfileTable).get();
      final accounts = await _db.select(_db.financialAccountTable).get();
      final categories = await _db.select(_db.categoryTable).get();
      final transactions = await _db.select(_db.transactionEntryTable).get();
      final budgets = await _db.select(_db.budgetTable).get();

      final Map<String, dynamic> backupData = {
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'profiles': profiles.map((p) => {
          'username': p.username,
          'primaryCurrency': p.primaryCurrency,
          'language': p.language,
          'appearanceTheme': p.appearanceTheme,
        }).toList(),
        'accounts': accounts.map((a) => {
          'id': a.id,
          'name': a.name,
          'type': a.type,
          'iconName': a.iconName,
          'balanceCents': a.balanceCents,
          'creditLimitCents': a.creditLimitCents,
          'dueDate': a.dueDate,
        }).toList(),
        'categories': categories.map((c) => {
          'id': c.id,
          'name': c.name,
          'iconName': c.iconName,
          'colorHex': c.colorHex,
          'type': c.type,
        }).toList(),
        'transactions': transactions.map((t) => {
          'accountId': t.accountId,
          'toAccountId': t.toAccountId,
          'categoryId': t.categoryId,
          'type': t.type,
          'amountCents': t.amountCents,
          'notes': t.notes,
          'occurredAt': t.occurredAt.toIso8601String(),
        }).toList(),
        'budgets': budgets.map((b) => {
          'categoryId': b.categoryId,
          'month': b.month,
          'limitAmountCents': b.limitAmountCents,
        }).toList(),
      };

      final String jsonString = const JsonEncoder.withIndent('  ').convert(backupData);
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/Moneta_Trail_Backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';

      final File backupFile = File(filePath);
      await backupFile.writeAsString(jsonString);

      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Moneta Trail Local Database Backup',
      );
    } catch (e) {
      print('Failed To Export JSON Backup File: $e');
      rethrow;
    }
  }

  // Restores Application Data From Picked JSON Backup File
  Future<bool> importJsonBackup() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) {
        return false;
      }

      final File file = File(result.files.single.path!);
      final String content = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(content);

      if (!data.containsKey('exportedAt') || !data.containsKey('accounts')) {
        throw const FormatException('Invalid Moneta Trail Backup File Format');
      }

      // Clear Current Tables
      await _db.delete(_db.transactionEntryTable).go();
      await _db.delete(_db.budgetTable).go();
      await _db.delete(_db.categoryTable).go();
      await _db.delete(_db.financialAccountTable).go();

      // Restore Categories
      final List<dynamic> catList = data['categories'] ?? [];
      for (final cat in catList) {
        await _db.into(_db.categoryTable).insert(
          CategoryTableCompanion.insert(
            name: cat['name'],
            iconName: cat['iconName'],
            colorHex: cat['colorHex'],
            type: cat['type'],
          ),
        );
      }

      // Restore Accounts
      final List<dynamic> accList = data['accounts'] ?? [];
      for (final acc in accList) {
        await _db.into(_db.financialAccountTable).insert(
          FinancialAccountTableCompanion.insert(
            name: acc['name'],
            type: acc['type'],
            iconName: Value(acc['iconName'] ?? 'account_balance_wallet'),
            balanceCents: Value(acc['balanceCents'] ?? 0),
            creditLimitCents: Value(acc['creditLimitCents']),
            dueDate: Value(acc['dueDate']),
          ),
        );
      }

      // Restore Transactions
      final List<dynamic> txList = data['transactions'] ?? [];
      for (final tx in txList) {
        await _db.into(_db.transactionEntryTable).insert(
          TransactionEntryTableCompanion.insert(
            accountId: tx['accountId'],
            toAccountId: Value(tx['toAccountId']),
            categoryId: Value(tx['categoryId']),
            type: tx['type'],
            amountCents: tx['amountCents'],
            notes: Value(tx['notes']),
            occurredAt: DateTime.parse(tx['occurredAt']),
            createdAt: DateTime.now(),
          ),
        );
      }

      // Restore Budgets
      final List<dynamic> bdgList = data['budgets'] ?? [];
      for (final bdg in bdgList) {
        await _db.into(_db.budgetTable).insert(
          BudgetTableCompanion.insert(
            categoryId: bdg['categoryId'],
            month: bdg['month'],
            limitAmountCents: bdg['limitAmountCents'],
          ),
        );
      }

      print('Backup File Restored Successfully');
      return true;
    } catch (e) {
      print('Failed To Restore Backup File: $e');
      rethrow;
    }
  }
}
