// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// ignore_for_file: type=lint
class $AppProfileTableTable extends AppProfileTable
    with TableInfo<$AppProfileTableTable, AppProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _primaryCurrencyMeta =
      const VerificationMeta('primaryCurrency');
  @override
  late final GeneratedColumn<String> primaryCurrency = GeneratedColumn<String>(
      'primary_currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('USD'));
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('English'));
  static const VerificationMeta _appearanceThemeMeta =
      const VerificationMeta('appearanceTheme');
  @override
  late final GeneratedColumn<String> appearanceTheme = GeneratedColumn<String>(
      'appearance_theme', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Light'));
  static const VerificationMeta _biometricsEnabledMeta =
      const VerificationMeta('biometricsEnabled');
  @override
  late final GeneratedColumn<bool> biometricsEnabled = GeneratedColumn<bool>(
      'biometrics_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("biometrics_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        phoneNumber,
        avatarPath,
        primaryCurrency,
        language,
        appearanceTheme,
        biometricsEnabled,
        pinHash
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_profile_table';
  @override
  VerificationContext validateIntegrity(Insertable<AppProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('primary_currency')) {
      context.handle(
          _primaryCurrencyMeta,
          primaryCurrency.isAcceptableOrUnknown(
              data['primary_currency']!, _primaryCurrencyMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('appearance_theme')) {
      context.handle(
          _appearanceThemeMeta,
          appearanceTheme.isAcceptableOrUnknown(
              data['appearance_theme']!, _appearanceThemeMeta));
    }
    if (data.containsKey('biometrics_enabled')) {
      context.handle(
          _biometricsEnabledMeta,
          biometricsEnabled.isAcceptableOrUnknown(
              data['biometrics_enabled']!, _biometricsEnabledMeta));
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      primaryCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_currency'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      appearanceTheme: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}appearance_theme'])!,
      biometricsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}biometrics_enabled'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash']),
    );
  }

  @override
  $AppProfileTableTable createAlias(String alias) {
    return $AppProfileTableTable(attachedDatabase, alias);
  }
}

class AppProfile extends DataClass implements Insertable<AppProfile> {
  final int id;
  final String username;
  final String? phoneNumber;
  final String? avatarPath;
  final String primaryCurrency;
  final String language;
  final String appearanceTheme;
  final bool biometricsEnabled;
  final String? pinHash;
  const AppProfile(
      {required this.id,
      required this.username,
      this.phoneNumber,
      this.avatarPath,
      required this.primaryCurrency,
      required this.language,
      required this.appearanceTheme,
      required this.biometricsEnabled,
      this.pinHash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['primary_currency'] = Variable<String>(primaryCurrency);
    map['language'] = Variable<String>(language);
    map['appearance_theme'] = Variable<String>(appearanceTheme);
    map['biometrics_enabled'] = Variable<bool>(biometricsEnabled);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    return map;
  }

  AppProfileTableCompanion toCompanion(bool nullToAbsent) {
    return AppProfileTableCompanion(
      id: Value(id),
      username: Value(username),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      primaryCurrency: Value(primaryCurrency),
      language: Value(language),
      appearanceTheme: Value(appearanceTheme),
      biometricsEnabled: Value(biometricsEnabled),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
    );
  }

  factory AppProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppProfile(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      primaryCurrency: serializer.fromJson<String>(json['primaryCurrency']),
      language: serializer.fromJson<String>(json['language']),
      appearanceTheme: serializer.fromJson<String>(json['appearanceTheme']),
      biometricsEnabled: serializer.fromJson<bool>(json['biometricsEnabled']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'primaryCurrency': serializer.toJson<String>(primaryCurrency),
      'language': serializer.toJson<String>(language),
      'appearanceTheme': serializer.toJson<String>(appearanceTheme),
      'biometricsEnabled': serializer.toJson<bool>(biometricsEnabled),
      'pinHash': serializer.toJson<String?>(pinHash),
    };
  }

  AppProfile copyWith(
          {int? id,
          String? username,
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> avatarPath = const Value.absent(),
          String? primaryCurrency,
          String? language,
          String? appearanceTheme,
          bool? biometricsEnabled,
          Value<String?> pinHash = const Value.absent()}) =>
      AppProfile(
        id: id ?? this.id,
        username: username ?? this.username,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        primaryCurrency: primaryCurrency ?? this.primaryCurrency,
        language: language ?? this.language,
        appearanceTheme: appearanceTheme ?? this.appearanceTheme,
        biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
        pinHash: pinHash.present ? pinHash.value : this.pinHash,
      );
  AppProfile copyWithCompanion(AppProfileTableCompanion data) {
    return AppProfile(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      primaryCurrency: data.primaryCurrency.present
          ? data.primaryCurrency.value
          : this.primaryCurrency,
      language: data.language.present ? data.language.value : this.language,
      appearanceTheme: data.appearanceTheme.present
          ? data.appearanceTheme.value
          : this.appearanceTheme,
      biometricsEnabled: data.biometricsEnabled.present
          ? data.biometricsEnabled.value
          : this.biometricsEnabled,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppProfile(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('primaryCurrency: $primaryCurrency, ')
          ..write('language: $language, ')
          ..write('appearanceTheme: $appearanceTheme, ')
          ..write('biometricsEnabled: $biometricsEnabled, ')
          ..write('pinHash: $pinHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, phoneNumber, avatarPath,
      primaryCurrency, language, appearanceTheme, biometricsEnabled, pinHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppProfile &&
          other.id == this.id &&
          other.username == this.username &&
          other.phoneNumber == this.phoneNumber &&
          other.avatarPath == this.avatarPath &&
          other.primaryCurrency == this.primaryCurrency &&
          other.language == this.language &&
          other.appearanceTheme == this.appearanceTheme &&
          other.biometricsEnabled == this.biometricsEnabled &&
          other.pinHash == this.pinHash);
}

class AppProfileTableCompanion extends UpdateCompanion<AppProfile> {
  final Value<int> id;
  final Value<String> username;
  final Value<String?> phoneNumber;
  final Value<String?> avatarPath;
  final Value<String> primaryCurrency;
  final Value<String> language;
  final Value<String> appearanceTheme;
  final Value<bool> biometricsEnabled;
  final Value<String?> pinHash;
  const AppProfileTableCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.primaryCurrency = const Value.absent(),
    this.language = const Value.absent(),
    this.appearanceTheme = const Value.absent(),
    this.biometricsEnabled = const Value.absent(),
    this.pinHash = const Value.absent(),
  });
  AppProfileTableCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    this.phoneNumber = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.primaryCurrency = const Value.absent(),
    this.language = const Value.absent(),
    this.appearanceTheme = const Value.absent(),
    this.biometricsEnabled = const Value.absent(),
    this.pinHash = const Value.absent(),
  }) : username = Value(username);
  static Insertable<AppProfile> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? phoneNumber,
    Expression<String>? avatarPath,
    Expression<String>? primaryCurrency,
    Expression<String>? language,
    Expression<String>? appearanceTheme,
    Expression<bool>? biometricsEnabled,
    Expression<String>? pinHash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (primaryCurrency != null) 'primary_currency': primaryCurrency,
      if (language != null) 'language': language,
      if (appearanceTheme != null) 'appearance_theme': appearanceTheme,
      if (biometricsEnabled != null) 'biometrics_enabled': biometricsEnabled,
      if (pinHash != null) 'pin_hash': pinHash,
    });
  }

  AppProfileTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String?>? phoneNumber,
      Value<String?>? avatarPath,
      Value<String>? primaryCurrency,
      Value<String>? language,
      Value<String>? appearanceTheme,
      Value<bool>? biometricsEnabled,
      Value<String?>? pinHash}) {
    return AppProfileTableCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarPath: avatarPath ?? this.avatarPath,
      primaryCurrency: primaryCurrency ?? this.primaryCurrency,
      language: language ?? this.language,
      appearanceTheme: appearanceTheme ?? this.appearanceTheme,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      pinHash: pinHash ?? this.pinHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (primaryCurrency.present) {
      map['primary_currency'] = Variable<String>(primaryCurrency.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (appearanceTheme.present) {
      map['appearance_theme'] = Variable<String>(appearanceTheme.value);
    }
    if (biometricsEnabled.present) {
      map['biometrics_enabled'] = Variable<bool>(biometricsEnabled.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppProfileTableCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('primaryCurrency: $primaryCurrency, ')
          ..write('language: $language, ')
          ..write('appearanceTheme: $appearanceTheme, ')
          ..write('biometricsEnabled: $biometricsEnabled, ')
          ..write('pinHash: $pinHash')
          ..write(')'))
        .toString();
  }
}

class $FinancialAccountTableTable extends FinancialAccountTable
    with TableInfo<$FinancialAccountTableTable, FinancialAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialAccountTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('account_balance_wallet'));
  static const VerificationMeta _balanceCentsMeta =
      const VerificationMeta('balanceCents');
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
      'balance_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _creditLimitCentsMeta =
      const VerificationMeta('creditLimitCents');
  @override
  late final GeneratedColumn<int> creditLimitCents = GeneratedColumn<int>(
      'credit_limit_cents', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
      'due_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        iconName,
        balanceCents,
        creditLimitCents,
        dueDate,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_account_table';
  @override
  VerificationContext validateIntegrity(Insertable<FinancialAccount> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
          _balanceCentsMeta,
          balanceCents.isAcceptableOrUnknown(
              data['balance_cents']!, _balanceCentsMeta));
    }
    if (data.containsKey('credit_limit_cents')) {
      context.handle(
          _creditLimitCentsMeta,
          creditLimitCents.isAcceptableOrUnknown(
              data['credit_limit_cents']!, _creditLimitCentsMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialAccount(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      balanceCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}balance_cents'])!,
      creditLimitCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}credit_limit_cents']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_date']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $FinancialAccountTableTable createAlias(String alias) {
    return $FinancialAccountTableTable(attachedDatabase, alias);
  }
}

class FinancialAccount extends DataClass
    implements Insertable<FinancialAccount> {
  final int id;
  final String name;
  final String type;
  final String iconName;
  final int balanceCents;
  final int? creditLimitCents;
  final String? dueDate;
  final bool isDeleted;
  const FinancialAccount(
      {required this.id,
      required this.name,
      required this.type,
      required this.iconName,
      required this.balanceCents,
      this.creditLimitCents,
      this.dueDate,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['icon_name'] = Variable<String>(iconName);
    map['balance_cents'] = Variable<int>(balanceCents);
    if (!nullToAbsent || creditLimitCents != null) {
      map['credit_limit_cents'] = Variable<int>(creditLimitCents);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  FinancialAccountTableCompanion toCompanion(bool nullToAbsent) {
    return FinancialAccountTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      iconName: Value(iconName),
      balanceCents: Value(balanceCents),
      creditLimitCents: creditLimitCents == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimitCents),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      isDeleted: Value(isDeleted),
    );
  }

  factory FinancialAccount.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialAccount(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      iconName: serializer.fromJson<String>(json['iconName']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      creditLimitCents: serializer.fromJson<int?>(json['creditLimitCents']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'iconName': serializer.toJson<String>(iconName),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'creditLimitCents': serializer.toJson<int?>(creditLimitCents),
      'dueDate': serializer.toJson<String?>(dueDate),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  FinancialAccount copyWith(
          {int? id,
          String? name,
          String? type,
          String? iconName,
          int? balanceCents,
          Value<int?> creditLimitCents = const Value.absent(),
          Value<String?> dueDate = const Value.absent(),
          bool? isDeleted}) =>
      FinancialAccount(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        iconName: iconName ?? this.iconName,
        balanceCents: balanceCents ?? this.balanceCents,
        creditLimitCents: creditLimitCents.present
            ? creditLimitCents.value
            : this.creditLimitCents,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  FinancialAccount copyWithCompanion(FinancialAccountTableCompanion data) {
    return FinancialAccount(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      creditLimitCents: data.creditLimitCents.present
          ? data.creditLimitCents.value
          : this.creditLimitCents,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialAccount(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iconName: $iconName, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('creditLimitCents: $creditLimitCents, ')
          ..write('dueDate: $dueDate, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, iconName, balanceCents,
      creditLimitCents, dueDate, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialAccount &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.iconName == this.iconName &&
          other.balanceCents == this.balanceCents &&
          other.creditLimitCents == this.creditLimitCents &&
          other.dueDate == this.dueDate &&
          other.isDeleted == this.isDeleted);
}

class FinancialAccountTableCompanion extends UpdateCompanion<FinancialAccount> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> iconName;
  final Value<int> balanceCents;
  final Value<int?> creditLimitCents;
  final Value<String?> dueDate;
  final Value<bool> isDeleted;
  const FinancialAccountTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.iconName = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.creditLimitCents = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  FinancialAccountTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.iconName = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.creditLimitCents = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : name = Value(name),
        type = Value(type);
  static Insertable<FinancialAccount> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? iconName,
    Expression<int>? balanceCents,
    Expression<int>? creditLimitCents,
    Expression<String>? dueDate,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (iconName != null) 'icon_name': iconName,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (creditLimitCents != null) 'credit_limit_cents': creditLimitCents,
      if (dueDate != null) 'due_date': dueDate,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  FinancialAccountTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? iconName,
      Value<int>? balanceCents,
      Value<int?>? creditLimitCents,
      Value<String?>? dueDate,
      Value<bool>? isDeleted}) {
    return FinancialAccountTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iconName: iconName ?? this.iconName,
      balanceCents: balanceCents ?? this.balanceCents,
      creditLimitCents: creditLimitCents ?? this.creditLimitCents,
      dueDate: dueDate ?? this.dueDate,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (creditLimitCents.present) {
      map['credit_limit_cents'] = Variable<int>(creditLimitCents.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialAccountTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iconName: $iconName, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('creditLimitCents: $creditLimitCents, ')
          ..write('dueDate: $dueDate, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $CategoryTableTable extends CategoryTable
    with TableInfo<$CategoryTableTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, iconName, colorHex, type, isDefault];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_table';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
    );
  }

  @override
  $CategoryTableTable createAlias(String alias) {
    return $CategoryTableTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final String iconName;
  final String colorHex;
  final String type;
  final bool isDefault;
  const Category(
      {required this.id,
      required this.name,
      required this.iconName,
      required this.colorHex,
      required this.type,
      required this.isDefault});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon_name'] = Variable<String>(iconName);
    map['color_hex'] = Variable<String>(colorHex);
    map['type'] = Variable<String>(type);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  CategoryTableCompanion toCompanion(bool nullToAbsent) {
    return CategoryTableCompanion(
      id: Value(id),
      name: Value(name),
      iconName: Value(iconName),
      colorHex: Value(colorHex),
      type: Value(type),
      isDefault: Value(isDefault),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      type: serializer.fromJson<String>(json['type']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iconName': serializer.toJson<String>(iconName),
      'colorHex': serializer.toJson<String>(colorHex),
      'type': serializer.toJson<String>(type),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          String? iconName,
          String? colorHex,
          String? type,
          bool? isDefault}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        iconName: iconName ?? this.iconName,
        colorHex: colorHex ?? this.colorHex,
        type: type ?? this.type,
        isDefault: isDefault ?? this.isDefault,
      );
  Category copyWithCompanion(CategoryTableCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      type: data.type.present ? data.type.value : this.type,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('type: $type, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, iconName, colorHex, type, isDefault);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconName == this.iconName &&
          other.colorHex == this.colorHex &&
          other.type == this.type &&
          other.isDefault == this.isDefault);
}

class CategoryTableCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> iconName;
  final Value<String> colorHex;
  final Value<String> type;
  final Value<bool> isDefault;
  const CategoryTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.type = const Value.absent(),
    this.isDefault = const Value.absent(),
  });
  CategoryTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String iconName,
    required String colorHex,
    required String type,
    this.isDefault = const Value.absent(),
  })  : name = Value(name),
        iconName = Value(iconName),
        colorHex = Value(colorHex),
        type = Value(type);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? iconName,
    Expression<String>? colorHex,
    Expression<String>? type,
    Expression<bool>? isDefault,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconName != null) 'icon_name': iconName,
      if (colorHex != null) 'color_hex': colorHex,
      if (type != null) 'type': type,
      if (isDefault != null) 'is_default': isDefault,
    });
  }

  CategoryTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? iconName,
      Value<String>? colorHex,
      Value<String>? type,
      Value<bool>? isDefault}) {
    return CategoryTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('type: $type, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }
}

class $TransactionEntryTableTable extends TransactionEntryTable
    with TableInfo<$TransactionEntryTableTable, TransactionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionEntryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _toAccountIdMeta =
      const VerificationMeta('toAccountId');
  @override
  late final GeneratedColumn<int> toAccountId = GeneratedColumn<int>(
      'to_account_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        toAccountId,
        categoryId,
        type,
        amountCents,
        notes,
        occurredAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_entry_table';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
          _toAccountIdMeta,
          toAccountId.isAcceptableOrUnknown(
              data['to_account_id']!, _toAccountIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      toAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_account_id']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TransactionEntryTableTable createAlias(String alias) {
    return $TransactionEntryTableTable(attachedDatabase, alias);
  }
}

class TransactionEntry extends DataClass
    implements Insertable<TransactionEntry> {
  final int id;
  final int accountId;
  final int? toAccountId;
  final int? categoryId;
  final String type;
  final int amountCents;
  final String? notes;
  final DateTime occurredAt;
  final DateTime createdAt;
  const TransactionEntry(
      {required this.id,
      required this.accountId,
      this.toAccountId,
      this.categoryId,
      required this.type,
      required this.amountCents,
      this.notes,
      required this.occurredAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<int>(toAccountId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['type'] = Variable<String>(type);
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionEntryTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionEntryTableCompanion(
      id: Value(id),
      accountId: Value(accountId),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      type: Value(type),
      amountCents: Value(amountCents),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionEntry(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      toAccountId: serializer.fromJson<int?>(json['toAccountId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      type: serializer.fromJson<String>(json['type']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      notes: serializer.fromJson<String?>(json['notes']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'toAccountId': serializer.toJson<int?>(toAccountId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'type': serializer.toJson<String>(type),
      'amountCents': serializer.toJson<int>(amountCents),
      'notes': serializer.toJson<String?>(notes),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionEntry copyWith(
          {int? id,
          int? accountId,
          Value<int?> toAccountId = const Value.absent(),
          Value<int?> categoryId = const Value.absent(),
          String? type,
          int? amountCents,
          Value<String?> notes = const Value.absent(),
          DateTime? occurredAt,
          DateTime? createdAt}) =>
      TransactionEntry(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        type: type ?? this.type,
        amountCents: amountCents ?? this.amountCents,
        notes: notes.present ? notes.value : this.notes,
        occurredAt: occurredAt ?? this.occurredAt,
        createdAt: createdAt ?? this.createdAt,
      );
  TransactionEntry copyWithCompanion(TransactionEntryTableCompanion data) {
    return TransactionEntry(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      toAccountId:
          data.toAccountId.present ? data.toAccountId.value : this.toAccountId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      type: data.type.present ? data.type.value : this.type,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      notes: data.notes.present ? data.notes.value : this.notes,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionEntry(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('notes: $notes, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, toAccountId, categoryId, type,
      amountCents, notes, occurredAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionEntry &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.toAccountId == this.toAccountId &&
          other.categoryId == this.categoryId &&
          other.type == this.type &&
          other.amountCents == this.amountCents &&
          other.notes == this.notes &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt);
}

class TransactionEntryTableCompanion extends UpdateCompanion<TransactionEntry> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int?> toAccountId;
  final Value<int?> categoryId;
  final Value<String> type;
  final Value<int> amountCents;
  final Value<String?> notes;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  const TransactionEntryTableCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.notes = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionEntryTableCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    this.toAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    required String type,
    required int amountCents,
    this.notes = const Value.absent(),
    required DateTime occurredAt,
    required DateTime createdAt,
  })  : accountId = Value(accountId),
        type = Value(type),
        amountCents = Value(amountCents),
        occurredAt = Value(occurredAt),
        createdAt = Value(createdAt);
  static Insertable<TransactionEntry> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? toAccountId,
    Expression<int>? categoryId,
    Expression<String>? type,
    Expression<int>? amountCents,
    Expression<String>? notes,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (categoryId != null) 'category_id': categoryId,
      if (type != null) 'type': type,
      if (amountCents != null) 'amount_cents': amountCents,
      if (notes != null) 'notes': notes,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionEntryTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? accountId,
      Value<int?>? toAccountId,
      Value<int?>? categoryId,
      Value<String>? type,
      Value<int>? amountCents,
      Value<String?>? notes,
      Value<DateTime>? occurredAt,
      Value<DateTime>? createdAt}) {
    return TransactionEntryTableCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      amountCents: amountCents ?? this.amountCents,
      notes: notes ?? this.notes,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<int>(toAccountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionEntryTableCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('notes: $notes, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetTableTable extends BudgetTable
    with TableInfo<$BudgetTableTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
      'month', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _limitAmountCentsMeta =
      const VerificationMeta('limitAmountCents');
  @override
  late final GeneratedColumn<int> limitAmountCents = GeneratedColumn<int>(
      'limit_amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, month, limitAmountCents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_table';
  @override
  VerificationContext validateIntegrity(Insertable<Budget> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('limit_amount_cents')) {
      context.handle(
          _limitAmountCentsMeta,
          limitAmountCents.isAcceptableOrUnknown(
              data['limit_amount_cents']!, _limitAmountCentsMeta));
    } else if (isInserting) {
      context.missing(_limitAmountCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}month'])!,
      limitAmountCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}limit_amount_cents'])!,
    );
  }

  @override
  $BudgetTableTable createAlias(String alias) {
    return $BudgetTableTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final int id;
  final int categoryId;
  final String month;
  final int limitAmountCents;
  const Budget(
      {required this.id,
      required this.categoryId,
      required this.month,
      required this.limitAmountCents});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['month'] = Variable<String>(month);
    map['limit_amount_cents'] = Variable<int>(limitAmountCents);
    return map;
  }

  BudgetTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetTableCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      month: Value(month),
      limitAmountCents: Value(limitAmountCents),
    );
  }

  factory Budget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      month: serializer.fromJson<String>(json['month']),
      limitAmountCents: serializer.fromJson<int>(json['limitAmountCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'month': serializer.toJson<String>(month),
      'limitAmountCents': serializer.toJson<int>(limitAmountCents),
    };
  }

  Budget copyWith(
          {int? id, int? categoryId, String? month, int? limitAmountCents}) =>
      Budget(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        month: month ?? this.month,
        limitAmountCents: limitAmountCents ?? this.limitAmountCents,
      );
  Budget copyWithCompanion(BudgetTableCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      month: data.month.present ? data.month.value : this.month,
      limitAmountCents: data.limitAmountCents.present
          ? data.limitAmountCents.value
          : this.limitAmountCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('month: $month, ')
          ..write('limitAmountCents: $limitAmountCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, month, limitAmountCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.month == this.month &&
          other.limitAmountCents == this.limitAmountCents);
}

class BudgetTableCompanion extends UpdateCompanion<Budget> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> month;
  final Value<int> limitAmountCents;
  const BudgetTableCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.month = const Value.absent(),
    this.limitAmountCents = const Value.absent(),
  });
  BudgetTableCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String month,
    required int limitAmountCents,
  })  : categoryId = Value(categoryId),
        month = Value(month),
        limitAmountCents = Value(limitAmountCents);
  static Insertable<Budget> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? month,
    Expression<int>? limitAmountCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (month != null) 'month': month,
      if (limitAmountCents != null) 'limit_amount_cents': limitAmountCents,
    });
  }

  BudgetTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String>? month,
      Value<int>? limitAmountCents}) {
    return BudgetTableCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      month: month ?? this.month,
      limitAmountCents: limitAmountCents ?? this.limitAmountCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (limitAmountCents.present) {
      map['limit_amount_cents'] = Variable<int>(limitAmountCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetTableCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('month: $month, ')
          ..write('limitAmountCents: $limitAmountCents')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppProfileTableTable appProfileTable =
      $AppProfileTableTable(this);
  late final $FinancialAccountTableTable financialAccountTable =
      $FinancialAccountTableTable(this);
  late final $CategoryTableTable categoryTable = $CategoryTableTable(this);
  late final $TransactionEntryTableTable transactionEntryTable =
      $TransactionEntryTableTable(this);
  late final $BudgetTableTable budgetTable = $BudgetTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        appProfileTable,
        financialAccountTable,
        categoryTable,
        transactionEntryTable,
        budgetTable
      ];
}

typedef $$AppProfileTableTableCreateCompanionBuilder = AppProfileTableCompanion
    Function({
  Value<int> id,
  required String username,
  Value<String?> phoneNumber,
  Value<String?> avatarPath,
  Value<String> primaryCurrency,
  Value<String> language,
  Value<String> appearanceTheme,
  Value<bool> biometricsEnabled,
  Value<String?> pinHash,
});
typedef $$AppProfileTableTableUpdateCompanionBuilder = AppProfileTableCompanion
    Function({
  Value<int> id,
  Value<String> username,
  Value<String?> phoneNumber,
  Value<String?> avatarPath,
  Value<String> primaryCurrency,
  Value<String> language,
  Value<String> appearanceTheme,
  Value<bool> biometricsEnabled,
  Value<String?> pinHash,
});

class $$AppProfileTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppProfileTableTable,
    AppProfile,
    $$AppProfileTableTableFilterComposer,
    $$AppProfileTableTableOrderingComposer,
    $$AppProfileTableTableCreateCompanionBuilder,
    $$AppProfileTableTableUpdateCompanionBuilder> {
  $$AppProfileTableTableTableManager(
      _$AppDatabase db, $AppProfileTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AppProfileTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AppProfileTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<String> primaryCurrency = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> appearanceTheme = const Value.absent(),
            Value<bool> biometricsEnabled = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
          }) =>
              AppProfileTableCompanion(
            id: id,
            username: username,
            phoneNumber: phoneNumber,
            avatarPath: avatarPath,
            primaryCurrency: primaryCurrency,
            language: language,
            appearanceTheme: appearanceTheme,
            biometricsEnabled: biometricsEnabled,
            pinHash: pinHash,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<String> primaryCurrency = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> appearanceTheme = const Value.absent(),
            Value<bool> biometricsEnabled = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
          }) =>
              AppProfileTableCompanion.insert(
            id: id,
            username: username,
            phoneNumber: phoneNumber,
            avatarPath: avatarPath,
            primaryCurrency: primaryCurrency,
            language: language,
            appearanceTheme: appearanceTheme,
            biometricsEnabled: biometricsEnabled,
            pinHash: pinHash,
          ),
        ));
}

class $$AppProfileTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AppProfileTableTable> {
  $$AppProfileTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phoneNumber => $state.composableBuilder(
      column: $state.table.phoneNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get avatarPath => $state.composableBuilder(
      column: $state.table.avatarPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get primaryCurrency => $state.composableBuilder(
      column: $state.table.primaryCurrency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get language => $state.composableBuilder(
      column: $state.table.language,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get appearanceTheme => $state.composableBuilder(
      column: $state.table.appearanceTheme,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get biometricsEnabled => $state.composableBuilder(
      column: $state.table.biometricsEnabled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pinHash => $state.composableBuilder(
      column: $state.table.pinHash,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AppProfileTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AppProfileTableTable> {
  $$AppProfileTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phoneNumber => $state.composableBuilder(
      column: $state.table.phoneNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get avatarPath => $state.composableBuilder(
      column: $state.table.avatarPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get primaryCurrency => $state.composableBuilder(
      column: $state.table.primaryCurrency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get language => $state.composableBuilder(
      column: $state.table.language,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get appearanceTheme => $state.composableBuilder(
      column: $state.table.appearanceTheme,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get biometricsEnabled => $state.composableBuilder(
      column: $state.table.biometricsEnabled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pinHash => $state.composableBuilder(
      column: $state.table.pinHash,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$FinancialAccountTableTableCreateCompanionBuilder
    = FinancialAccountTableCompanion Function({
  Value<int> id,
  required String name,
  required String type,
  Value<String> iconName,
  Value<int> balanceCents,
  Value<int?> creditLimitCents,
  Value<String?> dueDate,
  Value<bool> isDeleted,
});
typedef $$FinancialAccountTableTableUpdateCompanionBuilder
    = FinancialAccountTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> type,
  Value<String> iconName,
  Value<int> balanceCents,
  Value<int?> creditLimitCents,
  Value<String?> dueDate,
  Value<bool> isDeleted,
});

class $$FinancialAccountTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinancialAccountTableTable,
    FinancialAccount,
    $$FinancialAccountTableTableFilterComposer,
    $$FinancialAccountTableTableOrderingComposer,
    $$FinancialAccountTableTableCreateCompanionBuilder,
    $$FinancialAccountTableTableUpdateCompanionBuilder> {
  $$FinancialAccountTableTableTableManager(
      _$AppDatabase db, $FinancialAccountTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$FinancialAccountTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$FinancialAccountTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<int> balanceCents = const Value.absent(),
            Value<int?> creditLimitCents = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              FinancialAccountTableCompanion(
            id: id,
            name: name,
            type: type,
            iconName: iconName,
            balanceCents: balanceCents,
            creditLimitCents: creditLimitCents,
            dueDate: dueDate,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String type,
            Value<String> iconName = const Value.absent(),
            Value<int> balanceCents = const Value.absent(),
            Value<int?> creditLimitCents = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              FinancialAccountTableCompanion.insert(
            id: id,
            name: name,
            type: type,
            iconName: iconName,
            balanceCents: balanceCents,
            creditLimitCents: creditLimitCents,
            dueDate: dueDate,
            isDeleted: isDeleted,
          ),
        ));
}

class $$FinancialAccountTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FinancialAccountTableTable> {
  $$FinancialAccountTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get iconName => $state.composableBuilder(
      column: $state.table.iconName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get balanceCents => $state.composableBuilder(
      column: $state.table.balanceCents,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get creditLimitCents => $state.composableBuilder(
      column: $state.table.creditLimitCents,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dueDate => $state.composableBuilder(
      column: $state.table.dueDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$FinancialAccountTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FinancialAccountTableTable> {
  $$FinancialAccountTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get iconName => $state.composableBuilder(
      column: $state.table.iconName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get balanceCents => $state.composableBuilder(
      column: $state.table.balanceCents,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get creditLimitCents => $state.composableBuilder(
      column: $state.table.creditLimitCents,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dueDate => $state.composableBuilder(
      column: $state.table.dueDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CategoryTableTableCreateCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String iconName,
  required String colorHex,
  required String type,
  Value<bool> isDefault,
});
typedef $$CategoryTableTableUpdateCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> iconName,
  Value<String> colorHex,
  Value<String> type,
  Value<bool> isDefault,
});

class $$CategoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoryTableTable,
    Category,
    $$CategoryTableTableFilterComposer,
    $$CategoryTableTableOrderingComposer,
    $$CategoryTableTableCreateCompanionBuilder,
    $$CategoryTableTableUpdateCompanionBuilder> {
  $$CategoryTableTableTableManager(_$AppDatabase db, $CategoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoryTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoryTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
          }) =>
              CategoryTableCompanion(
            id: id,
            name: name,
            iconName: iconName,
            colorHex: colorHex,
            type: type,
            isDefault: isDefault,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String iconName,
            required String colorHex,
            required String type,
            Value<bool> isDefault = const Value.absent(),
          }) =>
              CategoryTableCompanion.insert(
            id: id,
            name: name,
            iconName: iconName,
            colorHex: colorHex,
            type: type,
            isDefault: isDefault,
          ),
        ));
}

class $$CategoryTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoryTableTable> {
  $$CategoryTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get iconName => $state.composableBuilder(
      column: $state.table.iconName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get colorHex => $state.composableBuilder(
      column: $state.table.colorHex,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDefault => $state.composableBuilder(
      column: $state.table.isDefault,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CategoryTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoryTableTable> {
  $$CategoryTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get iconName => $state.composableBuilder(
      column: $state.table.iconName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get colorHex => $state.composableBuilder(
      column: $state.table.colorHex,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDefault => $state.composableBuilder(
      column: $state.table.isDefault,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TransactionEntryTableTableCreateCompanionBuilder
    = TransactionEntryTableCompanion Function({
  Value<int> id,
  required int accountId,
  Value<int?> toAccountId,
  Value<int?> categoryId,
  required String type,
  required int amountCents,
  Value<String?> notes,
  required DateTime occurredAt,
  required DateTime createdAt,
});
typedef $$TransactionEntryTableTableUpdateCompanionBuilder
    = TransactionEntryTableCompanion Function({
  Value<int> id,
  Value<int> accountId,
  Value<int?> toAccountId,
  Value<int?> categoryId,
  Value<String> type,
  Value<int> amountCents,
  Value<String?> notes,
  Value<DateTime> occurredAt,
  Value<DateTime> createdAt,
});

class $$TransactionEntryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionEntryTableTable,
    TransactionEntry,
    $$TransactionEntryTableTableFilterComposer,
    $$TransactionEntryTableTableOrderingComposer,
    $$TransactionEntryTableTableCreateCompanionBuilder,
    $$TransactionEntryTableTableUpdateCompanionBuilder> {
  $$TransactionEntryTableTableTableManager(
      _$AppDatabase db, $TransactionEntryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$TransactionEntryTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$TransactionEntryTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<int?> toAccountId = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TransactionEntryTableCompanion(
            id: id,
            accountId: accountId,
            toAccountId: toAccountId,
            categoryId: categoryId,
            type: type,
            amountCents: amountCents,
            notes: notes,
            occurredAt: occurredAt,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int accountId,
            Value<int?> toAccountId = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            required String type,
            required int amountCents,
            Value<String?> notes = const Value.absent(),
            required DateTime occurredAt,
            required DateTime createdAt,
          }) =>
              TransactionEntryTableCompanion.insert(
            id: id,
            accountId: accountId,
            toAccountId: toAccountId,
            categoryId: categoryId,
            type: type,
            amountCents: amountCents,
            notes: notes,
            occurredAt: occurredAt,
            createdAt: createdAt,
          ),
        ));
}

class $$TransactionEntryTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TransactionEntryTableTable> {
  $$TransactionEntryTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get accountId => $state.composableBuilder(
      column: $state.table.accountId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get toAccountId => $state.composableBuilder(
      column: $state.table.toAccountId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get amountCents => $state.composableBuilder(
      column: $state.table.amountCents,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get occurredAt => $state.composableBuilder(
      column: $state.table.occurredAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TransactionEntryTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TransactionEntryTableTable> {
  $$TransactionEntryTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get accountId => $state.composableBuilder(
      column: $state.table.accountId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get toAccountId => $state.composableBuilder(
      column: $state.table.toAccountId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get amountCents => $state.composableBuilder(
      column: $state.table.amountCents,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get occurredAt => $state.composableBuilder(
      column: $state.table.occurredAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BudgetTableTableCreateCompanionBuilder = BudgetTableCompanion
    Function({
  Value<int> id,
  required int categoryId,
  required String month,
  required int limitAmountCents,
});
typedef $$BudgetTableTableUpdateCompanionBuilder = BudgetTableCompanion
    Function({
  Value<int> id,
  Value<int> categoryId,
  Value<String> month,
  Value<int> limitAmountCents,
});

class $$BudgetTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetTableTable,
    Budget,
    $$BudgetTableTableFilterComposer,
    $$BudgetTableTableOrderingComposer,
    $$BudgetTableTableCreateCompanionBuilder,
    $$BudgetTableTableUpdateCompanionBuilder> {
  $$BudgetTableTableTableManager(_$AppDatabase db, $BudgetTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BudgetTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BudgetTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> month = const Value.absent(),
            Value<int> limitAmountCents = const Value.absent(),
          }) =>
              BudgetTableCompanion(
            id: id,
            categoryId: categoryId,
            month: month,
            limitAmountCents: limitAmountCents,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required String month,
            required int limitAmountCents,
          }) =>
              BudgetTableCompanion.insert(
            id: id,
            categoryId: categoryId,
            month: month,
            limitAmountCents: limitAmountCents,
          ),
        ));
}

class $$BudgetTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BudgetTableTable> {
  $$BudgetTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get month => $state.composableBuilder(
      column: $state.table.month,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get limitAmountCents => $state.composableBuilder(
      column: $state.table.limitAmountCents,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BudgetTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BudgetTableTable> {
  $$BudgetTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get month => $state.composableBuilder(
      column: $state.table.month,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get limitAmountCents => $state.composableBuilder(
      column: $state.table.limitAmountCents,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppProfileTableTableTableManager get appProfileTable =>
      $$AppProfileTableTableTableManager(_db, _db.appProfileTable);
  $$FinancialAccountTableTableTableManager get financialAccountTable =>
      $$FinancialAccountTableTableTableManager(_db, _db.financialAccountTable);
  $$CategoryTableTableTableManager get categoryTable =>
      $$CategoryTableTableTableManager(_db, _db.categoryTable);
  $$TransactionEntryTableTableTableManager get transactionEntryTable =>
      $$TransactionEntryTableTableTableManager(_db, _db.transactionEntryTable);
  $$BudgetTableTableTableManager get budgetTable =>
      $$BudgetTableTableTableManager(_db, _db.budgetTable);
}
