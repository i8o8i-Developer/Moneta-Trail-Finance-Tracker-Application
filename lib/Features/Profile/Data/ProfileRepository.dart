// Moneta Trail Profile And Security Repository
// Manages User Settings, App Lock Toggles, And Data Reset Operations

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Features/Records/Data/RecordsRepository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(databaseProvider));
});

class ProfileRepository {
  final AppDatabase _db;

  ProfileRepository(this._db);

  // Streams User Profile Record
  Stream<AppProfile?> watchProfile() {
    return (_db.select(_db.appProfileTable)..limit(1)).watchSingleOrNull();
  }

  // Directly Fetches User Profile Record safely
  Future<AppProfile?> getProfileDirect() async {
    try {
      var profile = await (_db.select(_db.appProfileTable)..limit(1)).getSingleOrNull();
      if (profile == null) {
        final id = await _db.into(_db.appProfileTable).insert(
          AppProfileTableCompanion.insert(
            username: 'Moneta Trail User',
            primaryCurrency: const Value('USD'),
            appearanceTheme: const Value('Dark'),
            biometricsEnabled: const Value(false),
          ),
        );
        profile = await (_db.select(_db.appProfileTable)..where((p) => p.id.equals(id))).getSingleOrNull();
      }
      return profile;
    } catch (e) {
      print('Error querying profile: $e');
      return null;
    }
  }

  // Updates User Profile Settings
  Future<void> updateProfile({
    String? username,
    String? phoneNumber,
    String? primaryCurrency,
    String? appearanceTheme,
    bool? biometricsEnabled,
    String? pinHash,
  }) async {
    print('Updating User Profile Settings In Local Database');
    final profile = await (_db.select(_db.appProfileTable)..limit(1)).getSingleOrNull();
    if (profile != null) {
      await (_db.update(_db.appProfileTable)..where((p) => p.id.equals(profile.id))).write(
        AppProfileTableCompanion(
          username: username != null ? Value(username) : const Value.absent(),
          phoneNumber: phoneNumber != null ? Value(phoneNumber) : const Value.absent(),
          primaryCurrency: primaryCurrency != null ? Value(primaryCurrency) : const Value.absent(),
          appearanceTheme: appearanceTheme != null ? Value(appearanceTheme) : const Value.absent(),
          biometricsEnabled: biometricsEnabled != null ? Value(biometricsEnabled) : const Value.absent(),
          pinHash: pinHash != null ? Value(pinHash) : const Value.absent(),
        ),
      );
    } else {
      await _db.into(_db.appProfileTable).insert(
        AppProfileTableCompanion.insert(
          username: username ?? 'Moneta Trail User',
          phoneNumber: Value(phoneNumber),
          primaryCurrency: Value(primaryCurrency ?? 'USD'),
          appearanceTheme: Value(appearanceTheme ?? 'Light'),
          biometricsEnabled: Value(biometricsEnabled ?? false),
          pinHash: Value(pinHash),
        ),
      );
    }
  }

  // Danger Zone: Wipes All Data From Database
  Future<void> resetAllLocalData() async {
    print('Resetting All Local Application Data');
    await _db.delete(_db.transactionEntryTable).go();
    await _db.delete(_db.budgetTable).go();
    await _db.delete(_db.categoryTable).go();
    await _db.delete(_db.financialAccountTable).go();
    await _db.delete(_db.appProfileTable).go();
  }
}
