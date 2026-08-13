// Moneta Trail Category Management Repository
// Handles Expense And Income Category Persistence

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Features/Records/Data/RecordsRepository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(databaseProvider));
});

class CategoryRepository {
  final AppDatabase _db;

  CategoryRepository(this._db);

  // Streams Categories Filtered By Type ('Expense' or 'Income')
  Stream<List<Category>> watchCategories(String type) {
    return (_db.select(_db.categoryTable)..where((c) => c.type.equals(type))).watch();
  }

  // Gets All Categories
  Future<List<Category>> getAllCategories() async {
    return _db.select(_db.categoryTable).get();
  }

  // Adds New Custom Category
  Future<int> createCategory({
    required String name,
    required String iconName,
    required String colorHex,
    required String type,
  }) async {
    return await _db.into(_db.categoryTable).insert(
          CategoryTableCompanion.insert(
            name: name,
            iconName: iconName,
            colorHex: colorHex,
            type: type,
          ),
        );
  }

  // Updates Existing Category Details
  Future<void> updateCategory({
    required int id,
    required String name,
    required String iconName,
    String? colorHex,
  }) async {
    await (_db.update(_db.categoryTable)..where((c) => c.id.equals(id))).write(
          CategoryTableCompanion(
            name: Value(name),
            iconName: Value(iconName),
            colorHex: colorHex != null ? Value(colorHex) : const Value.absent(),
          ),
        );
  }

  // Deletes A Custom Category
  Future<void> deleteCategory(int id) async {
    await (_db.delete(_db.categoryTable)..where((c) => c.id.equals(id))).go();
  }
}
