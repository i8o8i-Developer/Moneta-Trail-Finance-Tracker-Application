// Moneta Trail User Profile Drift Table Definition
// Stores Local User Profile Settings, Currency, And App Lock Preferences

import 'package:drift/drift.dart';

@DataClassName('AppProfile')
class AppProfileTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 1, max: 100)();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get avatarPath => text().nullable()();
  TextColumn get primaryCurrency => text().withDefault(const Constant('USD'))();
  TextColumn get language => text().withDefault(const Constant('English'))();
  TextColumn get appearanceTheme => text().withDefault(const Constant('Light'))();
  BoolColumn get biometricsEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get pinHash => text().nullable()();
}
