// dart format width=80
// ignore_for_file: type=lint
part of 'app_database.dart';

class $TopicsTable extends Topics with TableInfo<$TopicsTable, Topic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES topics (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    parentId,
    name,
    subject,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'topics';
  @override
  VerificationContext validateIntegrity(
    Insertable<Topic> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['sort_order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Topic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Topic(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TopicsTable createAlias(String alias) {
    return $TopicsTable(attachedDatabase, alias);
  }
}

class Topic extends DataClass implements Insertable<Topic> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String? parentId;
  final String name;
  final String? subject;
  final int order;
  const Topic({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    this.parentId,
    required this.name,
    this.subject,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || subject != null) {
      map['subject'] = Variable<String>(subject);
    }
    map['sort_order'] = Variable<int>(order);
    return map;
  }

  TopicsCompanion toCompanion(bool nullToAbsent) {
    return TopicsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      subject: subject == null && nullToAbsent
          ? const Value.absent()
          : Value(subject),
      order: Value(order),
    );
  }

  factory Topic.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Topic(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      subject: serializer.fromJson<String?>(json['subject']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'parentId': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'subject': serializer.toJson<String?>(subject),
      'order': serializer.toJson<int>(order),
    };
  }

  Topic copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    Value<String?> parentId = const Value.absent(),
    String? name,
    Value<String?> subject = const Value.absent(),
    int? order,
  }) => Topic(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    subject: subject.present ? subject.value : this.subject,
    order: order ?? this.order,
  );
  Topic copyWithCompanion(TopicsCompanion data) {
    return Topic(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      subject: data.subject.present ? data.subject.value : this.subject,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Topic(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('subject: $subject, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    parentId,
    name,
    subject,
    order,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Topic &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.subject == this.subject &&
          other.order == this.order);
}

class TopicsCompanion extends UpdateCompanion<Topic> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<String?> subject;
  final Value<int> order;
  final Value<int> rowid;
  const TopicsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.subject = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TopicsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    this.parentId = const Value.absent(),
    required String name,
    this.subject = const Value.absent(),
    required int order,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       name = Value(name),
       order = Value(order);
  static Insertable<Topic> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<String>? subject,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (subject != null) 'subject': subject,
      if (order != null) 'sort_order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TopicsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String?>? parentId,
    Value<String>? name,
    Value<String?>? subject,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return TopicsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (order.present) {
      map['sort_order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TopicsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('subject: $subject, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourcesTable extends Sources with TableInfo<$SourcesTable, Source> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SourceType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SourceType>($SourcesTable.$convertertype);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
    'uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UnitType, String> unitType =
      GeneratedColumn<String>(
        'unit_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<UnitType>($SourcesTable.$converterunitType);
  static const VerificationMeta _totalUnitsMeta = const VerificationMeta(
    'totalUnits',
  );
  @override
  late final GeneratedColumn<int> totalUnits = GeneratedColumn<int>(
    'total_units',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    type,
    title,
    uri,
    unitType,
    totalUnits,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<Source> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('uri')) {
      context.handle(
        _uriMeta,
        uri.isAcceptableOrUnknown(data['uri']!, _uriMeta),
      );
    }
    if (data.containsKey('total_units')) {
      context.handle(
        _totalUnitsMeta,
        totalUnits.isAcceptableOrUnknown(data['total_units']!, _totalUnitsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Source map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Source(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      type: $SourcesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      uri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uri'],
      ),
      unitType: $SourcesTable.$converterunitType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit_type'],
        )!,
      ),
      totalUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_units'],
      ),
    );
  }

  @override
  $SourcesTable createAlias(String alias) {
    return $SourcesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SourceType, String, String> $convertertype =
      const EnumNameConverter<SourceType>(SourceType.values);
  static JsonTypeConverter2<UnitType, String, String> $converterunitType =
      const EnumNameConverter<UnitType>(UnitType.values);
}

class Source extends DataClass implements Insertable<Source> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final SourceType type;
  final String title;
  final String? uri;
  final UnitType unitType;
  final int? totalUnits;
  const Source({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.type,
    required this.title,
    this.uri,
    required this.unitType,
    this.totalUnits,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    {
      map['type'] = Variable<String>($SourcesTable.$convertertype.toSql(type));
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || uri != null) {
      map['uri'] = Variable<String>(uri);
    }
    {
      map['unit_type'] = Variable<String>(
        $SourcesTable.$converterunitType.toSql(unitType),
      );
    }
    if (!nullToAbsent || totalUnits != null) {
      map['total_units'] = Variable<int>(totalUnits);
    }
    return map;
  }

  SourcesCompanion toCompanion(bool nullToAbsent) {
    return SourcesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      type: Value(type),
      title: Value(title),
      uri: uri == null && nullToAbsent ? const Value.absent() : Value(uri),
      unitType: Value(unitType),
      totalUnits: totalUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(totalUnits),
    );
  }

  factory Source.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Source(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      type: $SourcesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      title: serializer.fromJson<String>(json['title']),
      uri: serializer.fromJson<String?>(json['uri']),
      unitType: $SourcesTable.$converterunitType.fromJson(
        serializer.fromJson<String>(json['unitType']),
      ),
      totalUnits: serializer.fromJson<int?>(json['totalUnits']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'type': serializer.toJson<String>(
        $SourcesTable.$convertertype.toJson(type),
      ),
      'title': serializer.toJson<String>(title),
      'uri': serializer.toJson<String?>(uri),
      'unitType': serializer.toJson<String>(
        $SourcesTable.$converterunitType.toJson(unitType),
      ),
      'totalUnits': serializer.toJson<int?>(totalUnits),
    };
  }

  Source copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    SourceType? type,
    String? title,
    Value<String?> uri = const Value.absent(),
    UnitType? unitType,
    Value<int?> totalUnits = const Value.absent(),
  }) => Source(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    type: type ?? this.type,
    title: title ?? this.title,
    uri: uri.present ? uri.value : this.uri,
    unitType: unitType ?? this.unitType,
    totalUnits: totalUnits.present ? totalUnits.value : this.totalUnits,
  );
  Source copyWithCompanion(SourcesCompanion data) {
    return Source(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      uri: data.uri.present ? data.uri.value : this.uri,
      unitType: data.unitType.present ? data.unitType.value : this.unitType,
      totalUnits: data.totalUnits.present
          ? data.totalUnits.value
          : this.totalUnits,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Source(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('uri: $uri, ')
          ..write('unitType: $unitType, ')
          ..write('totalUnits: $totalUnits')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    type,
    title,
    uri,
    unitType,
    totalUnits,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Source &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.type == this.type &&
          other.title == this.title &&
          other.uri == this.uri &&
          other.unitType == this.unitType &&
          other.totalUnits == this.totalUnits);
}

class SourcesCompanion extends UpdateCompanion<Source> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<SourceType> type;
  final Value<String> title;
  final Value<String?> uri;
  final Value<UnitType> unitType;
  final Value<int?> totalUnits;
  final Value<int> rowid;
  const SourcesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.uri = const Value.absent(),
    this.unitType = const Value.absent(),
    this.totalUnits = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourcesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required SourceType type,
    required String title,
    this.uri = const Value.absent(),
    required UnitType unitType,
    this.totalUnits = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       type = Value(type),
       title = Value(title),
       unitType = Value(unitType);
  static Insertable<Source> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? uri,
    Expression<String>? unitType,
    Expression<int>? totalUnits,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (uri != null) 'uri': uri,
      if (unitType != null) 'unit_type': unitType,
      if (totalUnits != null) 'total_units': totalUnits,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourcesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<SourceType>? type,
    Value<String>? title,
    Value<String?>? uri,
    Value<UnitType>? unitType,
    Value<int?>? totalUnits,
    Value<int>? rowid,
  }) {
    return SourcesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      title: title ?? this.title,
      uri: uri ?? this.uri,
      unitType: unitType ?? this.unitType,
      totalUnits: totalUnits ?? this.totalUnits,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $SourcesTable.$convertertype.toSql(type.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (unitType.present) {
      map['unit_type'] = Variable<String>(
        $SourcesTable.$converterunitType.toSql(unitType.value),
      );
    }
    if (totalUnits.present) {
      map['total_units'] = Variable<int>(totalUnits.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('uri: $uri, ')
          ..write('unitType: $unitType, ')
          ..write('totalUnits: $totalUnits, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceFilesTable extends SourceFiles
    with TableInfo<$SourceFilesTable, SourceFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sources (id)',
    ),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<int> bytes = GeneratedColumn<int>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    sourceId,
    localPath,
    bytes,
    sha256,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
    );
  }

  @override
  $SourceFilesTable createAlias(String alias) {
    return $SourceFilesTable(attachedDatabase, alias);
  }
}

class SourceFile extends DataClass implements Insertable<SourceFile> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String sourceId;

  /// Relative to the app documents directory.
  final String localPath;
  final int bytes;
  final String sha256;
  const SourceFile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.sourceId,
    required this.localPath,
    required this.bytes,
    required this.sha256,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['source_id'] = Variable<String>(sourceId);
    map['local_path'] = Variable<String>(localPath);
    map['bytes'] = Variable<int>(bytes);
    map['sha256'] = Variable<String>(sha256);
    return map;
  }

  SourceFilesCompanion toCompanion(bool nullToAbsent) {
    return SourceFilesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      sourceId: Value(sourceId),
      localPath: Value(localPath),
      bytes: Value(bytes),
      sha256: Value(sha256),
    );
  }

  factory SourceFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceFile(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      bytes: serializer.fromJson<int>(json['bytes']),
      sha256: serializer.fromJson<String>(json['sha256']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'sourceId': serializer.toJson<String>(sourceId),
      'localPath': serializer.toJson<String>(localPath),
      'bytes': serializer.toJson<int>(bytes),
      'sha256': serializer.toJson<String>(sha256),
    };
  }

  SourceFile copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? sourceId,
    String? localPath,
    int? bytes,
    String? sha256,
  }) => SourceFile(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    sourceId: sourceId ?? this.sourceId,
    localPath: localPath ?? this.localPath,
    bytes: bytes ?? this.bytes,
    sha256: sha256 ?? this.sha256,
  );
  SourceFile copyWithCompanion(SourceFilesCompanion data) {
    return SourceFile(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceFile(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('sourceId: $sourceId, ')
          ..write('localPath: $localPath, ')
          ..write('bytes: $bytes, ')
          ..write('sha256: $sha256')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    sourceId,
    localPath,
    bytes,
    sha256,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceFile &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.sourceId == this.sourceId &&
          other.localPath == this.localPath &&
          other.bytes == this.bytes &&
          other.sha256 == this.sha256);
}

class SourceFilesCompanion extends UpdateCompanion<SourceFile> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> sourceId;
  final Value<String> localPath;
  final Value<int> bytes;
  final Value<String> sha256;
  final Value<int> rowid;
  const SourceFilesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.bytes = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceFilesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String sourceId,
    required String localPath,
    required int bytes,
    required String sha256,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       sourceId = Value(sourceId),
       localPath = Value(localPath),
       bytes = Value(bytes),
       sha256 = Value(sha256);
  static Insertable<SourceFile> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? sourceId,
    Expression<String>? localPath,
    Expression<int>? bytes,
    Expression<String>? sha256,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (sourceId != null) 'source_id': sourceId,
      if (localPath != null) 'local_path': localPath,
      if (bytes != null) 'bytes': bytes,
      if (sha256 != null) 'sha256': sha256,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceFilesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? sourceId,
    Value<String>? localPath,
    Value<int>? bytes,
    Value<String>? sha256,
    Value<int>? rowid,
  }) {
    return SourceFilesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      sourceId: sourceId ?? this.sourceId,
      localPath: localPath ?? this.localPath,
      bytes: bytes ?? this.bytes,
      sha256: sha256 ?? this.sha256,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (bytes.present) {
      map['bytes'] = Variable<int>(bytes.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceFilesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('sourceId: $sourceId, ')
          ..write('localPath: $localPath, ')
          ..write('bytes: $bytes, ')
          ..write('sha256: $sha256, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChunksTable extends Chunks with TableInfo<$ChunksTable, Chunk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChunksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sources (id)',
    ),
  );
  static const VerificationMeta _parentChunkIdMeta = const VerificationMeta(
    'parentChunkId',
  );
  @override
  late final GeneratedColumn<String> parentChunkId = GeneratedColumn<String>(
    'parent_chunk_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chunks (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startUnitMeta = const VerificationMeta(
    'startUnit',
  );
  @override
  late final GeneratedColumn<int> startUnit = GeneratedColumn<int>(
    'start_unit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endUnitMeta = const VerificationMeta(
    'endUnit',
  );
  @override
  late final GeneratedColumn<int> endUnit = GeneratedColumn<int>(
    'end_unit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeUnitsMeta = const VerificationMeta(
    'sizeUnits',
  );
  @override
  late final GeneratedColumn<int> sizeUnits = GeneratedColumn<int>(
    'size_units',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    sourceId,
    parentChunkId,
    title,
    order,
    startUnit,
    endUnit,
    sizeUnits,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chunks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chunk> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('parent_chunk_id')) {
      context.handle(
        _parentChunkIdMeta,
        parentChunkId.isAcceptableOrUnknown(
          data['parent_chunk_id']!,
          _parentChunkIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['sort_order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('start_unit')) {
      context.handle(
        _startUnitMeta,
        startUnit.isAcceptableOrUnknown(data['start_unit']!, _startUnitMeta),
      );
    }
    if (data.containsKey('end_unit')) {
      context.handle(
        _endUnitMeta,
        endUnit.isAcceptableOrUnknown(data['end_unit']!, _endUnitMeta),
      );
    }
    if (data.containsKey('size_units')) {
      context.handle(
        _sizeUnitsMeta,
        sizeUnits.isAcceptableOrUnknown(data['size_units']!, _sizeUnitsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chunk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chunk(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      parentChunkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_chunk_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      startUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_unit'],
      ),
      endUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_unit'],
      ),
      sizeUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_units'],
      ),
    );
  }

  @override
  $ChunksTable createAlias(String alias) {
    return $ChunksTable(attachedDatabase, alias);
  }
}

class Chunk extends DataClass implements Insertable<Chunk> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String sourceId;
  final String? parentChunkId;
  final String title;
  final int order;
  final int? startUnit;
  final int? endUnit;
  final int? sizeUnits;
  const Chunk({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.sourceId,
    this.parentChunkId,
    required this.title,
    required this.order,
    this.startUnit,
    this.endUnit,
    this.sizeUnits,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['source_id'] = Variable<String>(sourceId);
    if (!nullToAbsent || parentChunkId != null) {
      map['parent_chunk_id'] = Variable<String>(parentChunkId);
    }
    map['title'] = Variable<String>(title);
    map['sort_order'] = Variable<int>(order);
    if (!nullToAbsent || startUnit != null) {
      map['start_unit'] = Variable<int>(startUnit);
    }
    if (!nullToAbsent || endUnit != null) {
      map['end_unit'] = Variable<int>(endUnit);
    }
    if (!nullToAbsent || sizeUnits != null) {
      map['size_units'] = Variable<int>(sizeUnits);
    }
    return map;
  }

  ChunksCompanion toCompanion(bool nullToAbsent) {
    return ChunksCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      sourceId: Value(sourceId),
      parentChunkId: parentChunkId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentChunkId),
      title: Value(title),
      order: Value(order),
      startUnit: startUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(startUnit),
      endUnit: endUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(endUnit),
      sizeUnits: sizeUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeUnits),
    );
  }

  factory Chunk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chunk(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      parentChunkId: serializer.fromJson<String?>(json['parentChunkId']),
      title: serializer.fromJson<String>(json['title']),
      order: serializer.fromJson<int>(json['order']),
      startUnit: serializer.fromJson<int?>(json['startUnit']),
      endUnit: serializer.fromJson<int?>(json['endUnit']),
      sizeUnits: serializer.fromJson<int?>(json['sizeUnits']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'sourceId': serializer.toJson<String>(sourceId),
      'parentChunkId': serializer.toJson<String?>(parentChunkId),
      'title': serializer.toJson<String>(title),
      'order': serializer.toJson<int>(order),
      'startUnit': serializer.toJson<int?>(startUnit),
      'endUnit': serializer.toJson<int?>(endUnit),
      'sizeUnits': serializer.toJson<int?>(sizeUnits),
    };
  }

  Chunk copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? sourceId,
    Value<String?> parentChunkId = const Value.absent(),
    String? title,
    int? order,
    Value<int?> startUnit = const Value.absent(),
    Value<int?> endUnit = const Value.absent(),
    Value<int?> sizeUnits = const Value.absent(),
  }) => Chunk(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    sourceId: sourceId ?? this.sourceId,
    parentChunkId: parentChunkId.present
        ? parentChunkId.value
        : this.parentChunkId,
    title: title ?? this.title,
    order: order ?? this.order,
    startUnit: startUnit.present ? startUnit.value : this.startUnit,
    endUnit: endUnit.present ? endUnit.value : this.endUnit,
    sizeUnits: sizeUnits.present ? sizeUnits.value : this.sizeUnits,
  );
  Chunk copyWithCompanion(ChunksCompanion data) {
    return Chunk(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      parentChunkId: data.parentChunkId.present
          ? data.parentChunkId.value
          : this.parentChunkId,
      title: data.title.present ? data.title.value : this.title,
      order: data.order.present ? data.order.value : this.order,
      startUnit: data.startUnit.present ? data.startUnit.value : this.startUnit,
      endUnit: data.endUnit.present ? data.endUnit.value : this.endUnit,
      sizeUnits: data.sizeUnits.present ? data.sizeUnits.value : this.sizeUnits,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chunk(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('sourceId: $sourceId, ')
          ..write('parentChunkId: $parentChunkId, ')
          ..write('title: $title, ')
          ..write('order: $order, ')
          ..write('startUnit: $startUnit, ')
          ..write('endUnit: $endUnit, ')
          ..write('sizeUnits: $sizeUnits')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    sourceId,
    parentChunkId,
    title,
    order,
    startUnit,
    endUnit,
    sizeUnits,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chunk &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.sourceId == this.sourceId &&
          other.parentChunkId == this.parentChunkId &&
          other.title == this.title &&
          other.order == this.order &&
          other.startUnit == this.startUnit &&
          other.endUnit == this.endUnit &&
          other.sizeUnits == this.sizeUnits);
}

class ChunksCompanion extends UpdateCompanion<Chunk> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> sourceId;
  final Value<String?> parentChunkId;
  final Value<String> title;
  final Value<int> order;
  final Value<int?> startUnit;
  final Value<int?> endUnit;
  final Value<int?> sizeUnits;
  final Value<int> rowid;
  const ChunksCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.parentChunkId = const Value.absent(),
    this.title = const Value.absent(),
    this.order = const Value.absent(),
    this.startUnit = const Value.absent(),
    this.endUnit = const Value.absent(),
    this.sizeUnits = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChunksCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String sourceId,
    this.parentChunkId = const Value.absent(),
    required String title,
    required int order,
    this.startUnit = const Value.absent(),
    this.endUnit = const Value.absent(),
    this.sizeUnits = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       sourceId = Value(sourceId),
       title = Value(title),
       order = Value(order);
  static Insertable<Chunk> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? sourceId,
    Expression<String>? parentChunkId,
    Expression<String>? title,
    Expression<int>? order,
    Expression<int>? startUnit,
    Expression<int>? endUnit,
    Expression<int>? sizeUnits,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (sourceId != null) 'source_id': sourceId,
      if (parentChunkId != null) 'parent_chunk_id': parentChunkId,
      if (title != null) 'title': title,
      if (order != null) 'sort_order': order,
      if (startUnit != null) 'start_unit': startUnit,
      if (endUnit != null) 'end_unit': endUnit,
      if (sizeUnits != null) 'size_units': sizeUnits,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChunksCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? sourceId,
    Value<String?>? parentChunkId,
    Value<String>? title,
    Value<int>? order,
    Value<int?>? startUnit,
    Value<int?>? endUnit,
    Value<int?>? sizeUnits,
    Value<int>? rowid,
  }) {
    return ChunksCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      sourceId: sourceId ?? this.sourceId,
      parentChunkId: parentChunkId ?? this.parentChunkId,
      title: title ?? this.title,
      order: order ?? this.order,
      startUnit: startUnit ?? this.startUnit,
      endUnit: endUnit ?? this.endUnit,
      sizeUnits: sizeUnits ?? this.sizeUnits,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (parentChunkId.present) {
      map['parent_chunk_id'] = Variable<String>(parentChunkId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (order.present) {
      map['sort_order'] = Variable<int>(order.value);
    }
    if (startUnit.present) {
      map['start_unit'] = Variable<int>(startUnit.value);
    }
    if (endUnit.present) {
      map['end_unit'] = Variable<int>(endUnit.value);
    }
    if (sizeUnits.present) {
      map['size_units'] = Variable<int>(sizeUnits.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChunksCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('sourceId: $sourceId, ')
          ..write('parentChunkId: $parentChunkId, ')
          ..write('title: $title, ')
          ..write('order: $order, ')
          ..write('startUnit: $startUnit, ')
          ..write('endUnit: $endUnit, ')
          ..write('sizeUnits: $sizeUnits, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChunkSurveysTable extends ChunkSurveys
    with TableInfo<$ChunkSurveysTable, ChunkSurvey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChunkSurveysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chunkIdMeta = const VerificationMeta(
    'chunkId',
  );
  @override
  late final GeneratedColumn<String> chunkId = GeneratedColumn<String>(
    'chunk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES chunks (id)',
    ),
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    check: () => ComparableExpr(difficulty).isBetweenValues(1, 3),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familiarityMeta = const VerificationMeta(
    'familiarity',
  );
  @override
  late final GeneratedColumn<int> familiarity = GeneratedColumn<int>(
    'familiarity',
    aliasedName,
    false,
    check: () => ComparableExpr(familiarity).isBetweenValues(0, 2),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _surveyedAtMeta = const VerificationMeta(
    'surveyedAt',
  );
  @override
  late final GeneratedColumn<int> surveyedAt = GeneratedColumn<int>(
    'surveyed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    chunkId,
    difficulty,
    familiarity,
    surveyedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chunk_surveys';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChunkSurvey> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('chunk_id')) {
      context.handle(
        _chunkIdMeta,
        chunkId.isAcceptableOrUnknown(data['chunk_id']!, _chunkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chunkIdMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('familiarity')) {
      context.handle(
        _familiarityMeta,
        familiarity.isAcceptableOrUnknown(
          data['familiarity']!,
          _familiarityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_familiarityMeta);
    }
    if (data.containsKey('surveyed_at')) {
      context.handle(
        _surveyedAtMeta,
        surveyedAt.isAcceptableOrUnknown(data['surveyed_at']!, _surveyedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_surveyedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChunkSurvey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChunkSurvey(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      chunkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chunk_id'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      familiarity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}familiarity'],
      )!,
      surveyedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surveyed_at'],
      )!,
    );
  }

  @override
  $ChunkSurveysTable createAlias(String alias) {
    return $ChunkSurveysTable(attachedDatabase, alias);
  }
}

class ChunkSurvey extends DataClass implements Insertable<ChunkSurvey> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String chunkId;

  /// 1 Easy, 2 Medium, 3 Hard.
  final int difficulty;

  /// 0 New, 1 Seen it, 2 Comfortable.
  final int familiarity;
  final int surveyedAt;
  const ChunkSurvey({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.chunkId,
    required this.difficulty,
    required this.familiarity,
    required this.surveyedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['chunk_id'] = Variable<String>(chunkId);
    map['difficulty'] = Variable<int>(difficulty);
    map['familiarity'] = Variable<int>(familiarity);
    map['surveyed_at'] = Variable<int>(surveyedAt);
    return map;
  }

  ChunkSurveysCompanion toCompanion(bool nullToAbsent) {
    return ChunkSurveysCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      chunkId: Value(chunkId),
      difficulty: Value(difficulty),
      familiarity: Value(familiarity),
      surveyedAt: Value(surveyedAt),
    );
  }

  factory ChunkSurvey.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChunkSurvey(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      chunkId: serializer.fromJson<String>(json['chunkId']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      familiarity: serializer.fromJson<int>(json['familiarity']),
      surveyedAt: serializer.fromJson<int>(json['surveyedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'chunkId': serializer.toJson<String>(chunkId),
      'difficulty': serializer.toJson<int>(difficulty),
      'familiarity': serializer.toJson<int>(familiarity),
      'surveyedAt': serializer.toJson<int>(surveyedAt),
    };
  }

  ChunkSurvey copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? chunkId,
    int? difficulty,
    int? familiarity,
    int? surveyedAt,
  }) => ChunkSurvey(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    chunkId: chunkId ?? this.chunkId,
    difficulty: difficulty ?? this.difficulty,
    familiarity: familiarity ?? this.familiarity,
    surveyedAt: surveyedAt ?? this.surveyedAt,
  );
  ChunkSurvey copyWithCompanion(ChunkSurveysCompanion data) {
    return ChunkSurvey(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      chunkId: data.chunkId.present ? data.chunkId.value : this.chunkId,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      familiarity: data.familiarity.present
          ? data.familiarity.value
          : this.familiarity,
      surveyedAt: data.surveyedAt.present
          ? data.surveyedAt.value
          : this.surveyedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChunkSurvey(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('chunkId: $chunkId, ')
          ..write('difficulty: $difficulty, ')
          ..write('familiarity: $familiarity, ')
          ..write('surveyedAt: $surveyedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    chunkId,
    difficulty,
    familiarity,
    surveyedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChunkSurvey &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.chunkId == this.chunkId &&
          other.difficulty == this.difficulty &&
          other.familiarity == this.familiarity &&
          other.surveyedAt == this.surveyedAt);
}

class ChunkSurveysCompanion extends UpdateCompanion<ChunkSurvey> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> chunkId;
  final Value<int> difficulty;
  final Value<int> familiarity;
  final Value<int> surveyedAt;
  final Value<int> rowid;
  const ChunkSurveysCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.chunkId = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.familiarity = const Value.absent(),
    this.surveyedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChunkSurveysCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String chunkId,
    required int difficulty,
    required int familiarity,
    required int surveyedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       chunkId = Value(chunkId),
       difficulty = Value(difficulty),
       familiarity = Value(familiarity),
       surveyedAt = Value(surveyedAt);
  static Insertable<ChunkSurvey> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? chunkId,
    Expression<int>? difficulty,
    Expression<int>? familiarity,
    Expression<int>? surveyedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (chunkId != null) 'chunk_id': chunkId,
      if (difficulty != null) 'difficulty': difficulty,
      if (familiarity != null) 'familiarity': familiarity,
      if (surveyedAt != null) 'surveyed_at': surveyedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChunkSurveysCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? chunkId,
    Value<int>? difficulty,
    Value<int>? familiarity,
    Value<int>? surveyedAt,
    Value<int>? rowid,
  }) {
    return ChunkSurveysCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      chunkId: chunkId ?? this.chunkId,
      difficulty: difficulty ?? this.difficulty,
      familiarity: familiarity ?? this.familiarity,
      surveyedAt: surveyedAt ?? this.surveyedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (chunkId.present) {
      map['chunk_id'] = Variable<String>(chunkId.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (familiarity.present) {
      map['familiarity'] = Variable<int>(familiarity.value);
    }
    if (surveyedAt.present) {
      map['surveyed_at'] = Variable<int>(surveyedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChunkSurveysCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('chunkId: $chunkId, ')
          ..write('difficulty: $difficulty, ')
          ..write('familiarity: $familiarity, ')
          ..write('surveyedAt: $surveyedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES topics (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskKind>($TasksTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskStatus>($TasksTable.$converterstatus);
  static const VerificationMeta _needsDetailMeta = const VerificationMeta(
    'needsDetail',
  );
  @override
  late final GeneratedColumn<bool> needsDetail = GeneratedColumn<bool>(
    'needs_detail',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_detail" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    topicId,
    title,
    kind,
    status,
    needsDetail,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('needs_detail')) {
      context.handle(
        _needsDetailMeta,
        needsDetail.isAcceptableOrUnknown(
          data['needs_detail']!,
          _needsDetailMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      kind: $TasksTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      status: $TasksTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      needsDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_detail'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskKind, String, String> $converterkind =
      const EnumNameConverter<TaskKind>(TaskKind.values);
  static JsonTypeConverter2<TaskStatus, String, String> $converterstatus =
      const EnumNameConverter<TaskStatus>(TaskStatus.values);
}

class Task extends DataClass implements Insertable<Task> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String? topicId;
  final String title;
  final TaskKind kind;
  final TaskStatus status;
  final bool needsDetail;
  const Task({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    this.topicId,
    required this.title,
    required this.kind,
    required this.status,
    required this.needsDetail,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<String>(topicId);
    }
    map['title'] = Variable<String>(title);
    {
      map['kind'] = Variable<String>($TasksTable.$converterkind.toSql(kind));
    }
    {
      map['status'] = Variable<String>(
        $TasksTable.$converterstatus.toSql(status),
      );
    }
    map['needs_detail'] = Variable<bool>(needsDetail);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
      title: Value(title),
      kind: Value(kind),
      status: Value(status),
      needsDetail: Value(needsDetail),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      topicId: serializer.fromJson<String?>(json['topicId']),
      title: serializer.fromJson<String>(json['title']),
      kind: $TasksTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      status: $TasksTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      needsDetail: serializer.fromJson<bool>(json['needsDetail']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'topicId': serializer.toJson<String?>(topicId),
      'title': serializer.toJson<String>(title),
      'kind': serializer.toJson<String>(
        $TasksTable.$converterkind.toJson(kind),
      ),
      'status': serializer.toJson<String>(
        $TasksTable.$converterstatus.toJson(status),
      ),
      'needsDetail': serializer.toJson<bool>(needsDetail),
    };
  }

  Task copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    Value<String?> topicId = const Value.absent(),
    String? title,
    TaskKind? kind,
    TaskStatus? status,
    bool? needsDetail,
  }) => Task(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    topicId: topicId.present ? topicId.value : this.topicId,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    needsDetail: needsDetail ?? this.needsDetail,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      title: data.title.present ? data.title.value : this.title,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      needsDetail: data.needsDetail.present
          ? data.needsDetail.value
          : this.needsDetail,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('topicId: $topicId, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('needsDetail: $needsDetail')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    topicId,
    title,
    kind,
    status,
    needsDetail,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.topicId == this.topicId &&
          other.title == this.title &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.needsDetail == this.needsDetail);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String?> topicId;
  final Value<String> title;
  final Value<TaskKind> kind;
  final Value<TaskStatus> status;
  final Value<bool> needsDetail;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.title = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.needsDetail = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    this.topicId = const Value.absent(),
    required String title,
    required TaskKind kind,
    required TaskStatus status,
    this.needsDetail = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       title = Value(title),
       kind = Value(kind),
       status = Value(status);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? topicId,
    Expression<String>? title,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<bool>? needsDetail,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (topicId != null) 'topic_id': topicId,
      if (title != null) 'title': title,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (needsDetail != null) 'needs_detail': needsDetail,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String?>? topicId,
    Value<String>? title,
    Value<TaskKind>? kind,
    Value<TaskStatus>? status,
    Value<bool>? needsDetail,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      needsDetail: needsDetail ?? this.needsDetail,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $TasksTable.$converterkind.toSql(kind.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TasksTable.$converterstatus.toSql(status.value),
      );
    }
    if (needsDetail.present) {
      map['needs_detail'] = Variable<bool>(needsDetail.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('topicId: $topicId, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('needsDetail: $needsDetail, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskChunksTable extends TaskChunks
    with TableInfo<$TaskChunksTable, TaskChunk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskChunksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _chunkIdMeta = const VerificationMeta(
    'chunkId',
  );
  @override
  late final GeneratedColumn<String> chunkId = GeneratedColumn<String>(
    'chunk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chunks (id)',
    ),
  );
  static const VerificationMeta _startUnitMeta = const VerificationMeta(
    'startUnit',
  );
  @override
  late final GeneratedColumn<int> startUnit = GeneratedColumn<int>(
    'start_unit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endUnitMeta = const VerificationMeta(
    'endUnit',
  );
  @override
  late final GeneratedColumn<int> endUnit = GeneratedColumn<int>(
    'end_unit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    taskId,
    chunkId,
    startUnit,
    endUnit,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_chunks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskChunk> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('chunk_id')) {
      context.handle(
        _chunkIdMeta,
        chunkId.isAcceptableOrUnknown(data['chunk_id']!, _chunkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chunkIdMeta);
    }
    if (data.containsKey('start_unit')) {
      context.handle(
        _startUnitMeta,
        startUnit.isAcceptableOrUnknown(data['start_unit']!, _startUnitMeta),
      );
    }
    if (data.containsKey('end_unit')) {
      context.handle(
        _endUnitMeta,
        endUnit.isAcceptableOrUnknown(data['end_unit']!, _endUnitMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['sort_order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskChunk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskChunk(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      chunkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chunk_id'],
      )!,
      startUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_unit'],
      ),
      endUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_unit'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TaskChunksTable createAlias(String alias) {
    return $TaskChunksTable(attachedDatabase, alias);
  }
}

class TaskChunk extends DataClass implements Insertable<TaskChunk> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String taskId;
  final String chunkId;
  final int? startUnit;
  final int? endUnit;
  final int order;
  const TaskChunk({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.taskId,
    required this.chunkId,
    this.startUnit,
    this.endUnit,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['task_id'] = Variable<String>(taskId);
    map['chunk_id'] = Variable<String>(chunkId);
    if (!nullToAbsent || startUnit != null) {
      map['start_unit'] = Variable<int>(startUnit);
    }
    if (!nullToAbsent || endUnit != null) {
      map['end_unit'] = Variable<int>(endUnit);
    }
    map['sort_order'] = Variable<int>(order);
    return map;
  }

  TaskChunksCompanion toCompanion(bool nullToAbsent) {
    return TaskChunksCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      taskId: Value(taskId),
      chunkId: Value(chunkId),
      startUnit: startUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(startUnit),
      endUnit: endUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(endUnit),
      order: Value(order),
    );
  }

  factory TaskChunk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskChunk(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      taskId: serializer.fromJson<String>(json['taskId']),
      chunkId: serializer.fromJson<String>(json['chunkId']),
      startUnit: serializer.fromJson<int?>(json['startUnit']),
      endUnit: serializer.fromJson<int?>(json['endUnit']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'taskId': serializer.toJson<String>(taskId),
      'chunkId': serializer.toJson<String>(chunkId),
      'startUnit': serializer.toJson<int?>(startUnit),
      'endUnit': serializer.toJson<int?>(endUnit),
      'order': serializer.toJson<int>(order),
    };
  }

  TaskChunk copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? taskId,
    String? chunkId,
    Value<int?> startUnit = const Value.absent(),
    Value<int?> endUnit = const Value.absent(),
    int? order,
  }) => TaskChunk(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    taskId: taskId ?? this.taskId,
    chunkId: chunkId ?? this.chunkId,
    startUnit: startUnit.present ? startUnit.value : this.startUnit,
    endUnit: endUnit.present ? endUnit.value : this.endUnit,
    order: order ?? this.order,
  );
  TaskChunk copyWithCompanion(TaskChunksCompanion data) {
    return TaskChunk(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      chunkId: data.chunkId.present ? data.chunkId.value : this.chunkId,
      startUnit: data.startUnit.present ? data.startUnit.value : this.startUnit,
      endUnit: data.endUnit.present ? data.endUnit.value : this.endUnit,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskChunk(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('taskId: $taskId, ')
          ..write('chunkId: $chunkId, ')
          ..write('startUnit: $startUnit, ')
          ..write('endUnit: $endUnit, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    taskId,
    chunkId,
    startUnit,
    endUnit,
    order,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskChunk &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.taskId == this.taskId &&
          other.chunkId == this.chunkId &&
          other.startUnit == this.startUnit &&
          other.endUnit == this.endUnit &&
          other.order == this.order);
}

class TaskChunksCompanion extends UpdateCompanion<TaskChunk> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> taskId;
  final Value<String> chunkId;
  final Value<int?> startUnit;
  final Value<int?> endUnit;
  final Value<int> order;
  final Value<int> rowid;
  const TaskChunksCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.chunkId = const Value.absent(),
    this.startUnit = const Value.absent(),
    this.endUnit = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskChunksCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String taskId,
    required String chunkId,
    this.startUnit = const Value.absent(),
    this.endUnit = const Value.absent(),
    required int order,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       taskId = Value(taskId),
       chunkId = Value(chunkId),
       order = Value(order);
  static Insertable<TaskChunk> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? taskId,
    Expression<String>? chunkId,
    Expression<int>? startUnit,
    Expression<int>? endUnit,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (taskId != null) 'task_id': taskId,
      if (chunkId != null) 'chunk_id': chunkId,
      if (startUnit != null) 'start_unit': startUnit,
      if (endUnit != null) 'end_unit': endUnit,
      if (order != null) 'sort_order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskChunksCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? taskId,
    Value<String>? chunkId,
    Value<int?>? startUnit,
    Value<int?>? endUnit,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return TaskChunksCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      taskId: taskId ?? this.taskId,
      chunkId: chunkId ?? this.chunkId,
      startUnit: startUnit ?? this.startUnit,
      endUnit: endUnit ?? this.endUnit,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (chunkId.present) {
      map['chunk_id'] = Variable<String>(chunkId.value);
    }
    if (startUnit.present) {
      map['start_unit'] = Variable<int>(startUnit.value);
    }
    if (endUnit.present) {
      map['end_unit'] = Variable<int>(endUnit.value);
    }
    if (order.present) {
      map['sort_order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskChunksCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('taskId: $taskId, ')
          ..write('chunkId: $chunkId, ')
          ..write('startUnit: $startUnit, ')
          ..write('endUnit: $endUnit, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskStatesTable extends TaskStates
    with TableInfo<$TaskStatesTable, TaskState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    check: () => ComparableExpr(level).isBetweenValues(0, 7),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dimMeta = const VerificationMeta('dim');
  @override
  late final GeneratedColumn<int> dim = GeneratedColumn<int>(
    'dim',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewAtMeta = const VerificationMeta(
    'lastReviewAt',
  );
  @override
  late final GeneratedColumn<int> lastReviewAt = GeneratedColumn<int>(
    'last_review_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<int> dueAt = GeneratedColumn<int>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pausedAtMeta = const VerificationMeta(
    'pausedAt',
  );
  @override
  late final GeneratedColumn<int> pausedAt = GeneratedColumn<int>(
    'paused_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    taskId,
    level,
    step,
    dim,
    lastReviewAt,
    dueAt,
    reps,
    lapses,
    pausedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    }
    if (data.containsKey('dim')) {
      context.handle(
        _dimMeta,
        dim.isAcceptableOrUnknown(data['dim']!, _dimMeta),
      );
    }
    if (data.containsKey('last_review_at')) {
      context.handle(
        _lastReviewAtMeta,
        lastReviewAt.isAcceptableOrUnknown(
          data['last_review_at']!,
          _lastReviewAtMeta,
        ),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('paused_at')) {
      context.handle(
        _pausedAtMeta,
        pausedAt.isAcceptableOrUnknown(data['paused_at']!, _pausedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step'],
      )!,
      dim: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dim'],
      )!,
      lastReviewAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_review_at'],
      ),
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_at'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      pausedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paused_at'],
      ),
    );
  }

  @override
  $TaskStatesTable createAlias(String alias) {
    return $TaskStatesTable(attachedDatabase, alias);
  }
}

class TaskState extends DataClass implements Insertable<TaskState> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String taskId;

  /// 0 = not started, 1..7 = belt.
  final int level;

  /// Scheduled reviews passed (voluntary reviews keep counting).
  final int step;

  /// Dim steps from reviews that were not Good; reset by a Good review.
  final int dim;
  final int? lastReviewAt;
  final int? dueAt;
  final int reps;
  final int lapses;
  final int? pausedAt;
  const TaskState({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.taskId,
    required this.level,
    required this.step,
    required this.dim,
    this.lastReviewAt,
    this.dueAt,
    required this.reps,
    required this.lapses,
    this.pausedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['task_id'] = Variable<String>(taskId);
    map['level'] = Variable<int>(level);
    map['step'] = Variable<int>(step);
    map['dim'] = Variable<int>(dim);
    if (!nullToAbsent || lastReviewAt != null) {
      map['last_review_at'] = Variable<int>(lastReviewAt);
    }
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<int>(dueAt);
    }
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    if (!nullToAbsent || pausedAt != null) {
      map['paused_at'] = Variable<int>(pausedAt);
    }
    return map;
  }

  TaskStatesCompanion toCompanion(bool nullToAbsent) {
    return TaskStatesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      taskId: Value(taskId),
      level: Value(level),
      step: Value(step),
      dim: Value(dim),
      lastReviewAt: lastReviewAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewAt),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      reps: Value(reps),
      lapses: Value(lapses),
      pausedAt: pausedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pausedAt),
    );
  }

  factory TaskState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskState(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      taskId: serializer.fromJson<String>(json['taskId']),
      level: serializer.fromJson<int>(json['level']),
      step: serializer.fromJson<int>(json['step']),
      dim: serializer.fromJson<int>(json['dim']),
      lastReviewAt: serializer.fromJson<int?>(json['lastReviewAt']),
      dueAt: serializer.fromJson<int?>(json['dueAt']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
      pausedAt: serializer.fromJson<int?>(json['pausedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'taskId': serializer.toJson<String>(taskId),
      'level': serializer.toJson<int>(level),
      'step': serializer.toJson<int>(step),
      'dim': serializer.toJson<int>(dim),
      'lastReviewAt': serializer.toJson<int?>(lastReviewAt),
      'dueAt': serializer.toJson<int?>(dueAt),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
      'pausedAt': serializer.toJson<int?>(pausedAt),
    };
  }

  TaskState copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? taskId,
    int? level,
    int? step,
    int? dim,
    Value<int?> lastReviewAt = const Value.absent(),
    Value<int?> dueAt = const Value.absent(),
    int? reps,
    int? lapses,
    Value<int?> pausedAt = const Value.absent(),
  }) => TaskState(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    taskId: taskId ?? this.taskId,
    level: level ?? this.level,
    step: step ?? this.step,
    dim: dim ?? this.dim,
    lastReviewAt: lastReviewAt.present ? lastReviewAt.value : this.lastReviewAt,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    reps: reps ?? this.reps,
    lapses: lapses ?? this.lapses,
    pausedAt: pausedAt.present ? pausedAt.value : this.pausedAt,
  );
  TaskState copyWithCompanion(TaskStatesCompanion data) {
    return TaskState(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      level: data.level.present ? data.level.value : this.level,
      step: data.step.present ? data.step.value : this.step,
      dim: data.dim.present ? data.dim.value : this.dim,
      lastReviewAt: data.lastReviewAt.present
          ? data.lastReviewAt.value
          : this.lastReviewAt,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      pausedAt: data.pausedAt.present ? data.pausedAt.value : this.pausedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskState(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('taskId: $taskId, ')
          ..write('level: $level, ')
          ..write('step: $step, ')
          ..write('dim: $dim, ')
          ..write('lastReviewAt: $lastReviewAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('pausedAt: $pausedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    taskId,
    level,
    step,
    dim,
    lastReviewAt,
    dueAt,
    reps,
    lapses,
    pausedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskState &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.taskId == this.taskId &&
          other.level == this.level &&
          other.step == this.step &&
          other.dim == this.dim &&
          other.lastReviewAt == this.lastReviewAt &&
          other.dueAt == this.dueAt &&
          other.reps == this.reps &&
          other.lapses == this.lapses &&
          other.pausedAt == this.pausedAt);
}

class TaskStatesCompanion extends UpdateCompanion<TaskState> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> taskId;
  final Value<int> level;
  final Value<int> step;
  final Value<int> dim;
  final Value<int?> lastReviewAt;
  final Value<int?> dueAt;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<int?> pausedAt;
  final Value<int> rowid;
  const TaskStatesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.level = const Value.absent(),
    this.step = const Value.absent(),
    this.dim = const Value.absent(),
    this.lastReviewAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.pausedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskStatesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String taskId,
    required int level,
    this.step = const Value.absent(),
    this.dim = const Value.absent(),
    this.lastReviewAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.pausedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       taskId = Value(taskId),
       level = Value(level);
  static Insertable<TaskState> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? taskId,
    Expression<int>? level,
    Expression<int>? step,
    Expression<int>? dim,
    Expression<int>? lastReviewAt,
    Expression<int>? dueAt,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<int>? pausedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (taskId != null) 'task_id': taskId,
      if (level != null) 'level': level,
      if (step != null) 'step': step,
      if (dim != null) 'dim': dim,
      if (lastReviewAt != null) 'last_review_at': lastReviewAt,
      if (dueAt != null) 'due_at': dueAt,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (pausedAt != null) 'paused_at': pausedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskStatesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? taskId,
    Value<int>? level,
    Value<int>? step,
    Value<int>? dim,
    Value<int?>? lastReviewAt,
    Value<int?>? dueAt,
    Value<int>? reps,
    Value<int>? lapses,
    Value<int?>? pausedAt,
    Value<int>? rowid,
  }) {
    return TaskStatesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      taskId: taskId ?? this.taskId,
      level: level ?? this.level,
      step: step ?? this.step,
      dim: dim ?? this.dim,
      lastReviewAt: lastReviewAt ?? this.lastReviewAt,
      dueAt: dueAt ?? this.dueAt,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      pausedAt: pausedAt ?? this.pausedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (dim.present) {
      map['dim'] = Variable<int>(dim.value);
    }
    if (lastReviewAt.present) {
      map['last_review_at'] = Variable<int>(lastReviewAt.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<int>(dueAt.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (pausedAt.present) {
      map['paused_at'] = Variable<int>(pausedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskStatesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('taskId: $taskId, ')
          ..write('level: $level, ')
          ..write('step: $step, ')
          ..write('dim: $dim, ')
          ..write('lastReviewAt: $lastReviewAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('pausedAt: $pausedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewsTable extends Reviews with TableInfo<$ReviewsTable, Review> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<int> at = GeneratedColumn<int>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReviewKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReviewKind>($ReviewsTable.$converterkind);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    false,
    check: () => ComparableExpr(rating).isBetweenValues(1, 4),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resumeUnitMeta = const VerificationMeta(
    'resumeUnit',
  );
  @override
  late final GeneratedColumn<int> resumeUnit = GeneratedColumn<int>(
    'resume_unit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelBeforeMeta = const VerificationMeta(
    'levelBefore',
  );
  @override
  late final GeneratedColumn<int> levelBefore = GeneratedColumn<int>(
    'level_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelAfterMeta = const VerificationMeta(
    'levelAfter',
  );
  @override
  late final GeneratedColumn<int> levelAfter = GeneratedColumn<int>(
    'level_after',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepAfterMeta = const VerificationMeta(
    'stepAfter',
  );
  @override
  late final GeneratedColumn<int> stepAfter = GeneratedColumn<int>(
    'step_after',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAfterMeta = const VerificationMeta(
    'dueAfter',
  );
  @override
  late final GeneratedColumn<int> dueAfter = GeneratedColumn<int>(
    'due_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    taskId,
    at,
    kind,
    rating,
    durationSec,
    resumeUnit,
    levelBefore,
    levelAfter,
    stepAfter,
    dueAfter,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<Review> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecMeta);
    }
    if (data.containsKey('resume_unit')) {
      context.handle(
        _resumeUnitMeta,
        resumeUnit.isAcceptableOrUnknown(data['resume_unit']!, _resumeUnitMeta),
      );
    }
    if (data.containsKey('level_before')) {
      context.handle(
        _levelBeforeMeta,
        levelBefore.isAcceptableOrUnknown(
          data['level_before']!,
          _levelBeforeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_levelBeforeMeta);
    }
    if (data.containsKey('level_after')) {
      context.handle(
        _levelAfterMeta,
        levelAfter.isAcceptableOrUnknown(data['level_after']!, _levelAfterMeta),
      );
    } else if (isInserting) {
      context.missing(_levelAfterMeta);
    }
    if (data.containsKey('step_after')) {
      context.handle(
        _stepAfterMeta,
        stepAfter.isAcceptableOrUnknown(data['step_after']!, _stepAfterMeta),
      );
    } else if (isInserting) {
      context.missing(_stepAfterMeta);
    }
    if (data.containsKey('due_after')) {
      context.handle(
        _dueAfterMeta,
        dueAfter.isAcceptableOrUnknown(data['due_after']!, _dueAfterMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Review map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Review(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}at'],
      )!,
      kind: $ReviewsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      )!,
      resumeUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resume_unit'],
      ),
      levelBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_before'],
      )!,
      levelAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_after'],
      )!,
      stepAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_after'],
      )!,
      dueAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_after'],
      ),
    );
  }

  @override
  $ReviewsTable createAlias(String alias) {
    return $ReviewsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReviewKind, String, String> $converterkind =
      const EnumNameConverter<ReviewKind>(ReviewKind.values);
}

class Review extends DataClass implements Insertable<Review> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String taskId;
  final int at;
  final ReviewKind kind;

  /// 1 Forgot, 2 Hard, 3 Good, 4 Easy.
  final int rating;
  final int durationSec;
  final int? resumeUnit;
  final int levelBefore;
  final int levelAfter;
  final int stepAfter;

  /// Null when no further review is scheduled.
  final int? dueAfter;
  const Review({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.taskId,
    required this.at,
    required this.kind,
    required this.rating,
    required this.durationSec,
    this.resumeUnit,
    required this.levelBefore,
    required this.levelAfter,
    required this.stepAfter,
    this.dueAfter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['task_id'] = Variable<String>(taskId);
    map['at'] = Variable<int>(at);
    {
      map['kind'] = Variable<String>($ReviewsTable.$converterkind.toSql(kind));
    }
    map['rating'] = Variable<int>(rating);
    map['duration_sec'] = Variable<int>(durationSec);
    if (!nullToAbsent || resumeUnit != null) {
      map['resume_unit'] = Variable<int>(resumeUnit);
    }
    map['level_before'] = Variable<int>(levelBefore);
    map['level_after'] = Variable<int>(levelAfter);
    map['step_after'] = Variable<int>(stepAfter);
    if (!nullToAbsent || dueAfter != null) {
      map['due_after'] = Variable<int>(dueAfter);
    }
    return map;
  }

  ReviewsCompanion toCompanion(bool nullToAbsent) {
    return ReviewsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      taskId: Value(taskId),
      at: Value(at),
      kind: Value(kind),
      rating: Value(rating),
      durationSec: Value(durationSec),
      resumeUnit: resumeUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(resumeUnit),
      levelBefore: Value(levelBefore),
      levelAfter: Value(levelAfter),
      stepAfter: Value(stepAfter),
      dueAfter: dueAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAfter),
    );
  }

  factory Review.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Review(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      taskId: serializer.fromJson<String>(json['taskId']),
      at: serializer.fromJson<int>(json['at']),
      kind: $ReviewsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      rating: serializer.fromJson<int>(json['rating']),
      durationSec: serializer.fromJson<int>(json['durationSec']),
      resumeUnit: serializer.fromJson<int?>(json['resumeUnit']),
      levelBefore: serializer.fromJson<int>(json['levelBefore']),
      levelAfter: serializer.fromJson<int>(json['levelAfter']),
      stepAfter: serializer.fromJson<int>(json['stepAfter']),
      dueAfter: serializer.fromJson<int?>(json['dueAfter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'taskId': serializer.toJson<String>(taskId),
      'at': serializer.toJson<int>(at),
      'kind': serializer.toJson<String>(
        $ReviewsTable.$converterkind.toJson(kind),
      ),
      'rating': serializer.toJson<int>(rating),
      'durationSec': serializer.toJson<int>(durationSec),
      'resumeUnit': serializer.toJson<int?>(resumeUnit),
      'levelBefore': serializer.toJson<int>(levelBefore),
      'levelAfter': serializer.toJson<int>(levelAfter),
      'stepAfter': serializer.toJson<int>(stepAfter),
      'dueAfter': serializer.toJson<int?>(dueAfter),
    };
  }

  Review copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? taskId,
    int? at,
    ReviewKind? kind,
    int? rating,
    int? durationSec,
    Value<int?> resumeUnit = const Value.absent(),
    int? levelBefore,
    int? levelAfter,
    int? stepAfter,
    Value<int?> dueAfter = const Value.absent(),
  }) => Review(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    taskId: taskId ?? this.taskId,
    at: at ?? this.at,
    kind: kind ?? this.kind,
    rating: rating ?? this.rating,
    durationSec: durationSec ?? this.durationSec,
    resumeUnit: resumeUnit.present ? resumeUnit.value : this.resumeUnit,
    levelBefore: levelBefore ?? this.levelBefore,
    levelAfter: levelAfter ?? this.levelAfter,
    stepAfter: stepAfter ?? this.stepAfter,
    dueAfter: dueAfter.present ? dueAfter.value : this.dueAfter,
  );
  Review copyWithCompanion(ReviewsCompanion data) {
    return Review(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      at: data.at.present ? data.at.value : this.at,
      kind: data.kind.present ? data.kind.value : this.kind,
      rating: data.rating.present ? data.rating.value : this.rating,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      resumeUnit: data.resumeUnit.present
          ? data.resumeUnit.value
          : this.resumeUnit,
      levelBefore: data.levelBefore.present
          ? data.levelBefore.value
          : this.levelBefore,
      levelAfter: data.levelAfter.present
          ? data.levelAfter.value
          : this.levelAfter,
      stepAfter: data.stepAfter.present ? data.stepAfter.value : this.stepAfter,
      dueAfter: data.dueAfter.present ? data.dueAfter.value : this.dueAfter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Review(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('taskId: $taskId, ')
          ..write('at: $at, ')
          ..write('kind: $kind, ')
          ..write('rating: $rating, ')
          ..write('durationSec: $durationSec, ')
          ..write('resumeUnit: $resumeUnit, ')
          ..write('levelBefore: $levelBefore, ')
          ..write('levelAfter: $levelAfter, ')
          ..write('stepAfter: $stepAfter, ')
          ..write('dueAfter: $dueAfter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    taskId,
    at,
    kind,
    rating,
    durationSec,
    resumeUnit,
    levelBefore,
    levelAfter,
    stepAfter,
    dueAfter,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Review &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.taskId == this.taskId &&
          other.at == this.at &&
          other.kind == this.kind &&
          other.rating == this.rating &&
          other.durationSec == this.durationSec &&
          other.resumeUnit == this.resumeUnit &&
          other.levelBefore == this.levelBefore &&
          other.levelAfter == this.levelAfter &&
          other.stepAfter == this.stepAfter &&
          other.dueAfter == this.dueAfter);
}

class ReviewsCompanion extends UpdateCompanion<Review> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> taskId;
  final Value<int> at;
  final Value<ReviewKind> kind;
  final Value<int> rating;
  final Value<int> durationSec;
  final Value<int?> resumeUnit;
  final Value<int> levelBefore;
  final Value<int> levelAfter;
  final Value<int> stepAfter;
  final Value<int?> dueAfter;
  final Value<int> rowid;
  const ReviewsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.at = const Value.absent(),
    this.kind = const Value.absent(),
    this.rating = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.resumeUnit = const Value.absent(),
    this.levelBefore = const Value.absent(),
    this.levelAfter = const Value.absent(),
    this.stepAfter = const Value.absent(),
    this.dueAfter = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String taskId,
    required int at,
    required ReviewKind kind,
    required int rating,
    required int durationSec,
    this.resumeUnit = const Value.absent(),
    required int levelBefore,
    required int levelAfter,
    required int stepAfter,
    this.dueAfter = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       taskId = Value(taskId),
       at = Value(at),
       kind = Value(kind),
       rating = Value(rating),
       durationSec = Value(durationSec),
       levelBefore = Value(levelBefore),
       levelAfter = Value(levelAfter),
       stepAfter = Value(stepAfter);
  static Insertable<Review> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? taskId,
    Expression<int>? at,
    Expression<String>? kind,
    Expression<int>? rating,
    Expression<int>? durationSec,
    Expression<int>? resumeUnit,
    Expression<int>? levelBefore,
    Expression<int>? levelAfter,
    Expression<int>? stepAfter,
    Expression<int>? dueAfter,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (taskId != null) 'task_id': taskId,
      if (at != null) 'at': at,
      if (kind != null) 'kind': kind,
      if (rating != null) 'rating': rating,
      if (durationSec != null) 'duration_sec': durationSec,
      if (resumeUnit != null) 'resume_unit': resumeUnit,
      if (levelBefore != null) 'level_before': levelBefore,
      if (levelAfter != null) 'level_after': levelAfter,
      if (stepAfter != null) 'step_after': stepAfter,
      if (dueAfter != null) 'due_after': dueAfter,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? taskId,
    Value<int>? at,
    Value<ReviewKind>? kind,
    Value<int>? rating,
    Value<int>? durationSec,
    Value<int?>? resumeUnit,
    Value<int>? levelBefore,
    Value<int>? levelAfter,
    Value<int>? stepAfter,
    Value<int?>? dueAfter,
    Value<int>? rowid,
  }) {
    return ReviewsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      taskId: taskId ?? this.taskId,
      at: at ?? this.at,
      kind: kind ?? this.kind,
      rating: rating ?? this.rating,
      durationSec: durationSec ?? this.durationSec,
      resumeUnit: resumeUnit ?? this.resumeUnit,
      levelBefore: levelBefore ?? this.levelBefore,
      levelAfter: levelAfter ?? this.levelAfter,
      stepAfter: stepAfter ?? this.stepAfter,
      dueAfter: dueAfter ?? this.dueAfter,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (at.present) {
      map['at'] = Variable<int>(at.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ReviewsTable.$converterkind.toSql(kind.value),
      );
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (resumeUnit.present) {
      map['resume_unit'] = Variable<int>(resumeUnit.value);
    }
    if (levelBefore.present) {
      map['level_before'] = Variable<int>(levelBefore.value);
    }
    if (levelAfter.present) {
      map['level_after'] = Variable<int>(levelAfter.value);
    }
    if (stepAfter.present) {
      map['step_after'] = Variable<int>(stepAfter.value);
    }
    if (dueAfter.present) {
      map['due_after'] = Variable<int>(dueAfter.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('taskId: $taskId, ')
          ..write('at: $at, ')
          ..write('kind: $kind, ')
          ..write('rating: $rating, ')
          ..write('durationSec: $durationSec, ')
          ..write('resumeUnit: $resumeUnit, ')
          ..write('levelBefore: $levelBefore, ')
          ..write('levelAfter: $levelAfter, ')
          ..write('stepAfter: $stepAfter, ')
          ..write('dueAfter: $dueAfter, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskLineagesTable extends TaskLineages
    with TableInfo<$TaskLineagesTable, TaskLineage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskLineagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childTaskIdMeta = const VerificationMeta(
    'childTaskId',
  );
  @override
  late final GeneratedColumn<String> childTaskId = GeneratedColumn<String>(
    'child_task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _parentTaskIdMeta = const VerificationMeta(
    'parentTaskId',
  );
  @override
  late final GeneratedColumn<String> parentTaskId = GeneratedColumn<String>(
    'parent_task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LineageOp, String> op =
      GeneratedColumn<String>(
        'op',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LineageOp>($TaskLineagesTable.$converterop);
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<int> at = GeneratedColumn<int>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    childTaskId,
    parentTaskId,
    op,
    at,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_lineages';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskLineage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('child_task_id')) {
      context.handle(
        _childTaskIdMeta,
        childTaskId.isAcceptableOrUnknown(
          data['child_task_id']!,
          _childTaskIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_childTaskIdMeta);
    }
    if (data.containsKey('parent_task_id')) {
      context.handle(
        _parentTaskIdMeta,
        parentTaskId.isAcceptableOrUnknown(
          data['parent_task_id']!,
          _parentTaskIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parentTaskIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskLineage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskLineage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      childTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_task_id'],
      )!,
      parentTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_task_id'],
      )!,
      op: $TaskLineagesTable.$converterop.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}op'],
        )!,
      ),
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $TaskLineagesTable createAlias(String alias) {
    return $TaskLineagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LineageOp, String, String> $converterop =
      const EnumNameConverter<LineageOp>(LineageOp.values);
}

class TaskLineage extends DataClass implements Insertable<TaskLineage> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String childTaskId;
  final String parentTaskId;
  final LineageOp op;
  final int at;
  const TaskLineage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.childTaskId,
    required this.parentTaskId,
    required this.op,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['child_task_id'] = Variable<String>(childTaskId);
    map['parent_task_id'] = Variable<String>(parentTaskId);
    {
      map['op'] = Variable<String>($TaskLineagesTable.$converterop.toSql(op));
    }
    map['at'] = Variable<int>(at);
    return map;
  }

  TaskLineagesCompanion toCompanion(bool nullToAbsent) {
    return TaskLineagesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      childTaskId: Value(childTaskId),
      parentTaskId: Value(parentTaskId),
      op: Value(op),
      at: Value(at),
    );
  }

  factory TaskLineage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskLineage(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      childTaskId: serializer.fromJson<String>(json['childTaskId']),
      parentTaskId: serializer.fromJson<String>(json['parentTaskId']),
      op: $TaskLineagesTable.$converterop.fromJson(
        serializer.fromJson<String>(json['op']),
      ),
      at: serializer.fromJson<int>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'childTaskId': serializer.toJson<String>(childTaskId),
      'parentTaskId': serializer.toJson<String>(parentTaskId),
      'op': serializer.toJson<String>(
        $TaskLineagesTable.$converterop.toJson(op),
      ),
      'at': serializer.toJson<int>(at),
    };
  }

  TaskLineage copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? childTaskId,
    String? parentTaskId,
    LineageOp? op,
    int? at,
  }) => TaskLineage(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    childTaskId: childTaskId ?? this.childTaskId,
    parentTaskId: parentTaskId ?? this.parentTaskId,
    op: op ?? this.op,
    at: at ?? this.at,
  );
  TaskLineage copyWithCompanion(TaskLineagesCompanion data) {
    return TaskLineage(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      childTaskId: data.childTaskId.present
          ? data.childTaskId.value
          : this.childTaskId,
      parentTaskId: data.parentTaskId.present
          ? data.parentTaskId.value
          : this.parentTaskId,
      op: data.op.present ? data.op.value : this.op,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskLineage(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('childTaskId: $childTaskId, ')
          ..write('parentTaskId: $parentTaskId, ')
          ..write('op: $op, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    childTaskId,
    parentTaskId,
    op,
    at,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskLineage &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.childTaskId == this.childTaskId &&
          other.parentTaskId == this.parentTaskId &&
          other.op == this.op &&
          other.at == this.at);
}

class TaskLineagesCompanion extends UpdateCompanion<TaskLineage> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> childTaskId;
  final Value<String> parentTaskId;
  final Value<LineageOp> op;
  final Value<int> at;
  final Value<int> rowid;
  const TaskLineagesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.childTaskId = const Value.absent(),
    this.parentTaskId = const Value.absent(),
    this.op = const Value.absent(),
    this.at = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskLineagesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String childTaskId,
    required String parentTaskId,
    required LineageOp op,
    required int at,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       childTaskId = Value(childTaskId),
       parentTaskId = Value(parentTaskId),
       op = Value(op),
       at = Value(at);
  static Insertable<TaskLineage> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? childTaskId,
    Expression<String>? parentTaskId,
    Expression<String>? op,
    Expression<int>? at,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (childTaskId != null) 'child_task_id': childTaskId,
      if (parentTaskId != null) 'parent_task_id': parentTaskId,
      if (op != null) 'op': op,
      if (at != null) 'at': at,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskLineagesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? childTaskId,
    Value<String>? parentTaskId,
    Value<LineageOp>? op,
    Value<int>? at,
    Value<int>? rowid,
  }) {
    return TaskLineagesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      childTaskId: childTaskId ?? this.childTaskId,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      op: op ?? this.op,
      at: at ?? this.at,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (childTaskId.present) {
      map['child_task_id'] = Variable<String>(childTaskId.value);
    }
    if (parentTaskId.present) {
      map['parent_task_id'] = Variable<String>(parentTaskId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(
        $TaskLineagesTable.$converterop.toSql(op.value),
      );
    }
    if (at.present) {
      map['at'] = Variable<int>(at.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskLineagesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('childTaskId: $childTaskId, ')
          ..write('parentTaskId: $parentTaskId, ')
          ..write('op: $op, ')
          ..write('at: $at, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardsTable extends Cards with TableInfo<$CardsTable, StudyCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CardType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CardType>($CardsTable.$convertertype);
  static const VerificationMeta _frontMeta = const VerificationMeta('front');
  @override
  late final GeneratedColumn<String> front = GeneratedColumn<String>(
    'front',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backMeta = const VerificationMeta('back');
  @override
  late final GeneratedColumn<String> back = GeneratedColumn<String>(
    'back',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsMeta = const VerificationMeta(
    'options',
  );
  @override
  late final GeneratedColumn<String> options = GeneratedColumn<String>(
    'options',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    taskId,
    type,
    front,
    back,
    options,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('front')) {
      context.handle(
        _frontMeta,
        front.isAcceptableOrUnknown(data['front']!, _frontMeta),
      );
    } else if (isInserting) {
      context.missing(_frontMeta);
    }
    if (data.containsKey('back')) {
      context.handle(
        _backMeta,
        back.isAcceptableOrUnknown(data['back']!, _backMeta),
      );
    } else if (isInserting) {
      context.missing(_backMeta);
    }
    if (data.containsKey('options')) {
      context.handle(
        _optionsMeta,
        options.isAcceptableOrUnknown(data['options']!, _optionsMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['sort_order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      type: $CardsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      front: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front'],
      )!,
      back: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back'],
      )!,
      options: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CardType, String, String> $convertertype =
      const EnumNameConverter<CardType>(CardType.values);
}

class StudyCard extends DataClass implements Insertable<StudyCard> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String taskId;
  final CardType type;
  final String front;
  final String back;

  /// JSON array of options for multiple choice.
  final String? options;
  final int order;
  const StudyCard({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.taskId,
    required this.type,
    required this.front,
    required this.back,
    this.options,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['task_id'] = Variable<String>(taskId);
    {
      map['type'] = Variable<String>($CardsTable.$convertertype.toSql(type));
    }
    map['front'] = Variable<String>(front);
    map['back'] = Variable<String>(back);
    if (!nullToAbsent || options != null) {
      map['options'] = Variable<String>(options);
    }
    map['sort_order'] = Variable<int>(order);
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      taskId: Value(taskId),
      type: Value(type),
      front: Value(front),
      back: Value(back),
      options: options == null && nullToAbsent
          ? const Value.absent()
          : Value(options),
      order: Value(order),
    );
  }

  factory StudyCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyCard(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      taskId: serializer.fromJson<String>(json['taskId']),
      type: $CardsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      front: serializer.fromJson<String>(json['front']),
      back: serializer.fromJson<String>(json['back']),
      options: serializer.fromJson<String?>(json['options']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'taskId': serializer.toJson<String>(taskId),
      'type': serializer.toJson<String>(
        $CardsTable.$convertertype.toJson(type),
      ),
      'front': serializer.toJson<String>(front),
      'back': serializer.toJson<String>(back),
      'options': serializer.toJson<String?>(options),
      'order': serializer.toJson<int>(order),
    };
  }

  StudyCard copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? taskId,
    CardType? type,
    String? front,
    String? back,
    Value<String?> options = const Value.absent(),
    int? order,
  }) => StudyCard(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    taskId: taskId ?? this.taskId,
    type: type ?? this.type,
    front: front ?? this.front,
    back: back ?? this.back,
    options: options.present ? options.value : this.options,
    order: order ?? this.order,
  );
  StudyCard copyWithCompanion(CardsCompanion data) {
    return StudyCard(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      type: data.type.present ? data.type.value : this.type,
      front: data.front.present ? data.front.value : this.front,
      back: data.back.present ? data.back.value : this.back,
      options: data.options.present ? data.options.value : this.options,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyCard(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('options: $options, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    taskId,
    type,
    front,
    back,
    options,
    order,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyCard &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.taskId == this.taskId &&
          other.type == this.type &&
          other.front == this.front &&
          other.back == this.back &&
          other.options == this.options &&
          other.order == this.order);
}

class CardsCompanion extends UpdateCompanion<StudyCard> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> taskId;
  final Value<CardType> type;
  final Value<String> front;
  final Value<String> back;
  final Value<String?> options;
  final Value<int> order;
  final Value<int> rowid;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.type = const Value.absent(),
    this.front = const Value.absent(),
    this.back = const Value.absent(),
    this.options = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String taskId,
    required CardType type,
    required String front,
    required String back,
    this.options = const Value.absent(),
    required int order,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       taskId = Value(taskId),
       type = Value(type),
       front = Value(front),
       back = Value(back),
       order = Value(order);
  static Insertable<StudyCard> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? taskId,
    Expression<String>? type,
    Expression<String>? front,
    Expression<String>? back,
    Expression<String>? options,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (taskId != null) 'task_id': taskId,
      if (type != null) 'type': type,
      if (front != null) 'front': front,
      if (back != null) 'back': back,
      if (options != null) 'options': options,
      if (order != null) 'sort_order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? taskId,
    Value<CardType>? type,
    Value<String>? front,
    Value<String>? back,
    Value<String?>? options,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return CardsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      front: front ?? this.front,
      back: back ?? this.back,
      options: options ?? this.options,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $CardsTable.$convertertype.toSql(type.value),
      );
    }
    if (front.present) {
      map['front'] = Variable<String>(front.value);
    }
    if (back.present) {
      map['back'] = Variable<String>(back.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(options.value);
    }
    if (order.present) {
      map['sort_order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('options: $options, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardResultsTable extends CardResults
    with TableInfo<$CardResultsTable, CardResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id)',
    ),
  );
  static const VerificationMeta _reviewIdMeta = const VerificationMeta(
    'reviewId',
  );
  @override
  late final GeneratedColumn<String> reviewId = GeneratedColumn<String>(
    'review_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reviews (id)',
    ),
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _answerMsMeta = const VerificationMeta(
    'answerMs',
  );
  @override
  late final GeneratedColumn<int> answerMs = GeneratedColumn<int>(
    'answer_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    cardId,
    reviewId,
    correct,
    answerMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('review_id')) {
      context.handle(
        _reviewIdMeta,
        reviewId.isAcceptableOrUnknown(data['review_id']!, _reviewIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewIdMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('answer_ms')) {
      context.handle(
        _answerMsMeta,
        answerMs.isAcceptableOrUnknown(data['answer_ms']!, _answerMsMeta),
      );
    } else if (isInserting) {
      context.missing(_answerMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      reviewId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_id'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      answerMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answer_ms'],
      )!,
    );
  }

  @override
  $CardResultsTable createAlias(String alias) {
    return $CardResultsTable(attachedDatabase, alias);
  }
}

class CardResult extends DataClass implements Insertable<CardResult> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String cardId;
  final String reviewId;
  final bool correct;
  final int answerMs;
  const CardResult({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.cardId,
    required this.reviewId,
    required this.correct,
    required this.answerMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['card_id'] = Variable<String>(cardId);
    map['review_id'] = Variable<String>(reviewId);
    map['correct'] = Variable<bool>(correct);
    map['answer_ms'] = Variable<int>(answerMs);
    return map;
  }

  CardResultsCompanion toCompanion(bool nullToAbsent) {
    return CardResultsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      cardId: Value(cardId),
      reviewId: Value(reviewId),
      correct: Value(correct),
      answerMs: Value(answerMs),
    );
  }

  factory CardResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardResult(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      cardId: serializer.fromJson<String>(json['cardId']),
      reviewId: serializer.fromJson<String>(json['reviewId']),
      correct: serializer.fromJson<bool>(json['correct']),
      answerMs: serializer.fromJson<int>(json['answerMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'cardId': serializer.toJson<String>(cardId),
      'reviewId': serializer.toJson<String>(reviewId),
      'correct': serializer.toJson<bool>(correct),
      'answerMs': serializer.toJson<int>(answerMs),
    };
  }

  CardResult copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? cardId,
    String? reviewId,
    bool? correct,
    int? answerMs,
  }) => CardResult(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    cardId: cardId ?? this.cardId,
    reviewId: reviewId ?? this.reviewId,
    correct: correct ?? this.correct,
    answerMs: answerMs ?? this.answerMs,
  );
  CardResult copyWithCompanion(CardResultsCompanion data) {
    return CardResult(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      reviewId: data.reviewId.present ? data.reviewId.value : this.reviewId,
      correct: data.correct.present ? data.correct.value : this.correct,
      answerMs: data.answerMs.present ? data.answerMs.value : this.answerMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardResult(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('cardId: $cardId, ')
          ..write('reviewId: $reviewId, ')
          ..write('correct: $correct, ')
          ..write('answerMs: $answerMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    cardId,
    reviewId,
    correct,
    answerMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardResult &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.cardId == this.cardId &&
          other.reviewId == this.reviewId &&
          other.correct == this.correct &&
          other.answerMs == this.answerMs);
}

class CardResultsCompanion extends UpdateCompanion<CardResult> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> cardId;
  final Value<String> reviewId;
  final Value<bool> correct;
  final Value<int> answerMs;
  final Value<int> rowid;
  const CardResultsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.reviewId = const Value.absent(),
    this.correct = const Value.absent(),
    this.answerMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardResultsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String cardId,
    required String reviewId,
    required bool correct,
    required int answerMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       cardId = Value(cardId),
       reviewId = Value(reviewId),
       correct = Value(correct),
       answerMs = Value(answerMs);
  static Insertable<CardResult> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? cardId,
    Expression<String>? reviewId,
    Expression<bool>? correct,
    Expression<int>? answerMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (cardId != null) 'card_id': cardId,
      if (reviewId != null) 'review_id': reviewId,
      if (correct != null) 'correct': correct,
      if (answerMs != null) 'answer_ms': answerMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardResultsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? cardId,
    Value<String>? reviewId,
    Value<bool>? correct,
    Value<int>? answerMs,
    Value<int>? rowid,
  }) {
    return CardResultsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      cardId: cardId ?? this.cardId,
      reviewId: reviewId ?? this.reviewId,
      correct: correct ?? this.correct,
      answerMs: answerMs ?? this.answerMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (reviewId.present) {
      map['review_id'] = Variable<String>(reviewId.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (answerMs.present) {
      map['answer_ms'] = Variable<int>(answerMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardResultsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('cardId: $cardId, ')
          ..write('reviewId: $reviewId, ')
          ..write('correct: $correct, ')
          ..write('answerMs: $answerMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExamsTable extends Exams with TableInfo<$ExamsTable, Exam> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    check: () => ComparableExpr(priority).isBetweenValues(1, 3),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExamStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ExamStatus>($ExamsTable.$converterstatus);
  static const VerificationMeta _resultNoteMeta = const VerificationMeta(
    'resultNote',
  );
  @override
  late final GeneratedColumn<String> resultNote = GeneratedColumn<String>(
    'result_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    name,
    date,
    priority,
    status,
    resultNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exams';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exam> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('result_note')) {
      context.handle(
        _resultNoteMeta,
        resultNote.isAcceptableOrUnknown(data['result_note']!, _resultNoteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exam map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exam(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      status: $ExamsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      resultNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_note'],
      ),
    );
  }

  @override
  $ExamsTable createAlias(String alias) {
    return $ExamsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ExamStatus, String, String> $converterstatus =
      const EnumNameConverter<ExamStatus>(ExamStatus.values);
}

class Exam extends DataClass implements Insertable<Exam> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String name;

  /// `YYYY-MM-DD`.
  final String date;

  /// 1 low, 2 normal, 3 high.
  final int priority;
  final ExamStatus status;
  final String? resultNote;
  const Exam({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.name,
    required this.date,
    required this.priority,
    required this.status,
    this.resultNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<String>(date);
    map['priority'] = Variable<int>(priority);
    {
      map['status'] = Variable<String>(
        $ExamsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || resultNote != null) {
      map['result_note'] = Variable<String>(resultNote);
    }
    return map;
  }

  ExamsCompanion toCompanion(bool nullToAbsent) {
    return ExamsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      name: Value(name),
      date: Value(date),
      priority: Value(priority),
      status: Value(status),
      resultNote: resultNote == null && nullToAbsent
          ? const Value.absent()
          : Value(resultNote),
    );
  }

  factory Exam.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exam(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<String>(json['date']),
      priority: serializer.fromJson<int>(json['priority']),
      status: $ExamsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      resultNote: serializer.fromJson<String?>(json['resultNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<String>(date),
      'priority': serializer.toJson<int>(priority),
      'status': serializer.toJson<String>(
        $ExamsTable.$converterstatus.toJson(status),
      ),
      'resultNote': serializer.toJson<String?>(resultNote),
    };
  }

  Exam copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? name,
    String? date,
    int? priority,
    ExamStatus? status,
    Value<String?> resultNote = const Value.absent(),
  }) => Exam(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    name: name ?? this.name,
    date: date ?? this.date,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    resultNote: resultNote.present ? resultNote.value : this.resultNote,
  );
  Exam copyWithCompanion(ExamsCompanion data) {
    return Exam(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      date: data.date.present ? data.date.value : this.date,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      resultNote: data.resultNote.present
          ? data.resultNote.value
          : this.resultNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exam(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('resultNote: $resultNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    name,
    date,
    priority,
    status,
    resultNote,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exam &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.date == this.date &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.resultNote == this.resultNote);
}

class ExamsCompanion extends UpdateCompanion<Exam> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> name;
  final Value<String> date;
  final Value<int> priority;
  final Value<ExamStatus> status;
  final Value<String?> resultNote;
  final Value<int> rowid;
  const ExamsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.resultNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String name,
    required String date,
    required int priority,
    required ExamStatus status,
    this.resultNote = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       name = Value(name),
       date = Value(date),
       priority = Value(priority),
       status = Value(status);
  static Insertable<Exam> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<String>? date,
    Expression<int>? priority,
    Expression<String>? status,
    Expression<String>? resultNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (resultNote != null) 'result_note': resultNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? name,
    Value<String>? date,
    Value<int>? priority,
    Value<ExamStatus>? status,
    Value<String?>? resultNote,
    Value<int>? rowid,
  }) {
    return ExamsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      resultNote: resultNote ?? this.resultNote,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ExamsTable.$converterstatus.toSql(status.value),
      );
    }
    if (resultNote.present) {
      map['result_note'] = Variable<String>(resultNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('resultNote: $resultNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExamChunksTable extends ExamChunks
    with TableInfo<$ExamChunksTable, ExamChunk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamChunksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examIdMeta = const VerificationMeta('examId');
  @override
  late final GeneratedColumn<String> examId = GeneratedColumn<String>(
    'exam_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exams (id)',
    ),
  );
  static const VerificationMeta _chunkIdMeta = const VerificationMeta(
    'chunkId',
  );
  @override
  late final GeneratedColumn<String> chunkId = GeneratedColumn<String>(
    'chunk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chunks (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Importance, String> importance =
      GeneratedColumn<String>(
        'importance',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Importance>($ExamChunksTable.$converterimportance);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    examId,
    chunkId,
    importance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_chunks';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamChunk> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('exam_id')) {
      context.handle(
        _examIdMeta,
        examId.isAcceptableOrUnknown(data['exam_id']!, _examIdMeta),
      );
    } else if (isInserting) {
      context.missing(_examIdMeta);
    }
    if (data.containsKey('chunk_id')) {
      context.handle(
        _chunkIdMeta,
        chunkId.isAcceptableOrUnknown(data['chunk_id']!, _chunkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chunkIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamChunk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamChunk(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      examId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_id'],
      )!,
      chunkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chunk_id'],
      )!,
      importance: $ExamChunksTable.$converterimportance.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}importance'],
        )!,
      ),
    );
  }

  @override
  $ExamChunksTable createAlias(String alias) {
    return $ExamChunksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Importance, String, String> $converterimportance =
      const EnumNameConverter<Importance>(Importance.values);
}

class ExamChunk extends DataClass implements Insertable<ExamChunk> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String examId;
  final String chunkId;
  final Importance importance;
  const ExamChunk({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.examId,
    required this.chunkId,
    required this.importance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['exam_id'] = Variable<String>(examId);
    map['chunk_id'] = Variable<String>(chunkId);
    {
      map['importance'] = Variable<String>(
        $ExamChunksTable.$converterimportance.toSql(importance),
      );
    }
    return map;
  }

  ExamChunksCompanion toCompanion(bool nullToAbsent) {
    return ExamChunksCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      examId: Value(examId),
      chunkId: Value(chunkId),
      importance: Value(importance),
    );
  }

  factory ExamChunk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamChunk(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      examId: serializer.fromJson<String>(json['examId']),
      chunkId: serializer.fromJson<String>(json['chunkId']),
      importance: $ExamChunksTable.$converterimportance.fromJson(
        serializer.fromJson<String>(json['importance']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'examId': serializer.toJson<String>(examId),
      'chunkId': serializer.toJson<String>(chunkId),
      'importance': serializer.toJson<String>(
        $ExamChunksTable.$converterimportance.toJson(importance),
      ),
    };
  }

  ExamChunk copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? examId,
    String? chunkId,
    Importance? importance,
  }) => ExamChunk(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    examId: examId ?? this.examId,
    chunkId: chunkId ?? this.chunkId,
    importance: importance ?? this.importance,
  );
  ExamChunk copyWithCompanion(ExamChunksCompanion data) {
    return ExamChunk(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      examId: data.examId.present ? data.examId.value : this.examId,
      chunkId: data.chunkId.present ? data.chunkId.value : this.chunkId,
      importance: data.importance.present
          ? data.importance.value
          : this.importance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamChunk(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('examId: $examId, ')
          ..write('chunkId: $chunkId, ')
          ..write('importance: $importance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    examId,
    chunkId,
    importance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamChunk &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.examId == this.examId &&
          other.chunkId == this.chunkId &&
          other.importance == this.importance);
}

class ExamChunksCompanion extends UpdateCompanion<ExamChunk> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> examId;
  final Value<String> chunkId;
  final Value<Importance> importance;
  final Value<int> rowid;
  const ExamChunksCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.examId = const Value.absent(),
    this.chunkId = const Value.absent(),
    this.importance = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamChunksCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String examId,
    required String chunkId,
    required Importance importance,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       examId = Value(examId),
       chunkId = Value(chunkId),
       importance = Value(importance);
  static Insertable<ExamChunk> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? examId,
    Expression<String>? chunkId,
    Expression<String>? importance,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (examId != null) 'exam_id': examId,
      if (chunkId != null) 'chunk_id': chunkId,
      if (importance != null) 'importance': importance,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamChunksCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? examId,
    Value<String>? chunkId,
    Value<Importance>? importance,
    Value<int>? rowid,
  }) {
    return ExamChunksCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      examId: examId ?? this.examId,
      chunkId: chunkId ?? this.chunkId,
      importance: importance ?? this.importance,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (examId.present) {
      map['exam_id'] = Variable<String>(examId.value);
    }
    if (chunkId.present) {
      map['chunk_id'] = Variable<String>(chunkId.value);
    }
    if (importance.present) {
      map['importance'] = Variable<String>(
        $ExamChunksTable.$converterimportance.toSql(importance.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamChunksCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('examId: $examId, ')
          ..write('chunkId: $chunkId, ')
          ..write('importance: $importance, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExamTasksTable extends ExamTasks
    with TableInfo<$ExamTasksTable, ExamTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examIdMeta = const VerificationMeta('examId');
  @override
  late final GeneratedColumn<String> examId = GeneratedColumn<String>(
    'exam_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exams (id)',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Importance, String> importance =
      GeneratedColumn<String>(
        'importance',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Importance>($ExamTasksTable.$converterimportance);
  static const VerificationMeta _targetLevelMeta = const VerificationMeta(
    'targetLevel',
  );
  @override
  late final GeneratedColumn<int> targetLevel = GeneratedColumn<int>(
    'target_level',
    aliasedName,
    false,
    check: () => ComparableExpr(targetLevel).isBetweenValues(1, 7),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importanceOverriddenMeta =
      const VerificationMeta('importanceOverridden');
  @override
  late final GeneratedColumn<bool> importanceOverridden = GeneratedColumn<bool>(
    'importance_overridden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("importance_overridden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    examId,
    taskId,
    importance,
    targetLevel,
    importanceOverridden,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('exam_id')) {
      context.handle(
        _examIdMeta,
        examId.isAcceptableOrUnknown(data['exam_id']!, _examIdMeta),
      );
    } else if (isInserting) {
      context.missing(_examIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('target_level')) {
      context.handle(
        _targetLevelMeta,
        targetLevel.isAcceptableOrUnknown(
          data['target_level']!,
          _targetLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetLevelMeta);
    }
    if (data.containsKey('importance_overridden')) {
      context.handle(
        _importanceOverriddenMeta,
        importanceOverridden.isAcceptableOrUnknown(
          data['importance_overridden']!,
          _importanceOverriddenMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {examId, taskId},
  ];
  @override
  ExamTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      examId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      importance: $ExamTasksTable.$converterimportance.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}importance'],
        )!,
      ),
      targetLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_level'],
      )!,
      importanceOverridden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}importance_overridden'],
      )!,
    );
  }

  @override
  $ExamTasksTable createAlias(String alias) {
    return $ExamTasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Importance, String, String> $converterimportance =
      const EnumNameConverter<Importance>(Importance.values);
}

class ExamTask extends DataClass implements Insertable<ExamTask> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String examId;
  final String taskId;
  final Importance importance;
  final int targetLevel;
  final bool importanceOverridden;
  const ExamTask({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.examId,
    required this.taskId,
    required this.importance,
    required this.targetLevel,
    required this.importanceOverridden,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['exam_id'] = Variable<String>(examId);
    map['task_id'] = Variable<String>(taskId);
    {
      map['importance'] = Variable<String>(
        $ExamTasksTable.$converterimportance.toSql(importance),
      );
    }
    map['target_level'] = Variable<int>(targetLevel);
    map['importance_overridden'] = Variable<bool>(importanceOverridden);
    return map;
  }

  ExamTasksCompanion toCompanion(bool nullToAbsent) {
    return ExamTasksCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      examId: Value(examId),
      taskId: Value(taskId),
      importance: Value(importance),
      targetLevel: Value(targetLevel),
      importanceOverridden: Value(importanceOverridden),
    );
  }

  factory ExamTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamTask(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      examId: serializer.fromJson<String>(json['examId']),
      taskId: serializer.fromJson<String>(json['taskId']),
      importance: $ExamTasksTable.$converterimportance.fromJson(
        serializer.fromJson<String>(json['importance']),
      ),
      targetLevel: serializer.fromJson<int>(json['targetLevel']),
      importanceOverridden: serializer.fromJson<bool>(
        json['importanceOverridden'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'examId': serializer.toJson<String>(examId),
      'taskId': serializer.toJson<String>(taskId),
      'importance': serializer.toJson<String>(
        $ExamTasksTable.$converterimportance.toJson(importance),
      ),
      'targetLevel': serializer.toJson<int>(targetLevel),
      'importanceOverridden': serializer.toJson<bool>(importanceOverridden),
    };
  }

  ExamTask copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? examId,
    String? taskId,
    Importance? importance,
    int? targetLevel,
    bool? importanceOverridden,
  }) => ExamTask(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    examId: examId ?? this.examId,
    taskId: taskId ?? this.taskId,
    importance: importance ?? this.importance,
    targetLevel: targetLevel ?? this.targetLevel,
    importanceOverridden: importanceOverridden ?? this.importanceOverridden,
  );
  ExamTask copyWithCompanion(ExamTasksCompanion data) {
    return ExamTask(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      examId: data.examId.present ? data.examId.value : this.examId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      importance: data.importance.present
          ? data.importance.value
          : this.importance,
      targetLevel: data.targetLevel.present
          ? data.targetLevel.value
          : this.targetLevel,
      importanceOverridden: data.importanceOverridden.present
          ? data.importanceOverridden.value
          : this.importanceOverridden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamTask(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('examId: $examId, ')
          ..write('taskId: $taskId, ')
          ..write('importance: $importance, ')
          ..write('targetLevel: $targetLevel, ')
          ..write('importanceOverridden: $importanceOverridden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    examId,
    taskId,
    importance,
    targetLevel,
    importanceOverridden,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamTask &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.examId == this.examId &&
          other.taskId == this.taskId &&
          other.importance == this.importance &&
          other.targetLevel == this.targetLevel &&
          other.importanceOverridden == this.importanceOverridden);
}

class ExamTasksCompanion extends UpdateCompanion<ExamTask> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> examId;
  final Value<String> taskId;
  final Value<Importance> importance;
  final Value<int> targetLevel;
  final Value<bool> importanceOverridden;
  final Value<int> rowid;
  const ExamTasksCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.examId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.importance = const Value.absent(),
    this.targetLevel = const Value.absent(),
    this.importanceOverridden = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamTasksCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String examId,
    required String taskId,
    required Importance importance,
    required int targetLevel,
    this.importanceOverridden = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       examId = Value(examId),
       taskId = Value(taskId),
       importance = Value(importance),
       targetLevel = Value(targetLevel);
  static Insertable<ExamTask> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? examId,
    Expression<String>? taskId,
    Expression<String>? importance,
    Expression<int>? targetLevel,
    Expression<bool>? importanceOverridden,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (examId != null) 'exam_id': examId,
      if (taskId != null) 'task_id': taskId,
      if (importance != null) 'importance': importance,
      if (targetLevel != null) 'target_level': targetLevel,
      if (importanceOverridden != null)
        'importance_overridden': importanceOverridden,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamTasksCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? examId,
    Value<String>? taskId,
    Value<Importance>? importance,
    Value<int>? targetLevel,
    Value<bool>? importanceOverridden,
    Value<int>? rowid,
  }) {
    return ExamTasksCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      examId: examId ?? this.examId,
      taskId: taskId ?? this.taskId,
      importance: importance ?? this.importance,
      targetLevel: targetLevel ?? this.targetLevel,
      importanceOverridden: importanceOverridden ?? this.importanceOverridden,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (examId.present) {
      map['exam_id'] = Variable<String>(examId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (importance.present) {
      map['importance'] = Variable<String>(
        $ExamTasksTable.$converterimportance.toSql(importance.value),
      );
    }
    if (targetLevel.present) {
      map['target_level'] = Variable<int>(targetLevel.value);
    }
    if (importanceOverridden.present) {
      map['importance_overridden'] = Variable<bool>(importanceOverridden.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamTasksCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('examId: $examId, ')
          ..write('taskId: $taskId, ')
          ..write('importance: $importance, ')
          ..write('targetLevel: $targetLevel, ')
          ..write('importanceOverridden: $importanceOverridden, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AvailabilitiesTable extends Availabilities
    with TableInfo<$AvailabilitiesTable, Availability> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AvailabilitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    check: () => ComparableExpr(weekday).isBetweenValues(0, 6),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lockedExamIdMeta = const VerificationMeta(
    'lockedExamId',
  );
  @override
  late final GeneratedColumn<String> lockedExamId = GeneratedColumn<String>(
    'locked_exam_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exams (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    weekday,
    minutes,
    lockedExamId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'availabilities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Availability> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    } else if (isInserting) {
      context.missing(_minutesMeta);
    }
    if (data.containsKey('locked_exam_id')) {
      context.handle(
        _lockedExamIdMeta,
        lockedExamId.isAcceptableOrUnknown(
          data['locked_exam_id']!,
          _lockedExamIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Availability map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Availability(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      lockedExamId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locked_exam_id'],
      ),
    );
  }

  @override
  $AvailabilitiesTable createAlias(String alias) {
    return $AvailabilitiesTable(attachedDatabase, alias);
  }
}

class Availability extends DataClass implements Insertable<Availability> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;

  /// 0 Monday .. 6 Sunday (ISO order, `DateTime.weekday - 1`).
  final int weekday;
  final int minutes;
  final String? lockedExamId;
  const Availability({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.weekday,
    required this.minutes,
    this.lockedExamId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['weekday'] = Variable<int>(weekday);
    map['minutes'] = Variable<int>(minutes);
    if (!nullToAbsent || lockedExamId != null) {
      map['locked_exam_id'] = Variable<String>(lockedExamId);
    }
    return map;
  }

  AvailabilitiesCompanion toCompanion(bool nullToAbsent) {
    return AvailabilitiesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      weekday: Value(weekday),
      minutes: Value(minutes),
      lockedExamId: lockedExamId == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedExamId),
    );
  }

  factory Availability.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Availability(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      minutes: serializer.fromJson<int>(json['minutes']),
      lockedExamId: serializer.fromJson<String?>(json['lockedExamId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'weekday': serializer.toJson<int>(weekday),
      'minutes': serializer.toJson<int>(minutes),
      'lockedExamId': serializer.toJson<String?>(lockedExamId),
    };
  }

  Availability copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    int? weekday,
    int? minutes,
    Value<String?> lockedExamId = const Value.absent(),
  }) => Availability(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    weekday: weekday ?? this.weekday,
    minutes: minutes ?? this.minutes,
    lockedExamId: lockedExamId.present ? lockedExamId.value : this.lockedExamId,
  );
  Availability copyWithCompanion(AvailabilitiesCompanion data) {
    return Availability(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      lockedExamId: data.lockedExamId.present
          ? data.lockedExamId.value
          : this.lockedExamId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Availability(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('weekday: $weekday, ')
          ..write('minutes: $minutes, ')
          ..write('lockedExamId: $lockedExamId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    weekday,
    minutes,
    lockedExamId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Availability &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.weekday == this.weekday &&
          other.minutes == this.minutes &&
          other.lockedExamId == this.lockedExamId);
}

class AvailabilitiesCompanion extends UpdateCompanion<Availability> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<int> weekday;
  final Value<int> minutes;
  final Value<String?> lockedExamId;
  final Value<int> rowid;
  const AvailabilitiesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.minutes = const Value.absent(),
    this.lockedExamId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AvailabilitiesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required int weekday,
    required int minutes,
    this.lockedExamId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       weekday = Value(weekday),
       minutes = Value(minutes);
  static Insertable<Availability> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<int>? weekday,
    Expression<int>? minutes,
    Expression<String>? lockedExamId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (weekday != null) 'weekday': weekday,
      if (minutes != null) 'minutes': minutes,
      if (lockedExamId != null) 'locked_exam_id': lockedExamId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AvailabilitiesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<int>? weekday,
    Value<int>? minutes,
    Value<String?>? lockedExamId,
    Value<int>? rowid,
  }) {
    return AvailabilitiesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      weekday: weekday ?? this.weekday,
      minutes: minutes ?? this.minutes,
      lockedExamId: lockedExamId ?? this.lockedExamId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (lockedExamId.present) {
      map['locked_exam_id'] = Variable<String>(lockedExamId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilitiesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('weekday: $weekday, ')
          ..write('minutes: $minutes, ')
          ..write('lockedExamId: $lockedExamId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AvailabilityOverridesTable extends AvailabilityOverrides
    with TableInfo<$AvailabilityOverridesTable, AvailabilityOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AvailabilityOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lockedExamIdMeta = const VerificationMeta(
    'lockedExamId',
  );
  @override
  late final GeneratedColumn<String> lockedExamId = GeneratedColumn<String>(
    'locked_exam_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exams (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    date,
    minutes,
    lockedExamId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'availability_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<AvailabilityOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    } else if (isInserting) {
      context.missing(_minutesMeta);
    }
    if (data.containsKey('locked_exam_id')) {
      context.handle(
        _lockedExamIdMeta,
        lockedExamId.isAcceptableOrUnknown(
          data['locked_exam_id']!,
          _lockedExamIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AvailabilityOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AvailabilityOverride(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      lockedExamId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locked_exam_id'],
      ),
    );
  }

  @override
  $AvailabilityOverridesTable createAlias(String alias) {
    return $AvailabilityOverridesTable(attachedDatabase, alias);
  }
}

class AvailabilityOverride extends DataClass
    implements Insertable<AvailabilityOverride> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;

  /// `YYYY-MM-DD`.
  final String date;
  final int minutes;
  final String? lockedExamId;
  const AvailabilityOverride({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.date,
    required this.minutes,
    this.lockedExamId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['date'] = Variable<String>(date);
    map['minutes'] = Variable<int>(minutes);
    if (!nullToAbsent || lockedExamId != null) {
      map['locked_exam_id'] = Variable<String>(lockedExamId);
    }
    return map;
  }

  AvailabilityOverridesCompanion toCompanion(bool nullToAbsent) {
    return AvailabilityOverridesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      date: Value(date),
      minutes: Value(minutes),
      lockedExamId: lockedExamId == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedExamId),
    );
  }

  factory AvailabilityOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AvailabilityOverride(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      date: serializer.fromJson<String>(json['date']),
      minutes: serializer.fromJson<int>(json['minutes']),
      lockedExamId: serializer.fromJson<String?>(json['lockedExamId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'date': serializer.toJson<String>(date),
      'minutes': serializer.toJson<int>(minutes),
      'lockedExamId': serializer.toJson<String?>(lockedExamId),
    };
  }

  AvailabilityOverride copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? date,
    int? minutes,
    Value<String?> lockedExamId = const Value.absent(),
  }) => AvailabilityOverride(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    date: date ?? this.date,
    minutes: minutes ?? this.minutes,
    lockedExamId: lockedExamId.present ? lockedExamId.value : this.lockedExamId,
  );
  AvailabilityOverride copyWithCompanion(AvailabilityOverridesCompanion data) {
    return AvailabilityOverride(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      date: data.date.present ? data.date.value : this.date,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      lockedExamId: data.lockedExamId.present
          ? data.lockedExamId.value
          : this.lockedExamId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilityOverride(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('date: $date, ')
          ..write('minutes: $minutes, ')
          ..write('lockedExamId: $lockedExamId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    date,
    minutes,
    lockedExamId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AvailabilityOverride &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.date == this.date &&
          other.minutes == this.minutes &&
          other.lockedExamId == this.lockedExamId);
}

class AvailabilityOverridesCompanion
    extends UpdateCompanion<AvailabilityOverride> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> date;
  final Value<int> minutes;
  final Value<String?> lockedExamId;
  final Value<int> rowid;
  const AvailabilityOverridesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.date = const Value.absent(),
    this.minutes = const Value.absent(),
    this.lockedExamId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AvailabilityOverridesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String date,
    required int minutes,
    this.lockedExamId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       date = Value(date),
       minutes = Value(minutes);
  static Insertable<AvailabilityOverride> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? date,
    Expression<int>? minutes,
    Expression<String>? lockedExamId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (date != null) 'date': date,
      if (minutes != null) 'minutes': minutes,
      if (lockedExamId != null) 'locked_exam_id': lockedExamId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AvailabilityOverridesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? date,
    Value<int>? minutes,
    Value<String?>? lockedExamId,
    Value<int>? rowid,
  }) {
    return AvailabilityOverridesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      date: date ?? this.date,
      minutes: minutes ?? this.minutes,
      lockedExamId: lockedExamId ?? this.lockedExamId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (lockedExamId.present) {
      map['locked_exam_id'] = Variable<String>(lockedExamId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilityOverridesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('date: $date, ')
          ..write('minutes: $minutes, ')
          ..write('lockedExamId: $lockedExamId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanItemsTable extends PlanItems
    with TableInfo<$PlanItemsTable, PlanItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _examIdMeta = const VerificationMeta('examId');
  @override
  late final GeneratedColumn<String> examId = GeneratedColumn<String>(
    'exam_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exams (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlanItemKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PlanItemKind>($PlanItemsTable.$converterkind);
  static const VerificationMeta _estMinutesMeta = const VerificationMeta(
    'estMinutes',
  );
  @override
  late final GeneratedColumn<int> estMinutes = GeneratedColumn<int>(
    'est_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlanItemStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PlanItemStatus>($PlanItemsTable.$converterstatus);
  static const VerificationMeta _generationMeta = const VerificationMeta(
    'generation',
  );
  @override
  late final GeneratedColumn<int> generation = GeneratedColumn<int>(
    'generation',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    date,
    taskId,
    examId,
    kind,
    estMinutes,
    status,
    generation,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('exam_id')) {
      context.handle(
        _examIdMeta,
        examId.isAcceptableOrUnknown(data['exam_id']!, _examIdMeta),
      );
    }
    if (data.containsKey('est_minutes')) {
      context.handle(
        _estMinutesMeta,
        estMinutes.isAcceptableOrUnknown(data['est_minutes']!, _estMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_estMinutesMeta);
    }
    if (data.containsKey('generation')) {
      context.handle(
        _generationMeta,
        generation.isAcceptableOrUnknown(data['generation']!, _generationMeta),
      );
    } else if (isInserting) {
      context.missing(_generationMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['sort_order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      examId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_id'],
      ),
      kind: $PlanItemsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      estMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}est_minutes'],
      )!,
      status: $PlanItemsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      generation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}generation'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $PlanItemsTable createAlias(String alias) {
    return $PlanItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlanItemKind, String, String> $converterkind =
      const EnumNameConverter<PlanItemKind>(PlanItemKind.values);
  static JsonTypeConverter2<PlanItemStatus, String, String> $converterstatus =
      const EnumNameConverter<PlanItemStatus>(PlanItemStatus.values);
}

class PlanItem extends DataClass implements Insertable<PlanItem> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;

  /// `YYYY-MM-DD`.
  final String date;
  final String taskId;
  final String? examId;
  final PlanItemKind kind;
  final int estMinutes;
  final PlanItemStatus status;
  final int generation;

  /// Position within the day (planner spec, "Output").
  final int order;
  const PlanItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.date,
    required this.taskId,
    this.examId,
    required this.kind,
    required this.estMinutes,
    required this.status,
    required this.generation,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['date'] = Variable<String>(date);
    map['task_id'] = Variable<String>(taskId);
    if (!nullToAbsent || examId != null) {
      map['exam_id'] = Variable<String>(examId);
    }
    {
      map['kind'] = Variable<String>(
        $PlanItemsTable.$converterkind.toSql(kind),
      );
    }
    map['est_minutes'] = Variable<int>(estMinutes);
    {
      map['status'] = Variable<String>(
        $PlanItemsTable.$converterstatus.toSql(status),
      );
    }
    map['generation'] = Variable<int>(generation);
    map['sort_order'] = Variable<int>(order);
    return map;
  }

  PlanItemsCompanion toCompanion(bool nullToAbsent) {
    return PlanItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      date: Value(date),
      taskId: Value(taskId),
      examId: examId == null && nullToAbsent
          ? const Value.absent()
          : Value(examId),
      kind: Value(kind),
      estMinutes: Value(estMinutes),
      status: Value(status),
      generation: Value(generation),
      order: Value(order),
    );
  }

  factory PlanItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      date: serializer.fromJson<String>(json['date']),
      taskId: serializer.fromJson<String>(json['taskId']),
      examId: serializer.fromJson<String?>(json['examId']),
      kind: $PlanItemsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      estMinutes: serializer.fromJson<int>(json['estMinutes']),
      status: $PlanItemsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      generation: serializer.fromJson<int>(json['generation']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'date': serializer.toJson<String>(date),
      'taskId': serializer.toJson<String>(taskId),
      'examId': serializer.toJson<String?>(examId),
      'kind': serializer.toJson<String>(
        $PlanItemsTable.$converterkind.toJson(kind),
      ),
      'estMinutes': serializer.toJson<int>(estMinutes),
      'status': serializer.toJson<String>(
        $PlanItemsTable.$converterstatus.toJson(status),
      ),
      'generation': serializer.toJson<int>(generation),
      'order': serializer.toJson<int>(order),
    };
  }

  PlanItem copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? date,
    String? taskId,
    Value<String?> examId = const Value.absent(),
    PlanItemKind? kind,
    int? estMinutes,
    PlanItemStatus? status,
    int? generation,
    int? order,
  }) => PlanItem(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    date: date ?? this.date,
    taskId: taskId ?? this.taskId,
    examId: examId.present ? examId.value : this.examId,
    kind: kind ?? this.kind,
    estMinutes: estMinutes ?? this.estMinutes,
    status: status ?? this.status,
    generation: generation ?? this.generation,
    order: order ?? this.order,
  );
  PlanItem copyWithCompanion(PlanItemsCompanion data) {
    return PlanItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      date: data.date.present ? data.date.value : this.date,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      examId: data.examId.present ? data.examId.value : this.examId,
      kind: data.kind.present ? data.kind.value : this.kind,
      estMinutes: data.estMinutes.present
          ? data.estMinutes.value
          : this.estMinutes,
      status: data.status.present ? data.status.value : this.status,
      generation: data.generation.present
          ? data.generation.value
          : this.generation,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('date: $date, ')
          ..write('taskId: $taskId, ')
          ..write('examId: $examId, ')
          ..write('kind: $kind, ')
          ..write('estMinutes: $estMinutes, ')
          ..write('status: $status, ')
          ..write('generation: $generation, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    date,
    taskId,
    examId,
    kind,
    estMinutes,
    status,
    generation,
    order,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.date == this.date &&
          other.taskId == this.taskId &&
          other.examId == this.examId &&
          other.kind == this.kind &&
          other.estMinutes == this.estMinutes &&
          other.status == this.status &&
          other.generation == this.generation &&
          other.order == this.order);
}

class PlanItemsCompanion extends UpdateCompanion<PlanItem> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> date;
  final Value<String> taskId;
  final Value<String?> examId;
  final Value<PlanItemKind> kind;
  final Value<int> estMinutes;
  final Value<PlanItemStatus> status;
  final Value<int> generation;
  final Value<int> order;
  final Value<int> rowid;
  const PlanItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.date = const Value.absent(),
    this.taskId = const Value.absent(),
    this.examId = const Value.absent(),
    this.kind = const Value.absent(),
    this.estMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.generation = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanItemsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String date,
    required String taskId,
    this.examId = const Value.absent(),
    required PlanItemKind kind,
    required int estMinutes,
    required PlanItemStatus status,
    required int generation,
    required int order,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       date = Value(date),
       taskId = Value(taskId),
       kind = Value(kind),
       estMinutes = Value(estMinutes),
       status = Value(status),
       generation = Value(generation),
       order = Value(order);
  static Insertable<PlanItem> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? date,
    Expression<String>? taskId,
    Expression<String>? examId,
    Expression<String>? kind,
    Expression<int>? estMinutes,
    Expression<String>? status,
    Expression<int>? generation,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (date != null) 'date': date,
      if (taskId != null) 'task_id': taskId,
      if (examId != null) 'exam_id': examId,
      if (kind != null) 'kind': kind,
      if (estMinutes != null) 'est_minutes': estMinutes,
      if (status != null) 'status': status,
      if (generation != null) 'generation': generation,
      if (order != null) 'sort_order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanItemsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? date,
    Value<String>? taskId,
    Value<String?>? examId,
    Value<PlanItemKind>? kind,
    Value<int>? estMinutes,
    Value<PlanItemStatus>? status,
    Value<int>? generation,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return PlanItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      date: date ?? this.date,
      taskId: taskId ?? this.taskId,
      examId: examId ?? this.examId,
      kind: kind ?? this.kind,
      estMinutes: estMinutes ?? this.estMinutes,
      status: status ?? this.status,
      generation: generation ?? this.generation,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (examId.present) {
      map['exam_id'] = Variable<String>(examId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $PlanItemsTable.$converterkind.toSql(kind.value),
      );
    }
    if (estMinutes.present) {
      map['est_minutes'] = Variable<int>(estMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $PlanItemsTable.$converterstatus.toSql(status.value),
      );
    }
    if (generation.present) {
      map['generation'] = Variable<int>(generation.value);
    }
    if (order.present) {
      map['sort_order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('date: $date, ')
          ..write('taskId: $taskId, ')
          ..write('examId: $examId, ')
          ..write('kind: $kind, ')
          ..write('estMinutes: $estMinutes, ')
          ..write('status: $status, ')
          ..write('generation: $generation, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestsTable extends Quests with TableInfo<$QuestsTable, Quest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    date,
    type,
    target,
    progress,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quests';
  @override
  VerificationContext validateIntegrity(
    Insertable<Quest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $QuestsTable createAlias(String alias) {
    return $QuestsTable(attachedDatabase, alias);
  }
}

class Quest extends DataClass implements Insertable<Quest> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;

  /// `YYYY-MM-DD`.
  final String date;
  final String type;
  final int target;
  final int progress;
  final int? completedAt;
  const Quest({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.date,
    required this.type,
    required this.target,
    required this.progress,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['date'] = Variable<String>(date);
    map['type'] = Variable<String>(type);
    map['target'] = Variable<int>(target);
    map['progress'] = Variable<int>(progress);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    return map;
  }

  QuestsCompanion toCompanion(bool nullToAbsent) {
    return QuestsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      date: Value(date),
      type: Value(type),
      target: Value(target),
      progress: Value(progress),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory Quest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quest(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      date: serializer.fromJson<String>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      target: serializer.fromJson<int>(json['target']),
      progress: serializer.fromJson<int>(json['progress']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'date': serializer.toJson<String>(date),
      'type': serializer.toJson<String>(type),
      'target': serializer.toJson<int>(target),
      'progress': serializer.toJson<int>(progress),
      'completedAt': serializer.toJson<int?>(completedAt),
    };
  }

  Quest copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? date,
    String? type,
    int? target,
    int? progress,
    Value<int?> completedAt = const Value.absent(),
  }) => Quest(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    date: date ?? this.date,
    type: type ?? this.type,
    target: target ?? this.target,
    progress: progress ?? this.progress,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  Quest copyWithCompanion(QuestsCompanion data) {
    return Quest(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      target: data.target.present ? data.target.value : this.target,
      progress: data.progress.present ? data.progress.value : this.progress,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quest(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('progress: $progress, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    date,
    type,
    target,
    progress,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quest &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.date == this.date &&
          other.type == this.type &&
          other.target == this.target &&
          other.progress == this.progress &&
          other.completedAt == this.completedAt);
}

class QuestsCompanion extends UpdateCompanion<Quest> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> date;
  final Value<String> type;
  final Value<int> target;
  final Value<int> progress;
  final Value<int?> completedAt;
  final Value<int> rowid;
  const QuestsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.target = const Value.absent(),
    this.progress = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String date,
    required String type,
    required int target,
    required int progress,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       date = Value(date),
       type = Value(type),
       target = Value(target),
       progress = Value(progress);
  static Insertable<Quest> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? date,
    Expression<String>? type,
    Expression<int>? target,
    Expression<int>? progress,
    Expression<int>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (target != null) 'target': target,
      if (progress != null) 'progress': progress,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? date,
    Value<String>? type,
    Value<int>? target,
    Value<int>? progress,
    Value<int?>? completedAt,
    Value<int>? rowid,
  }) {
    return QuestsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      date: date ?? this.date,
      type: type ?? this.type,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('progress: $progress, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<int> unlockedAt = GeneratedColumn<int>(
    'unlocked_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    code,
    unlockedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unlocked_at'],
      )!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String code;
  final int unlockedAt;
  const Achievement({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.code,
    required this.unlockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['code'] = Variable<String>(code);
    map['unlocked_at'] = Variable<int>(unlockedAt);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      code: Value(code),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      code: serializer.fromJson<String>(json['code']),
      unlockedAt: serializer.fromJson<int>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'code': serializer.toJson<String>(code),
      'unlockedAt': serializer.toJson<int>(unlockedAt),
    };
  }

  Achievement copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? code,
    int? unlockedAt,
  }) => Achievement(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    code: code ?? this.code,
    unlockedAt: unlockedAt ?? this.unlockedAt,
  );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      code: data.code.present ? data.code.value : this.code,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('code: $code, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    code,
    unlockedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.code == this.code &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> code;
  final Value<int> unlockedAt;
  final Value<int> rowid;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.code = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String code,
    required int unlockedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       code = Value(code),
       unlockedAt = Value(unlockedAt);
  static Insertable<Achievement> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? code,
    Expression<int>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (code != null) 'code': code,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? code,
    Value<int>? unlockedAt,
    Value<int>? rowid,
  }) {
    return AchievementsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      code: code ?? this.code,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<int>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('code: $code, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RestTokensTable extends RestTokens
    with TableInfo<$RestTokensTable, RestToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<int> earnedAt = GeneratedColumn<int>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usedOnMeta = const VerificationMeta('usedOn');
  @override
  late final GeneratedColumn<String> usedOn = GeneratedColumn<String>(
    'used_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    earnedAt,
    usedOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rest_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestToken> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    if (data.containsKey('used_on')) {
      context.handle(
        _usedOnMeta,
        usedOn.isAcceptableOrUnknown(data['used_on']!, _usedOnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestToken(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}earned_at'],
      )!,
      usedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}used_on'],
      ),
    );
  }

  @override
  $RestTokensTable createAlias(String alias) {
    return $RestTokensTable(attachedDatabase, alias);
  }
}

class RestToken extends DataClass implements Insertable<RestToken> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final int earnedAt;

  /// `YYYY-MM-DD`.
  final String? usedOn;
  const RestToken({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.earnedAt,
    this.usedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['earned_at'] = Variable<int>(earnedAt);
    if (!nullToAbsent || usedOn != null) {
      map['used_on'] = Variable<String>(usedOn);
    }
    return map;
  }

  RestTokensCompanion toCompanion(bool nullToAbsent) {
    return RestTokensCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      earnedAt: Value(earnedAt),
      usedOn: usedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(usedOn),
    );
  }

  factory RestToken.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestToken(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      earnedAt: serializer.fromJson<int>(json['earnedAt']),
      usedOn: serializer.fromJson<String?>(json['usedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'earnedAt': serializer.toJson<int>(earnedAt),
      'usedOn': serializer.toJson<String?>(usedOn),
    };
  }

  RestToken copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    int? earnedAt,
    Value<String?> usedOn = const Value.absent(),
  }) => RestToken(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    earnedAt: earnedAt ?? this.earnedAt,
    usedOn: usedOn.present ? usedOn.value : this.usedOn,
  );
  RestToken copyWithCompanion(RestTokensCompanion data) {
    return RestToken(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
      usedOn: data.usedOn.present ? data.usedOn.value : this.usedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestToken(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('usedOn: $usedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    earnedAt,
    usedOn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestToken &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.earnedAt == this.earnedAt &&
          other.usedOn == this.usedOn);
}

class RestTokensCompanion extends UpdateCompanion<RestToken> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<int> earnedAt;
  final Value<String?> usedOn;
  final Value<int> rowid;
  const RestTokensCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.usedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RestTokensCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required int earnedAt,
    this.usedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       earnedAt = Value(earnedAt);
  static Insertable<RestToken> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<int>? earnedAt,
    Expression<String>? usedOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (usedOn != null) 'used_on': usedOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RestTokensCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<int>? earnedAt,
    Value<String?>? usedOn,
    Value<int>? rowid,
  }) {
    return RestTokensCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      earnedAt: earnedAt ?? this.earnedAt,
      usedOn: usedOn ?? this.usedOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<int>(earnedAt.value);
    }
    if (usedOn.present) {
      map['used_on'] = Variable<String>(usedOn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestTokensCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('usedOn: $usedOn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TemplatesTable extends Templates
    with TableInfo<$TemplatesTable, Template> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TemplateKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TemplateKind>($TemplatesTable.$converterkind);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TemplateOrigin, String> origin =
      GeneratedColumn<String>(
        'origin',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TemplateOrigin>($TemplatesTable.$converterorigin);
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<int> importedAt = GeneratedColumn<int>(
    'imported_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    kind,
    name,
    author,
    version,
    origin,
    payload,
    importedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<Template> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Template map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Template(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      kind: $TemplatesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      origin: $TemplatesTable.$converterorigin.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}origin'],
        )!,
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imported_at'],
      ),
    );
  }

  @override
  $TemplatesTable createAlias(String alias) {
    return $TemplatesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TemplateKind, String, String> $converterkind =
      const EnumNameConverter<TemplateKind>(TemplateKind.values);
  static JsonTypeConverter2<TemplateOrigin, String, String> $converterorigin =
      const EnumNameConverter<TemplateOrigin>(TemplateOrigin.values);
}

class Template extends DataClass implements Insertable<Template> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final TemplateKind kind;
  final String name;
  final String? author;
  final int version;
  final TemplateOrigin origin;

  /// JSON.
  final String payload;
  final int? importedAt;
  const Template({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.kind,
    required this.name,
    this.author,
    required this.version,
    required this.origin,
    required this.payload,
    this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    {
      map['kind'] = Variable<String>(
        $TemplatesTable.$converterkind.toSql(kind),
      );
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    map['version'] = Variable<int>(version);
    {
      map['origin'] = Variable<String>(
        $TemplatesTable.$converterorigin.toSql(origin),
      );
    }
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || importedAt != null) {
      map['imported_at'] = Variable<int>(importedAt);
    }
    return map;
  }

  TemplatesCompanion toCompanion(bool nullToAbsent) {
    return TemplatesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      kind: Value(kind),
      name: Value(name),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      version: Value(version),
      origin: Value(origin),
      payload: Value(payload),
      importedAt: importedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(importedAt),
    );
  }

  factory Template.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Template(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      kind: $TemplatesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      name: serializer.fromJson<String>(json['name']),
      author: serializer.fromJson<String?>(json['author']),
      version: serializer.fromJson<int>(json['version']),
      origin: $TemplatesTable.$converterorigin.fromJson(
        serializer.fromJson<String>(json['origin']),
      ),
      payload: serializer.fromJson<String>(json['payload']),
      importedAt: serializer.fromJson<int?>(json['importedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'kind': serializer.toJson<String>(
        $TemplatesTable.$converterkind.toJson(kind),
      ),
      'name': serializer.toJson<String>(name),
      'author': serializer.toJson<String?>(author),
      'version': serializer.toJson<int>(version),
      'origin': serializer.toJson<String>(
        $TemplatesTable.$converterorigin.toJson(origin),
      ),
      'payload': serializer.toJson<String>(payload),
      'importedAt': serializer.toJson<int?>(importedAt),
    };
  }

  Template copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    TemplateKind? kind,
    String? name,
    Value<String?> author = const Value.absent(),
    int? version,
    TemplateOrigin? origin,
    String? payload,
    Value<int?> importedAt = const Value.absent(),
  }) => Template(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    kind: kind ?? this.kind,
    name: name ?? this.name,
    author: author.present ? author.value : this.author,
    version: version ?? this.version,
    origin: origin ?? this.origin,
    payload: payload ?? this.payload,
    importedAt: importedAt.present ? importedAt.value : this.importedAt,
  );
  Template copyWithCompanion(TemplatesCompanion data) {
    return Template(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      kind: data.kind.present ? data.kind.value : this.kind,
      name: data.name.present ? data.name.value : this.name,
      author: data.author.present ? data.author.value : this.author,
      version: data.version.present ? data.version.value : this.version,
      origin: data.origin.present ? data.origin.value : this.origin,
      payload: data.payload.present ? data.payload.value : this.payload,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Template(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('author: $author, ')
          ..write('version: $version, ')
          ..write('origin: $origin, ')
          ..write('payload: $payload, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    kind,
    name,
    author,
    version,
    origin,
    payload,
    importedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Template &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.kind == this.kind &&
          other.name == this.name &&
          other.author == this.author &&
          other.version == this.version &&
          other.origin == this.origin &&
          other.payload == this.payload &&
          other.importedAt == this.importedAt);
}

class TemplatesCompanion extends UpdateCompanion<Template> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<TemplateKind> kind;
  final Value<String> name;
  final Value<String?> author;
  final Value<int> version;
  final Value<TemplateOrigin> origin;
  final Value<String> payload;
  final Value<int?> importedAt;
  final Value<int> rowid;
  const TemplatesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.author = const Value.absent(),
    this.version = const Value.absent(),
    this.origin = const Value.absent(),
    this.payload = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplatesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required TemplateKind kind,
    required String name,
    this.author = const Value.absent(),
    required int version,
    required TemplateOrigin origin,
    required String payload,
    this.importedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       kind = Value(kind),
       name = Value(name),
       version = Value(version),
       origin = Value(origin),
       payload = Value(payload);
  static Insertable<Template> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? kind,
    Expression<String>? name,
    Expression<String>? author,
    Expression<int>? version,
    Expression<String>? origin,
    Expression<String>? payload,
    Expression<int>? importedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (kind != null) 'kind': kind,
      if (name != null) 'name': name,
      if (author != null) 'author': author,
      if (version != null) 'version': version,
      if (origin != null) 'origin': origin,
      if (payload != null) 'payload': payload,
      if (importedAt != null) 'imported_at': importedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplatesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<TemplateKind>? kind,
    Value<String>? name,
    Value<String?>? author,
    Value<int>? version,
    Value<TemplateOrigin>? origin,
    Value<String>? payload,
    Value<int?>? importedAt,
    Value<int>? rowid,
  }) {
    return TemplatesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      author: author ?? this.author,
      version: version ?? this.version,
      origin: origin ?? this.origin,
      payload: payload ?? this.payload,
      importedAt: importedAt ?? this.importedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $TemplatesTable.$converterkind.toSql(kind.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(
        $TemplatesTable.$converterorigin.toSql(origin.value),
      );
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<int>(importedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('author: $author, ')
          ..write('version: $version, ')
          ..write('origin: $origin, ')
          ..write('payload: $payload, ')
          ..write('importedAt: $importedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportMapsTable extends ImportMaps
    with TableInfo<$ImportMapsTable, ImportMap> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportMapsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES templates (id)',
    ),
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localTableMeta = const VerificationMeta(
    'localTable',
  );
  @override
  late final GeneratedColumn<String> localTable = GeneratedColumn<String>(
    'local_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    templateId,
    externalId,
    localTable,
    localId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_maps';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportMap> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('local_table')) {
      context.handle(
        _localTableMeta,
        localTable.isAcceptableOrUnknown(data['local_table']!, _localTableMeta),
      );
    } else if (isInserting) {
      context.missing(_localTableMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportMap map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportMap(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
      localTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_table'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
    );
  }

  @override
  $ImportMapsTable createAlias(String alias) {
    return $ImportMapsTable(attachedDatabase, alias);
  }
}

class ImportMap extends DataClass implements Insertable<ImportMap> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String templateId;
  final String externalId;
  final String localTable;
  final String localId;
  const ImportMap({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.templateId,
    required this.externalId,
    required this.localTable,
    required this.localId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['template_id'] = Variable<String>(templateId);
    map['external_id'] = Variable<String>(externalId);
    map['local_table'] = Variable<String>(localTable);
    map['local_id'] = Variable<String>(localId);
    return map;
  }

  ImportMapsCompanion toCompanion(bool nullToAbsent) {
    return ImportMapsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      templateId: Value(templateId),
      externalId: Value(externalId),
      localTable: Value(localTable),
      localId: Value(localId),
    );
  }

  factory ImportMap.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportMap(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      templateId: serializer.fromJson<String>(json['templateId']),
      externalId: serializer.fromJson<String>(json['externalId']),
      localTable: serializer.fromJson<String>(json['localTable']),
      localId: serializer.fromJson<String>(json['localId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'templateId': serializer.toJson<String>(templateId),
      'externalId': serializer.toJson<String>(externalId),
      'localTable': serializer.toJson<String>(localTable),
      'localId': serializer.toJson<String>(localId),
    };
  }

  ImportMap copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? templateId,
    String? externalId,
    String? localTable,
    String? localId,
  }) => ImportMap(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    templateId: templateId ?? this.templateId,
    externalId: externalId ?? this.externalId,
    localTable: localTable ?? this.localTable,
    localId: localId ?? this.localId,
  );
  ImportMap copyWithCompanion(ImportMapsCompanion data) {
    return ImportMap(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      localTable: data.localTable.present
          ? data.localTable.value
          : this.localTable,
      localId: data.localId.present ? data.localId.value : this.localId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportMap(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('templateId: $templateId, ')
          ..write('externalId: $externalId, ')
          ..write('localTable: $localTable, ')
          ..write('localId: $localId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    templateId,
    externalId,
    localTable,
    localId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportMap &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.templateId == this.templateId &&
          other.externalId == this.externalId &&
          other.localTable == this.localTable &&
          other.localId == this.localId);
}

class ImportMapsCompanion extends UpdateCompanion<ImportMap> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> templateId;
  final Value<String> externalId;
  final Value<String> localTable;
  final Value<String> localId;
  final Value<int> rowid;
  const ImportMapsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.externalId = const Value.absent(),
    this.localTable = const Value.absent(),
    this.localId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportMapsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String templateId,
    required String externalId,
    required String localTable,
    required String localId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       templateId = Value(templateId),
       externalId = Value(externalId),
       localTable = Value(localTable),
       localId = Value(localId);
  static Insertable<ImportMap> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? templateId,
    Expression<String>? externalId,
    Expression<String>? localTable,
    Expression<String>? localId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (templateId != null) 'template_id': templateId,
      if (externalId != null) 'external_id': externalId,
      if (localTable != null) 'local_table': localTable,
      if (localId != null) 'local_id': localId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportMapsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? templateId,
    Value<String>? externalId,
    Value<String>? localTable,
    Value<String>? localId,
    Value<int>? rowid,
  }) {
    return ImportMapsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      templateId: templateId ?? this.templateId,
      externalId: externalId ?? this.externalId,
      localTable: localTable ?? this.localTable,
      localId: localId ?? this.localId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (localTable.present) {
      map['local_table'] = Variable<String>(localTable.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportMapsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('templateId: $templateId, ')
          ..write('externalId: $externalId, ')
          ..write('localTable: $localTable, ')
          ..write('localId: $localId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    key,
    value,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String key;

  /// JSON.
  final String value;
  const Setting({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.key,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      key: Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? key,
    String? value,
  }) => Setting(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    key: key ?? this.key,
    value: value ?? this.value,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    key,
    value,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EventOp, String> op =
      GeneratedColumn<String>(
        'op',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EventOp>($EventsTable.$converterop);
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    entity,
    entityId,
    op,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: $EventsTable.$converterop.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}op'],
        )!,
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EventOp, String, String> $converterop =
      const EnumNameConverter<EventOp>(EventOp.values);
}

class Event extends DataClass implements Insertable<Event> {
  /// UUIDv7.
  final String id;
  final int createdAt;
  final int updatedAt;

  /// Soft delete; rows are never physically removed in phase 1.
  final int? deletedAt;
  final String hlc;
  final String deviceId;
  final String entity;
  final String entityId;
  final EventOp op;

  /// JSON: `{"changes": [{"table", "id", "before", "after"}], "undoOf"?}`.
  final String payload;
  const Event({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.hlc,
    required this.deviceId,
    required this.entity,
    required this.entityId,
    required this.op,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['hlc'] = Variable<String>(hlc);
    map['device_id'] = Variable<String>(deviceId);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    {
      map['op'] = Variable<String>($EventsTable.$converterop.toSql(op));
    }
    map['payload'] = Variable<String>(payload);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hlc: Value(hlc),
      deviceId: Value(deviceId),
      entity: Value(entity),
      entityId: Value(entityId),
      op: Value(op),
      payload: Value(payload),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: $EventsTable.$converterop.fromJson(
        serializer.fromJson<String>(json['op']),
      ),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'hlc': serializer.toJson<String>(hlc),
      'deviceId': serializer.toJson<String>(deviceId),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>($EventsTable.$converterop.toJson(op)),
      'payload': serializer.toJson<String>(payload),
    };
  }

  Event copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? hlc,
    String? deviceId,
    String? entity,
    String? entityId,
    EventOp? op,
    String? payload,
  }) => Event(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hlc: hlc ?? this.hlc,
    deviceId: deviceId ?? this.deviceId,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    payload: payload ?? this.payload,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    hlc,
    deviceId,
    entity,
    entityId,
    op,
    payload,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.hlc == this.hlc &&
          other.deviceId == this.deviceId &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.payload == this.payload);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> hlc;
  final Value<String> deviceId;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<EventOp> op;
  final Value<String> payload;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String hlc,
    required String deviceId,
    required String entity,
    required String entityId,
    required EventOp op,
    required String payload,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       hlc = Value(hlc),
       deviceId = Value(deviceId),
       entity = Value(entity),
       entityId = Value(entityId),
       op = Value(op),
       payload = Value(payload);
  static Insertable<Event> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? hlc,
    Expression<String>? deviceId,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hlc != null) 'hlc': hlc,
      if (deviceId != null) 'device_id': deviceId,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? hlc,
    Value<String>? deviceId,
    Value<String>? entity,
    Value<String>? entityId,
    Value<EventOp>? op,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hlc: hlc ?? this.hlc,
      deviceId: deviceId ?? this.deviceId,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>($EventsTable.$converterop.toSql(op.value));
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hlc: $hlc, ')
          ..write('deviceId: $deviceId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActiveSessionsTable extends ActiveSessions
    with TableInfo<$ActiveSessionsTable, ActiveSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resumeUnitMeta = const VerificationMeta(
    'resumeUnit',
  );
  @override
  late final GeneratedColumn<int> resumeUnit = GeneratedColumn<int>(
    'resume_unit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    startedAt,
    resumeUnit,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('resume_unit')) {
      context.handle(
        _resumeUnitMeta,
        resumeUnit.isAcceptableOrUnknown(data['resume_unit']!, _resumeUnitMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      resumeUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resume_unit'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActiveSessionsTable createAlias(String alias) {
    return $ActiveSessionsTable(attachedDatabase, alias);
  }
}

class ActiveSession extends DataClass implements Insertable<ActiveSession> {
  final String id;
  final String taskId;
  final int startedAt;
  final int? resumeUnit;
  final int createdAt;
  final int updatedAt;
  const ActiveSession({
    required this.id,
    required this.taskId,
    required this.startedAt,
    this.resumeUnit,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || resumeUnit != null) {
      map['resume_unit'] = Variable<int>(resumeUnit);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ActiveSessionsCompanion toCompanion(bool nullToAbsent) {
    return ActiveSessionsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      startedAt: Value(startedAt),
      resumeUnit: resumeUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(resumeUnit),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActiveSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveSession(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      resumeUnit: serializer.fromJson<int?>(json['resumeUnit']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'startedAt': serializer.toJson<int>(startedAt),
      'resumeUnit': serializer.toJson<int?>(resumeUnit),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ActiveSession copyWith({
    String? id,
    String? taskId,
    int? startedAt,
    Value<int?> resumeUnit = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ActiveSession(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    startedAt: startedAt ?? this.startedAt,
    resumeUnit: resumeUnit.present ? resumeUnit.value : this.resumeUnit,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActiveSession copyWithCompanion(ActiveSessionsCompanion data) {
    return ActiveSession(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      resumeUnit: data.resumeUnit.present
          ? data.resumeUnit.value
          : this.resumeUnit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveSession(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('startedAt: $startedAt, ')
          ..write('resumeUnit: $resumeUnit, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, startedAt, resumeUnit, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveSession &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.startedAt == this.startedAt &&
          other.resumeUnit == this.resumeUnit &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActiveSessionsCompanion extends UpdateCompanion<ActiveSession> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<int> startedAt;
  final Value<int?> resumeUnit;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ActiveSessionsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.resumeUnit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveSessionsCompanion.insert({
    required String id,
    required String taskId,
    required int startedAt,
    this.resumeUnit = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       startedAt = Value(startedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActiveSession> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? startedAt,
    Expression<int>? resumeUnit,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (startedAt != null) 'started_at': startedAt,
      if (resumeUnit != null) 'resume_unit': resumeUnit,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<int>? startedAt,
    Value<int?>? resumeUnit,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ActiveSessionsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      startedAt: startedAt ?? this.startedAt,
      resumeUnit: resumeUnit ?? this.resumeUnit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (resumeUnit.present) {
      map['resume_unit'] = Variable<int>(resumeUnit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveSessionsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('startedAt: $startedAt, ')
          ..write('resumeUnit: $resumeUnit, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TopicsTable topics = $TopicsTable(this);
  late final $SourcesTable sources = $SourcesTable(this);
  late final $SourceFilesTable sourceFiles = $SourceFilesTable(this);
  late final $ChunksTable chunks = $ChunksTable(this);
  late final $ChunkSurveysTable chunkSurveys = $ChunkSurveysTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TaskChunksTable taskChunks = $TaskChunksTable(this);
  late final $TaskStatesTable taskStates = $TaskStatesTable(this);
  late final $ReviewsTable reviews = $ReviewsTable(this);
  late final $TaskLineagesTable taskLineages = $TaskLineagesTable(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $CardResultsTable cardResults = $CardResultsTable(this);
  late final $ExamsTable exams = $ExamsTable(this);
  late final $ExamChunksTable examChunks = $ExamChunksTable(this);
  late final $ExamTasksTable examTasks = $ExamTasksTable(this);
  late final $AvailabilitiesTable availabilities = $AvailabilitiesTable(this);
  late final $AvailabilityOverridesTable availabilityOverrides =
      $AvailabilityOverridesTable(this);
  late final $PlanItemsTable planItems = $PlanItemsTable(this);
  late final $QuestsTable quests = $QuestsTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $RestTokensTable restTokens = $RestTokensTable(this);
  late final $TemplatesTable templates = $TemplatesTable(this);
  late final $ImportMapsTable importMaps = $ImportMapsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $ActiveSessionsTable activeSessions = $ActiveSessionsTable(this);
  late final Index taskChunksTask = Index(
    'task_chunks_task',
    'CREATE INDEX task_chunks_task ON task_chunks (task_id)',
  );
  late final Index reviewsTaskAt = Index(
    'reviews_task_at',
    'CREATE INDEX reviews_task_at ON reviews (task_id, at)',
  );
  late final Index examTasksExam = Index(
    'exam_tasks_exam',
    'CREATE INDEX exam_tasks_exam ON exam_tasks (exam_id)',
  );
  late final Index planItemsDate = Index(
    'plan_items_date',
    'CREATE INDEX plan_items_date ON plan_items (date)',
  );
  late final Index eventsEntity = Index(
    'events_entity',
    'CREATE INDEX events_entity ON events (entity, entity_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    topics,
    sources,
    sourceFiles,
    chunks,
    chunkSurveys,
    tasks,
    taskChunks,
    taskStates,
    reviews,
    taskLineages,
    cards,
    cardResults,
    exams,
    examChunks,
    examTasks,
    availabilities,
    availabilityOverrides,
    planItems,
    quests,
    achievements,
    restTokens,
    templates,
    importMaps,
    settings,
    events,
    activeSessions,
    taskChunksTask,
    reviewsTaskAt,
    examTasksExam,
    planItemsDate,
    eventsEntity,
  ];
}

typedef $$TopicsTableCreateCompanionBuilder =
    TopicsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      Value<String?> parentId,
      required String name,
      Value<String?> subject,
      required int order,
      Value<int> rowid,
    });
typedef $$TopicsTableUpdateCompanionBuilder =
    TopicsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String?> parentId,
      Value<String> name,
      Value<String?> subject,
      Value<int> order,
      Value<int> rowid,
    });

final class $$TopicsTableReferences
    extends BaseReferences<_$AppDatabase, $TopicsTable, Topic> {
  $$TopicsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TopicsTable _parentIdTable(_$AppDatabase db) => db.topics.createAlias(
    $_aliasNameGenerator(db.topics.parentId, db.topics.id),
  );

  $$TopicsTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$TopicsTableTableManager(
      $_db,
      $_db.topics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: $_aliasNameGenerator(db.topics.id, db.tasks.topicId),
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.topicId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TopicsTableFilterComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  $$TopicsTableFilterComposer get parentId {
    final $$TopicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableFilterComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  $$TopicsTableOrderingComposer get parentId {
    final $$TopicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableOrderingComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  $$TopicsTableAnnotationComposer get parentId {
    final $$TopicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableAnnotationComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TopicsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TopicsTable,
          Topic,
          $$TopicsTableFilterComposer,
          $$TopicsTableOrderingComposer,
          $$TopicsTableAnnotationComposer,
          $$TopicsTableCreateCompanionBuilder,
          $$TopicsTableUpdateCompanionBuilder,
          (Topic, $$TopicsTableReferences),
          Topic,
          PrefetchHooks Function({bool parentId, bool tasksRefs})
        > {
  $$TopicsTableTableManager(_$AppDatabase db, $TopicsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> subject = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopicsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                parentId: parentId,
                name: name,
                subject: subject,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                Value<String?> parentId = const Value.absent(),
                required String name,
                Value<String?> subject = const Value.absent(),
                required int order,
                Value<int> rowid = const Value.absent(),
              }) => TopicsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                parentId: parentId,
                name: name,
                subject: subject,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TopicsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({parentId = false, tasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tasksRefs) db.tasks],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (parentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.parentId,
                                referencedTable: $$TopicsTableReferences
                                    ._parentIdTable(db),
                                referencedColumn: $$TopicsTableReferences
                                    ._parentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksRefs)
                    await $_getPrefetchedData<Topic, $TopicsTable, Task>(
                      currentTable: table,
                      referencedTable: $$TopicsTableReferences._tasksRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TopicsTableReferences(db, table, p0).tasksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.topicId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TopicsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TopicsTable,
      Topic,
      $$TopicsTableFilterComposer,
      $$TopicsTableOrderingComposer,
      $$TopicsTableAnnotationComposer,
      $$TopicsTableCreateCompanionBuilder,
      $$TopicsTableUpdateCompanionBuilder,
      (Topic, $$TopicsTableReferences),
      Topic,
      PrefetchHooks Function({bool parentId, bool tasksRefs})
    >;
typedef $$SourcesTableCreateCompanionBuilder =
    SourcesCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required SourceType type,
      required String title,
      Value<String?> uri,
      required UnitType unitType,
      Value<int?> totalUnits,
      Value<int> rowid,
    });
typedef $$SourcesTableUpdateCompanionBuilder =
    SourcesCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<SourceType> type,
      Value<String> title,
      Value<String?> uri,
      Value<UnitType> unitType,
      Value<int?> totalUnits,
      Value<int> rowid,
    });

final class $$SourcesTableReferences
    extends BaseReferences<_$AppDatabase, $SourcesTable, Source> {
  $$SourcesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SourceFilesTable, List<SourceFile>>
  _sourceFilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceFiles,
    aliasName: $_aliasNameGenerator(db.sources.id, db.sourceFiles.sourceId),
  );

  $$SourceFilesTableProcessedTableManager get sourceFilesRefs {
    final manager = $$SourceFilesTableTableManager(
      $_db,
      $_db.sourceFiles,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChunksTable, List<Chunk>> _chunksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chunks,
    aliasName: $_aliasNameGenerator(db.sources.id, db.chunks.sourceId),
  );

  $$ChunksTableProcessedTableManager get chunksRefs {
    final manager = $$ChunksTableTableManager(
      $_db,
      $_db.chunks,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chunksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SourcesTableFilterComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SourceType, SourceType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UnitType, UnitType, String> get unitType =>
      $composableBuilder(
        column: $table.unitType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sourceFilesRefs(
    Expression<bool> Function($$SourceFilesTableFilterComposer f) f,
  ) {
    final $$SourceFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceFiles,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceFilesTableFilterComposer(
            $db: $db,
            $table: $db.sourceFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> chunksRefs(
    Expression<bool> Function($$ChunksTableFilterComposer f) f,
  ) {
    final $$ChunksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableFilterComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UnitType, String> get unitType =>
      $composableBuilder(column: $table.unitType, builder: (column) => column);

  GeneratedColumn<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => column,
  );

  Expression<T> sourceFilesRefs<T extends Object>(
    Expression<T> Function($$SourceFilesTableAnnotationComposer a) f,
  ) {
    final $$SourceFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceFiles,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> chunksRefs<T extends Object>(
    Expression<T> Function($$ChunksTableAnnotationComposer a) f,
  ) {
    final $$ChunksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableAnnotationComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourcesTable,
          Source,
          $$SourcesTableFilterComposer,
          $$SourcesTableOrderingComposer,
          $$SourcesTableAnnotationComposer,
          $$SourcesTableCreateCompanionBuilder,
          $$SourcesTableUpdateCompanionBuilder,
          (Source, $$SourcesTableReferences),
          Source,
          PrefetchHooks Function({bool sourceFilesRefs, bool chunksRefs})
        > {
  $$SourcesTableTableManager(_$AppDatabase db, $SourcesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<SourceType> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> uri = const Value.absent(),
                Value<UnitType> unitType = const Value.absent(),
                Value<int?> totalUnits = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourcesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                type: type,
                title: title,
                uri: uri,
                unitType: unitType,
                totalUnits: totalUnits,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required SourceType type,
                required String title,
                Value<String?> uri = const Value.absent(),
                required UnitType unitType,
                Value<int?> totalUnits = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourcesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                type: type,
                title: title,
                uri: uri,
                unitType: unitType,
                totalUnits: totalUnits,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceFilesRefs = false, chunksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceFilesRefs) db.sourceFiles,
                    if (chunksRefs) db.chunks,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sourceFilesRefs)
                        await $_getPrefetchedData<
                          Source,
                          $SourcesTable,
                          SourceFile
                        >(
                          currentTable: table,
                          referencedTable: $$SourcesTableReferences
                              ._sourceFilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceFilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (chunksRefs)
                        await $_getPrefetchedData<Source, $SourcesTable, Chunk>(
                          currentTable: table,
                          referencedTable: $$SourcesTableReferences
                              ._chunksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).chunksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourcesTable,
      Source,
      $$SourcesTableFilterComposer,
      $$SourcesTableOrderingComposer,
      $$SourcesTableAnnotationComposer,
      $$SourcesTableCreateCompanionBuilder,
      $$SourcesTableUpdateCompanionBuilder,
      (Source, $$SourcesTableReferences),
      Source,
      PrefetchHooks Function({bool sourceFilesRefs, bool chunksRefs})
    >;
typedef $$SourceFilesTableCreateCompanionBuilder =
    SourceFilesCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String sourceId,
      required String localPath,
      required int bytes,
      required String sha256,
      Value<int> rowid,
    });
typedef $$SourceFilesTableUpdateCompanionBuilder =
    SourceFilesCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> sourceId,
      Value<String> localPath,
      Value<int> bytes,
      Value<String> sha256,
      Value<int> rowid,
    });

final class $$SourceFilesTableReferences
    extends BaseReferences<_$AppDatabase, $SourceFilesTable, SourceFile> {
  $$SourceFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.sources.createAlias(
        $_aliasNameGenerator(db.sourceFiles.sourceId, db.sources.id),
      );

  $$SourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$SourcesTableTableManager(
      $_db,
      $_db.sources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SourceFilesTableFilterComposer
    extends Composer<_$AppDatabase, $SourceFilesTable> {
  $$SourceFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcesTableFilterComposer get sourceId {
    final $$SourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableFilterComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceFilesTable> {
  $$SourceFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcesTableOrderingComposer get sourceId {
    final $$SourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableOrderingComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceFilesTable> {
  $$SourceFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  $$SourcesTableAnnotationComposer get sourceId {
    final $$SourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceFilesTable,
          SourceFile,
          $$SourceFilesTableFilterComposer,
          $$SourceFilesTableOrderingComposer,
          $$SourceFilesTableAnnotationComposer,
          $$SourceFilesTableCreateCompanionBuilder,
          $$SourceFilesTableUpdateCompanionBuilder,
          (SourceFile, $$SourceFilesTableReferences),
          SourceFile,
          PrefetchHooks Function({bool sourceId})
        > {
  $$SourceFilesTableTableManager(_$AppDatabase db, $SourceFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<int> bytes = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceFilesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                sourceId: sourceId,
                localPath: localPath,
                bytes: bytes,
                sha256: sha256,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String sourceId,
                required String localPath,
                required int bytes,
                required String sha256,
                Value<int> rowid = const Value.absent(),
              }) => SourceFilesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                sourceId: sourceId,
                localPath: localPath,
                bytes: bytes,
                sha256: sha256,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SourceFilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable: $$SourceFilesTableReferences
                                    ._sourceIdTable(db),
                                referencedColumn: $$SourceFilesTableReferences
                                    ._sourceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SourceFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceFilesTable,
      SourceFile,
      $$SourceFilesTableFilterComposer,
      $$SourceFilesTableOrderingComposer,
      $$SourceFilesTableAnnotationComposer,
      $$SourceFilesTableCreateCompanionBuilder,
      $$SourceFilesTableUpdateCompanionBuilder,
      (SourceFile, $$SourceFilesTableReferences),
      SourceFile,
      PrefetchHooks Function({bool sourceId})
    >;
typedef $$ChunksTableCreateCompanionBuilder =
    ChunksCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String sourceId,
      Value<String?> parentChunkId,
      required String title,
      required int order,
      Value<int?> startUnit,
      Value<int?> endUnit,
      Value<int?> sizeUnits,
      Value<int> rowid,
    });
typedef $$ChunksTableUpdateCompanionBuilder =
    ChunksCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> sourceId,
      Value<String?> parentChunkId,
      Value<String> title,
      Value<int> order,
      Value<int?> startUnit,
      Value<int?> endUnit,
      Value<int?> sizeUnits,
      Value<int> rowid,
    });

final class $$ChunksTableReferences
    extends BaseReferences<_$AppDatabase, $ChunksTable, Chunk> {
  $$ChunksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SourcesTable _sourceIdTable(_$AppDatabase db) => db.sources
      .createAlias($_aliasNameGenerator(db.chunks.sourceId, db.sources.id));

  $$SourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$SourcesTableTableManager(
      $_db,
      $_db.sources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChunksTable _parentChunkIdTable(_$AppDatabase db) => db.chunks
      .createAlias($_aliasNameGenerator(db.chunks.parentChunkId, db.chunks.id));

  $$ChunksTableProcessedTableManager? get parentChunkId {
    final $_column = $_itemColumn<String>('parent_chunk_id');
    if ($_column == null) return null;
    final manager = $$ChunksTableTableManager(
      $_db,
      $_db.chunks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentChunkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChunkSurveysTable, List<ChunkSurvey>>
  _chunkSurveysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chunkSurveys,
    aliasName: $_aliasNameGenerator(db.chunks.id, db.chunkSurveys.chunkId),
  );

  $$ChunkSurveysTableProcessedTableManager get chunkSurveysRefs {
    final manager = $$ChunkSurveysTableTableManager(
      $_db,
      $_db.chunkSurveys,
    ).filter((f) => f.chunkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chunkSurveysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskChunksTable, List<TaskChunk>>
  _taskChunksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskChunks,
    aliasName: $_aliasNameGenerator(db.chunks.id, db.taskChunks.chunkId),
  );

  $$TaskChunksTableProcessedTableManager get taskChunksRefs {
    final manager = $$TaskChunksTableTableManager(
      $_db,
      $_db.taskChunks,
    ).filter((f) => f.chunkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskChunksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExamChunksTable, List<ExamChunk>>
  _examChunksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examChunks,
    aliasName: $_aliasNameGenerator(db.chunks.id, db.examChunks.chunkId),
  );

  $$ExamChunksTableProcessedTableManager get examChunksRefs {
    final manager = $$ExamChunksTableTableManager(
      $_db,
      $_db.examChunks,
    ).filter((f) => f.chunkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_examChunksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChunksTableFilterComposer
    extends Composer<_$AppDatabase, $ChunksTable> {
  $$ChunksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startUnit => $composableBuilder(
    column: $table.startUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endUnit => $composableBuilder(
    column: $table.endUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeUnits => $composableBuilder(
    column: $table.sizeUnits,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcesTableFilterComposer get sourceId {
    final $$SourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableFilterComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChunksTableFilterComposer get parentChunkId {
    final $$ChunksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentChunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableFilterComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> chunkSurveysRefs(
    Expression<bool> Function($$ChunkSurveysTableFilterComposer f) f,
  ) {
    final $$ChunkSurveysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chunkSurveys,
      getReferencedColumn: (t) => t.chunkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunkSurveysTableFilterComposer(
            $db: $db,
            $table: $db.chunkSurveys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskChunksRefs(
    Expression<bool> Function($$TaskChunksTableFilterComposer f) f,
  ) {
    final $$TaskChunksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskChunks,
      getReferencedColumn: (t) => t.chunkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskChunksTableFilterComposer(
            $db: $db,
            $table: $db.taskChunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> examChunksRefs(
    Expression<bool> Function($$ExamChunksTableFilterComposer f) f,
  ) {
    final $$ExamChunksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examChunks,
      getReferencedColumn: (t) => t.chunkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamChunksTableFilterComposer(
            $db: $db,
            $table: $db.examChunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChunksTableOrderingComposer
    extends Composer<_$AppDatabase, $ChunksTable> {
  $$ChunksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startUnit => $composableBuilder(
    column: $table.startUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endUnit => $composableBuilder(
    column: $table.endUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeUnits => $composableBuilder(
    column: $table.sizeUnits,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcesTableOrderingComposer get sourceId {
    final $$SourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableOrderingComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChunksTableOrderingComposer get parentChunkId {
    final $$ChunksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentChunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableOrderingComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChunksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChunksTable> {
  $$ChunksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<int> get startUnit =>
      $composableBuilder(column: $table.startUnit, builder: (column) => column);

  GeneratedColumn<int> get endUnit =>
      $composableBuilder(column: $table.endUnit, builder: (column) => column);

  GeneratedColumn<int> get sizeUnits =>
      $composableBuilder(column: $table.sizeUnits, builder: (column) => column);

  $$SourcesTableAnnotationComposer get sourceId {
    final $$SourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChunksTableAnnotationComposer get parentChunkId {
    final $$ChunksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentChunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableAnnotationComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> chunkSurveysRefs<T extends Object>(
    Expression<T> Function($$ChunkSurveysTableAnnotationComposer a) f,
  ) {
    final $$ChunkSurveysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chunkSurveys,
      getReferencedColumn: (t) => t.chunkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunkSurveysTableAnnotationComposer(
            $db: $db,
            $table: $db.chunkSurveys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskChunksRefs<T extends Object>(
    Expression<T> Function($$TaskChunksTableAnnotationComposer a) f,
  ) {
    final $$TaskChunksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskChunks,
      getReferencedColumn: (t) => t.chunkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskChunksTableAnnotationComposer(
            $db: $db,
            $table: $db.taskChunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> examChunksRefs<T extends Object>(
    Expression<T> Function($$ExamChunksTableAnnotationComposer a) f,
  ) {
    final $$ExamChunksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examChunks,
      getReferencedColumn: (t) => t.chunkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamChunksTableAnnotationComposer(
            $db: $db,
            $table: $db.examChunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChunksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChunksTable,
          Chunk,
          $$ChunksTableFilterComposer,
          $$ChunksTableOrderingComposer,
          $$ChunksTableAnnotationComposer,
          $$ChunksTableCreateCompanionBuilder,
          $$ChunksTableUpdateCompanionBuilder,
          (Chunk, $$ChunksTableReferences),
          Chunk,
          PrefetchHooks Function({
            bool sourceId,
            bool parentChunkId,
            bool chunkSurveysRefs,
            bool taskChunksRefs,
            bool examChunksRefs,
          })
        > {
  $$ChunksTableTableManager(_$AppDatabase db, $ChunksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChunksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChunksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChunksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String?> parentChunkId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int?> startUnit = const Value.absent(),
                Value<int?> endUnit = const Value.absent(),
                Value<int?> sizeUnits = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChunksCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                sourceId: sourceId,
                parentChunkId: parentChunkId,
                title: title,
                order: order,
                startUnit: startUnit,
                endUnit: endUnit,
                sizeUnits: sizeUnits,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String sourceId,
                Value<String?> parentChunkId = const Value.absent(),
                required String title,
                required int order,
                Value<int?> startUnit = const Value.absent(),
                Value<int?> endUnit = const Value.absent(),
                Value<int?> sizeUnits = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChunksCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                sourceId: sourceId,
                parentChunkId: parentChunkId,
                title: title,
                order: order,
                startUnit: startUnit,
                endUnit: endUnit,
                sizeUnits: sizeUnits,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ChunksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sourceId = false,
                parentChunkId = false,
                chunkSurveysRefs = false,
                taskChunksRefs = false,
                examChunksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chunkSurveysRefs) db.chunkSurveys,
                    if (taskChunksRefs) db.taskChunks,
                    if (examChunksRefs) db.examChunks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceId,
                                    referencedTable: $$ChunksTableReferences
                                        ._sourceIdTable(db),
                                    referencedColumn: $$ChunksTableReferences
                                        ._sourceIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (parentChunkId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentChunkId,
                                    referencedTable: $$ChunksTableReferences
                                        ._parentChunkIdTable(db),
                                    referencedColumn: $$ChunksTableReferences
                                        ._parentChunkIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chunkSurveysRefs)
                        await $_getPrefetchedData<
                          Chunk,
                          $ChunksTable,
                          ChunkSurvey
                        >(
                          currentTable: table,
                          referencedTable: $$ChunksTableReferences
                              ._chunkSurveysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChunksTableReferences(
                                db,
                                table,
                                p0,
                              ).chunkSurveysRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chunkId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskChunksRefs)
                        await $_getPrefetchedData<
                          Chunk,
                          $ChunksTable,
                          TaskChunk
                        >(
                          currentTable: table,
                          referencedTable: $$ChunksTableReferences
                              ._taskChunksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChunksTableReferences(
                                db,
                                table,
                                p0,
                              ).taskChunksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chunkId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (examChunksRefs)
                        await $_getPrefetchedData<
                          Chunk,
                          $ChunksTable,
                          ExamChunk
                        >(
                          currentTable: table,
                          referencedTable: $$ChunksTableReferences
                              ._examChunksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChunksTableReferences(
                                db,
                                table,
                                p0,
                              ).examChunksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chunkId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChunksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChunksTable,
      Chunk,
      $$ChunksTableFilterComposer,
      $$ChunksTableOrderingComposer,
      $$ChunksTableAnnotationComposer,
      $$ChunksTableCreateCompanionBuilder,
      $$ChunksTableUpdateCompanionBuilder,
      (Chunk, $$ChunksTableReferences),
      Chunk,
      PrefetchHooks Function({
        bool sourceId,
        bool parentChunkId,
        bool chunkSurveysRefs,
        bool taskChunksRefs,
        bool examChunksRefs,
      })
    >;
typedef $$ChunkSurveysTableCreateCompanionBuilder =
    ChunkSurveysCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String chunkId,
      required int difficulty,
      required int familiarity,
      required int surveyedAt,
      Value<int> rowid,
    });
typedef $$ChunkSurveysTableUpdateCompanionBuilder =
    ChunkSurveysCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> chunkId,
      Value<int> difficulty,
      Value<int> familiarity,
      Value<int> surveyedAt,
      Value<int> rowid,
    });

final class $$ChunkSurveysTableReferences
    extends BaseReferences<_$AppDatabase, $ChunkSurveysTable, ChunkSurvey> {
  $$ChunkSurveysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChunksTable _chunkIdTable(_$AppDatabase db) => db.chunks.createAlias(
    $_aliasNameGenerator(db.chunkSurveys.chunkId, db.chunks.id),
  );

  $$ChunksTableProcessedTableManager get chunkId {
    final $_column = $_itemColumn<String>('chunk_id')!;

    final manager = $$ChunksTableTableManager(
      $_db,
      $_db.chunks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chunkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChunkSurveysTableFilterComposer
    extends Composer<_$AppDatabase, $ChunkSurveysTable> {
  $$ChunkSurveysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get familiarity => $composableBuilder(
    column: $table.familiarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surveyedAt => $composableBuilder(
    column: $table.surveyedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChunksTableFilterComposer get chunkId {
    final $$ChunksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableFilterComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChunkSurveysTableOrderingComposer
    extends Composer<_$AppDatabase, $ChunkSurveysTable> {
  $$ChunkSurveysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get familiarity => $composableBuilder(
    column: $table.familiarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surveyedAt => $composableBuilder(
    column: $table.surveyedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChunksTableOrderingComposer get chunkId {
    final $$ChunksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableOrderingComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChunkSurveysTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChunkSurveysTable> {
  $$ChunkSurveysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get familiarity => $composableBuilder(
    column: $table.familiarity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get surveyedAt => $composableBuilder(
    column: $table.surveyedAt,
    builder: (column) => column,
  );

  $$ChunksTableAnnotationComposer get chunkId {
    final $$ChunksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableAnnotationComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChunkSurveysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChunkSurveysTable,
          ChunkSurvey,
          $$ChunkSurveysTableFilterComposer,
          $$ChunkSurveysTableOrderingComposer,
          $$ChunkSurveysTableAnnotationComposer,
          $$ChunkSurveysTableCreateCompanionBuilder,
          $$ChunkSurveysTableUpdateCompanionBuilder,
          (ChunkSurvey, $$ChunkSurveysTableReferences),
          ChunkSurvey,
          PrefetchHooks Function({bool chunkId})
        > {
  $$ChunkSurveysTableTableManager(_$AppDatabase db, $ChunkSurveysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChunkSurveysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChunkSurveysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChunkSurveysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> chunkId = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<int> familiarity = const Value.absent(),
                Value<int> surveyedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChunkSurveysCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                chunkId: chunkId,
                difficulty: difficulty,
                familiarity: familiarity,
                surveyedAt: surveyedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String chunkId,
                required int difficulty,
                required int familiarity,
                required int surveyedAt,
                Value<int> rowid = const Value.absent(),
              }) => ChunkSurveysCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                chunkId: chunkId,
                difficulty: difficulty,
                familiarity: familiarity,
                surveyedAt: surveyedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChunkSurveysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chunkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chunkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chunkId,
                                referencedTable: $$ChunkSurveysTableReferences
                                    ._chunkIdTable(db),
                                referencedColumn: $$ChunkSurveysTableReferences
                                    ._chunkIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChunkSurveysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChunkSurveysTable,
      ChunkSurvey,
      $$ChunkSurveysTableFilterComposer,
      $$ChunkSurveysTableOrderingComposer,
      $$ChunkSurveysTableAnnotationComposer,
      $$ChunkSurveysTableCreateCompanionBuilder,
      $$ChunkSurveysTableUpdateCompanionBuilder,
      (ChunkSurvey, $$ChunkSurveysTableReferences),
      ChunkSurvey,
      PrefetchHooks Function({bool chunkId})
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      Value<String?> topicId,
      required String title,
      required TaskKind kind,
      required TaskStatus status,
      Value<bool> needsDetail,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String?> topicId,
      Value<String> title,
      Value<TaskKind> kind,
      Value<TaskStatus> status,
      Value<bool> needsDetail,
      Value<int> rowid,
    });

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TopicsTable _topicIdTable(_$AppDatabase db) => db.topics.createAlias(
    $_aliasNameGenerator(db.tasks.topicId, db.topics.id),
  );

  $$TopicsTableProcessedTableManager? get topicId {
    final $_column = $_itemColumn<String>('topic_id');
    if ($_column == null) return null;
    final manager = $$TopicsTableTableManager(
      $_db,
      $_db.topics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_topicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TaskChunksTable, List<TaskChunk>>
  _taskChunksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskChunks,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.taskChunks.taskId),
  );

  $$TaskChunksTableProcessedTableManager get taskChunksRefs {
    final manager = $$TaskChunksTableTableManager(
      $_db,
      $_db.taskChunks,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskChunksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskStatesTable, List<TaskState>>
  _taskStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskStates,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.taskStates.taskId),
  );

  $$TaskStatesTableProcessedTableManager get taskStatesRefs {
    final manager = $$TaskStatesTableTableManager(
      $_db,
      $_db.taskStates,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewsTable, List<Review>> _reviewsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.reviews,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.reviews.taskId),
  );

  $$ReviewsTableProcessedTableManager get reviewsRefs {
    final manager = $$ReviewsTableTableManager(
      $_db,
      $_db.reviews,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskLineagesTable, List<TaskLineage>>
  _childLineagesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskLineages,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.taskLineages.childTaskId),
  );

  $$TaskLineagesTableProcessedTableManager get childLineages {
    final manager = $$TaskLineagesTableTableManager(
      $_db,
      $_db.taskLineages,
    ).filter((f) => f.childTaskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_childLineagesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskLineagesTable, List<TaskLineage>>
  _parentLineagesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskLineages,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.taskLineages.parentTaskId),
  );

  $$TaskLineagesTableProcessedTableManager get parentLineages {
    final manager = $$TaskLineagesTableTableManager(
      $_db,
      $_db.taskLineages,
    ).filter((f) => f.parentTaskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_parentLineagesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CardsTable, List<StudyCard>> _cardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cards,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.cards.taskId),
  );

  $$CardsTableProcessedTableManager get cardsRefs {
    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExamTasksTable, List<ExamTask>>
  _examTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examTasks,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.examTasks.taskId),
  );

  $$ExamTasksTableProcessedTableManager get examTasksRefs {
    final manager = $$ExamTasksTableTableManager(
      $_db,
      $_db.examTasks,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_examTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlanItemsTable, List<PlanItem>>
  _planItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planItems,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.planItems.taskId),
  );

  $$PlanItemsTableProcessedTableManager get planItemsRefs {
    final manager = $$PlanItemsTableTableManager(
      $_db,
      $_db.planItems,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ActiveSessionsTable, List<ActiveSession>>
  _activeSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activeSessions,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.activeSessions.taskId),
  );

  $$ActiveSessionsTableProcessedTableManager get activeSessionsRefs {
    final manager = $$ActiveSessionsTableTableManager(
      $_db,
      $_db.activeSessions,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_activeSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskKind, TaskKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get needsDetail => $composableBuilder(
    column: $table.needsDetail,
    builder: (column) => ColumnFilters(column),
  );

  $$TopicsTableFilterComposer get topicId {
    final $$TopicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableFilterComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskChunksRefs(
    Expression<bool> Function($$TaskChunksTableFilterComposer f) f,
  ) {
    final $$TaskChunksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskChunks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskChunksTableFilterComposer(
            $db: $db,
            $table: $db.taskChunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskStatesRefs(
    Expression<bool> Function($$TaskStatesTableFilterComposer f) f,
  ) {
    final $$TaskStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskStates,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskStatesTableFilterComposer(
            $db: $db,
            $table: $db.taskStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewsRefs(
    Expression<bool> Function($$ReviewsTableFilterComposer f) f,
  ) {
    final $$ReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableFilterComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> childLineages(
    Expression<bool> Function($$TaskLineagesTableFilterComposer f) f,
  ) {
    final $$TaskLineagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskLineages,
      getReferencedColumn: (t) => t.childTaskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskLineagesTableFilterComposer(
            $db: $db,
            $table: $db.taskLineages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> parentLineages(
    Expression<bool> Function($$TaskLineagesTableFilterComposer f) f,
  ) {
    final $$TaskLineagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskLineages,
      getReferencedColumn: (t) => t.parentTaskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskLineagesTableFilterComposer(
            $db: $db,
            $table: $db.taskLineages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cardsRefs(
    Expression<bool> Function($$CardsTableFilterComposer f) f,
  ) {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> examTasksRefs(
    Expression<bool> Function($$ExamTasksTableFilterComposer f) f,
  ) {
    final $$ExamTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examTasks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamTasksTableFilterComposer(
            $db: $db,
            $table: $db.examTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> planItemsRefs(
    Expression<bool> Function($$PlanItemsTableFilterComposer f) f,
  ) {
    final $$PlanItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableFilterComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activeSessionsRefs(
    Expression<bool> Function($$ActiveSessionsTableFilterComposer f) f,
  ) {
    final $$ActiveSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activeSessions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActiveSessionsTableFilterComposer(
            $db: $db,
            $table: $db.activeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsDetail => $composableBuilder(
    column: $table.needsDetail,
    builder: (column) => ColumnOrderings(column),
  );

  $$TopicsTableOrderingComposer get topicId {
    final $$TopicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableOrderingComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get needsDetail => $composableBuilder(
    column: $table.needsDetail,
    builder: (column) => column,
  );

  $$TopicsTableAnnotationComposer get topicId {
    final $$TopicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableAnnotationComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskChunksRefs<T extends Object>(
    Expression<T> Function($$TaskChunksTableAnnotationComposer a) f,
  ) {
    final $$TaskChunksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskChunks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskChunksTableAnnotationComposer(
            $db: $db,
            $table: $db.taskChunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskStatesRefs<T extends Object>(
    Expression<T> Function($$TaskStatesTableAnnotationComposer a) f,
  ) {
    final $$TaskStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskStates,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reviewsRefs<T extends Object>(
    Expression<T> Function($$ReviewsTableAnnotationComposer a) f,
  ) {
    final $$ReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> childLineages<T extends Object>(
    Expression<T> Function($$TaskLineagesTableAnnotationComposer a) f,
  ) {
    final $$TaskLineagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskLineages,
      getReferencedColumn: (t) => t.childTaskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskLineagesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskLineages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> parentLineages<T extends Object>(
    Expression<T> Function($$TaskLineagesTableAnnotationComposer a) f,
  ) {
    final $$TaskLineagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskLineages,
      getReferencedColumn: (t) => t.parentTaskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskLineagesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskLineages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cardsRefs<T extends Object>(
    Expression<T> Function($$CardsTableAnnotationComposer a) f,
  ) {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> examTasksRefs<T extends Object>(
    Expression<T> Function($$ExamTasksTableAnnotationComposer a) f,
  ) {
    final $$ExamTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examTasks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.examTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> planItemsRefs<T extends Object>(
    Expression<T> Function($$PlanItemsTableAnnotationComposer a) f,
  ) {
    final $$PlanItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> activeSessionsRefs<T extends Object>(
    Expression<T> Function($$ActiveSessionsTableAnnotationComposer a) f,
  ) {
    final $$ActiveSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activeSessions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActiveSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.activeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({
            bool topicId,
            bool taskChunksRefs,
            bool taskStatesRefs,
            bool reviewsRefs,
            bool childLineages,
            bool parentLineages,
            bool cardsRefs,
            bool examTasksRefs,
            bool planItemsRefs,
            bool activeSessionsRefs,
          })
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String?> topicId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<TaskKind> kind = const Value.absent(),
                Value<TaskStatus> status = const Value.absent(),
                Value<bool> needsDetail = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                topicId: topicId,
                title: title,
                kind: kind,
                status: status,
                needsDetail: needsDetail,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                Value<String?> topicId = const Value.absent(),
                required String title,
                required TaskKind kind,
                required TaskStatus status,
                Value<bool> needsDetail = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                topicId: topicId,
                title: title,
                kind: kind,
                status: status,
                needsDetail: needsDetail,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TasksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                topicId = false,
                taskChunksRefs = false,
                taskStatesRefs = false,
                reviewsRefs = false,
                childLineages = false,
                parentLineages = false,
                cardsRefs = false,
                examTasksRefs = false,
                planItemsRefs = false,
                activeSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskChunksRefs) db.taskChunks,
                    if (taskStatesRefs) db.taskStates,
                    if (reviewsRefs) db.reviews,
                    if (childLineages) db.taskLineages,
                    if (parentLineages) db.taskLineages,
                    if (cardsRefs) db.cards,
                    if (examTasksRefs) db.examTasks,
                    if (planItemsRefs) db.planItems,
                    if (activeSessionsRefs) db.activeSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (topicId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.topicId,
                                    referencedTable: $$TasksTableReferences
                                        ._topicIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._topicIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskChunksRefs)
                        await $_getPrefetchedData<Task, $TasksTable, TaskChunk>(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._taskChunksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).taskChunksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskStatesRefs)
                        await $_getPrefetchedData<Task, $TasksTable, TaskState>(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._taskStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).taskStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reviewsRefs)
                        await $_getPrefetchedData<Task, $TasksTable, Review>(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._reviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(db, table, p0).reviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (childLineages)
                        await $_getPrefetchedData<
                          Task,
                          $TasksTable,
                          TaskLineage
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._childLineagesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).childLineages,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childTaskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (parentLineages)
                        await $_getPrefetchedData<
                          Task,
                          $TasksTable,
                          TaskLineage
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._parentLineagesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).parentLineages,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.parentTaskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cardsRefs)
                        await $_getPrefetchedData<Task, $TasksTable, StudyCard>(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._cardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(db, table, p0).cardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (examTasksRefs)
                        await $_getPrefetchedData<Task, $TasksTable, ExamTask>(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._examTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).examTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (planItemsRefs)
                        await $_getPrefetchedData<Task, $TasksTable, PlanItem>(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._planItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).planItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activeSessionsRefs)
                        await $_getPrefetchedData<
                          Task,
                          $TasksTable,
                          ActiveSession
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._activeSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).activeSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({
        bool topicId,
        bool taskChunksRefs,
        bool taskStatesRefs,
        bool reviewsRefs,
        bool childLineages,
        bool parentLineages,
        bool cardsRefs,
        bool examTasksRefs,
        bool planItemsRefs,
        bool activeSessionsRefs,
      })
    >;
typedef $$TaskChunksTableCreateCompanionBuilder =
    TaskChunksCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String taskId,
      required String chunkId,
      Value<int?> startUnit,
      Value<int?> endUnit,
      required int order,
      Value<int> rowid,
    });
typedef $$TaskChunksTableUpdateCompanionBuilder =
    TaskChunksCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> taskId,
      Value<String> chunkId,
      Value<int?> startUnit,
      Value<int?> endUnit,
      Value<int> order,
      Value<int> rowid,
    });

final class $$TaskChunksTableReferences
    extends BaseReferences<_$AppDatabase, $TaskChunksTable, TaskChunk> {
  $$TaskChunksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.taskChunks.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChunksTable _chunkIdTable(_$AppDatabase db) => db.chunks.createAlias(
    $_aliasNameGenerator(db.taskChunks.chunkId, db.chunks.id),
  );

  $$ChunksTableProcessedTableManager get chunkId {
    final $_column = $_itemColumn<String>('chunk_id')!;

    final manager = $$ChunksTableTableManager(
      $_db,
      $_db.chunks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chunkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskChunksTableFilterComposer
    extends Composer<_$AppDatabase, $TaskChunksTable> {
  $$TaskChunksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startUnit => $composableBuilder(
    column: $table.startUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endUnit => $composableBuilder(
    column: $table.endUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChunksTableFilterComposer get chunkId {
    final $$ChunksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableFilterComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskChunksTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskChunksTable> {
  $$TaskChunksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startUnit => $composableBuilder(
    column: $table.startUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endUnit => $composableBuilder(
    column: $table.endUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChunksTableOrderingComposer get chunkId {
    final $$ChunksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableOrderingComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskChunksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskChunksTable> {
  $$TaskChunksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get startUnit =>
      $composableBuilder(column: $table.startUnit, builder: (column) => column);

  GeneratedColumn<int> get endUnit =>
      $composableBuilder(column: $table.endUnit, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChunksTableAnnotationComposer get chunkId {
    final $$ChunksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableAnnotationComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskChunksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskChunksTable,
          TaskChunk,
          $$TaskChunksTableFilterComposer,
          $$TaskChunksTableOrderingComposer,
          $$TaskChunksTableAnnotationComposer,
          $$TaskChunksTableCreateCompanionBuilder,
          $$TaskChunksTableUpdateCompanionBuilder,
          (TaskChunk, $$TaskChunksTableReferences),
          TaskChunk,
          PrefetchHooks Function({bool taskId, bool chunkId})
        > {
  $$TaskChunksTableTableManager(_$AppDatabase db, $TaskChunksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskChunksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskChunksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskChunksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> chunkId = const Value.absent(),
                Value<int?> startUnit = const Value.absent(),
                Value<int?> endUnit = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskChunksCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                taskId: taskId,
                chunkId: chunkId,
                startUnit: startUnit,
                endUnit: endUnit,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String taskId,
                required String chunkId,
                Value<int?> startUnit = const Value.absent(),
                Value<int?> endUnit = const Value.absent(),
                required int order,
                Value<int> rowid = const Value.absent(),
              }) => TaskChunksCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                taskId: taskId,
                chunkId: chunkId,
                startUnit: startUnit,
                endUnit: endUnit,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskChunksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false, chunkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$TaskChunksTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$TaskChunksTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (chunkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chunkId,
                                referencedTable: $$TaskChunksTableReferences
                                    ._chunkIdTable(db),
                                referencedColumn: $$TaskChunksTableReferences
                                    ._chunkIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskChunksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskChunksTable,
      TaskChunk,
      $$TaskChunksTableFilterComposer,
      $$TaskChunksTableOrderingComposer,
      $$TaskChunksTableAnnotationComposer,
      $$TaskChunksTableCreateCompanionBuilder,
      $$TaskChunksTableUpdateCompanionBuilder,
      (TaskChunk, $$TaskChunksTableReferences),
      TaskChunk,
      PrefetchHooks Function({bool taskId, bool chunkId})
    >;
typedef $$TaskStatesTableCreateCompanionBuilder =
    TaskStatesCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String taskId,
      required int level,
      Value<int> step,
      Value<int> dim,
      Value<int?> lastReviewAt,
      Value<int?> dueAt,
      Value<int> reps,
      Value<int> lapses,
      Value<int?> pausedAt,
      Value<int> rowid,
    });
typedef $$TaskStatesTableUpdateCompanionBuilder =
    TaskStatesCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> taskId,
      Value<int> level,
      Value<int> step,
      Value<int> dim,
      Value<int?> lastReviewAt,
      Value<int?> dueAt,
      Value<int> reps,
      Value<int> lapses,
      Value<int?> pausedAt,
      Value<int> rowid,
    });

final class $$TaskStatesTableReferences
    extends BaseReferences<_$AppDatabase, $TaskStatesTable, TaskState> {
  $$TaskStatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.taskStates.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskStatesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskStatesTable> {
  $$TaskStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dim => $composableBuilder(
    column: $table.dim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReviewAt => $composableBuilder(
    column: $table.lastReviewAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pausedAt => $composableBuilder(
    column: $table.pausedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskStatesTable> {
  $$TaskStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dim => $composableBuilder(
    column: $table.dim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReviewAt => $composableBuilder(
    column: $table.lastReviewAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pausedAt => $composableBuilder(
    column: $table.pausedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskStatesTable> {
  $$TaskStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<int> get dim =>
      $composableBuilder(column: $table.dim, builder: (column) => column);

  GeneratedColumn<int> get lastReviewAt => $composableBuilder(
    column: $table.lastReviewAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<int> get pausedAt =>
      $composableBuilder(column: $table.pausedAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskStatesTable,
          TaskState,
          $$TaskStatesTableFilterComposer,
          $$TaskStatesTableOrderingComposer,
          $$TaskStatesTableAnnotationComposer,
          $$TaskStatesTableCreateCompanionBuilder,
          $$TaskStatesTableUpdateCompanionBuilder,
          (TaskState, $$TaskStatesTableReferences),
          TaskState,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskStatesTableTableManager(_$AppDatabase db, $TaskStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<int> dim = const Value.absent(),
                Value<int?> lastReviewAt = const Value.absent(),
                Value<int?> dueAt = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int?> pausedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskStatesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                taskId: taskId,
                level: level,
                step: step,
                dim: dim,
                lastReviewAt: lastReviewAt,
                dueAt: dueAt,
                reps: reps,
                lapses: lapses,
                pausedAt: pausedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String taskId,
                required int level,
                Value<int> step = const Value.absent(),
                Value<int> dim = const Value.absent(),
                Value<int?> lastReviewAt = const Value.absent(),
                Value<int?> dueAt = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int?> pausedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskStatesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                taskId: taskId,
                level: level,
                step: step,
                dim: dim,
                lastReviewAt: lastReviewAt,
                dueAt: dueAt,
                reps: reps,
                lapses: lapses,
                pausedAt: pausedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$TaskStatesTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$TaskStatesTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskStatesTable,
      TaskState,
      $$TaskStatesTableFilterComposer,
      $$TaskStatesTableOrderingComposer,
      $$TaskStatesTableAnnotationComposer,
      $$TaskStatesTableCreateCompanionBuilder,
      $$TaskStatesTableUpdateCompanionBuilder,
      (TaskState, $$TaskStatesTableReferences),
      TaskState,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$ReviewsTableCreateCompanionBuilder =
    ReviewsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String taskId,
      required int at,
      required ReviewKind kind,
      required int rating,
      required int durationSec,
      Value<int?> resumeUnit,
      required int levelBefore,
      required int levelAfter,
      required int stepAfter,
      Value<int?> dueAfter,
      Value<int> rowid,
    });
typedef $$ReviewsTableUpdateCompanionBuilder =
    ReviewsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> taskId,
      Value<int> at,
      Value<ReviewKind> kind,
      Value<int> rating,
      Value<int> durationSec,
      Value<int?> resumeUnit,
      Value<int> levelBefore,
      Value<int> levelAfter,
      Value<int> stepAfter,
      Value<int?> dueAfter,
      Value<int> rowid,
    });

final class $$ReviewsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewsTable, Review> {
  $$ReviewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.reviews.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CardResultsTable, List<CardResult>>
  _cardResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardResults,
    aliasName: $_aliasNameGenerator(db.reviews.id, db.cardResults.reviewId),
  );

  $$CardResultsTableProcessedTableManager get cardResultsRefs {
    final manager = $$CardResultsTableTableManager(
      $_db,
      $_db.cardResults,
    ).filter((f) => f.reviewId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReviewKind, ReviewKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get resumeUnit => $composableBuilder(
    column: $table.resumeUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelBefore => $composableBuilder(
    column: $table.levelBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelAfter => $composableBuilder(
    column: $table.levelAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stepAfter => $composableBuilder(
    column: $table.stepAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueAfter => $composableBuilder(
    column: $table.dueAfter,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cardResultsRefs(
    Expression<bool> Function($$CardResultsTableFilterComposer f) f,
  ) {
    final $$CardResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardResults,
      getReferencedColumn: (t) => t.reviewId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardResultsTableFilterComposer(
            $db: $db,
            $table: $db.cardResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resumeUnit => $composableBuilder(
    column: $table.resumeUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelBefore => $composableBuilder(
    column: $table.levelBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelAfter => $composableBuilder(
    column: $table.levelAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stepAfter => $composableBuilder(
    column: $table.stepAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueAfter => $composableBuilder(
    column: $table.dueAfter,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReviewKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get resumeUnit => $composableBuilder(
    column: $table.resumeUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get levelBefore => $composableBuilder(
    column: $table.levelBefore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get levelAfter => $composableBuilder(
    column: $table.levelAfter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stepAfter =>
      $composableBuilder(column: $table.stepAfter, builder: (column) => column);

  GeneratedColumn<int> get dueAfter =>
      $composableBuilder(column: $table.dueAfter, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cardResultsRefs<T extends Object>(
    Expression<T> Function($$CardResultsTableAnnotationComposer a) f,
  ) {
    final $$CardResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardResults,
      getReferencedColumn: (t) => t.reviewId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewsTable,
          Review,
          $$ReviewsTableFilterComposer,
          $$ReviewsTableOrderingComposer,
          $$ReviewsTableAnnotationComposer,
          $$ReviewsTableCreateCompanionBuilder,
          $$ReviewsTableUpdateCompanionBuilder,
          (Review, $$ReviewsTableReferences),
          Review,
          PrefetchHooks Function({bool taskId, bool cardResultsRefs})
        > {
  $$ReviewsTableTableManager(_$AppDatabase db, $ReviewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<int> at = const Value.absent(),
                Value<ReviewKind> kind = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<int> durationSec = const Value.absent(),
                Value<int?> resumeUnit = const Value.absent(),
                Value<int> levelBefore = const Value.absent(),
                Value<int> levelAfter = const Value.absent(),
                Value<int> stepAfter = const Value.absent(),
                Value<int?> dueAfter = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                taskId: taskId,
                at: at,
                kind: kind,
                rating: rating,
                durationSec: durationSec,
                resumeUnit: resumeUnit,
                levelBefore: levelBefore,
                levelAfter: levelAfter,
                stepAfter: stepAfter,
                dueAfter: dueAfter,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String taskId,
                required int at,
                required ReviewKind kind,
                required int rating,
                required int durationSec,
                Value<int?> resumeUnit = const Value.absent(),
                required int levelBefore,
                required int levelAfter,
                required int stepAfter,
                Value<int?> dueAfter = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                taskId: taskId,
                at: at,
                kind: kind,
                rating: rating,
                durationSec: durationSec,
                resumeUnit: resumeUnit,
                levelBefore: levelBefore,
                levelAfter: levelAfter,
                stepAfter: stepAfter,
                dueAfter: dueAfter,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReviewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false, cardResultsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cardResultsRefs) db.cardResults],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$ReviewsTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$ReviewsTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cardResultsRefs)
                    await $_getPrefetchedData<
                      Review,
                      $ReviewsTable,
                      CardResult
                    >(
                      currentTable: table,
                      referencedTable: $$ReviewsTableReferences
                          ._cardResultsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ReviewsTableReferences(
                        db,
                        table,
                        p0,
                      ).cardResultsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.reviewId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewsTable,
      Review,
      $$ReviewsTableFilterComposer,
      $$ReviewsTableOrderingComposer,
      $$ReviewsTableAnnotationComposer,
      $$ReviewsTableCreateCompanionBuilder,
      $$ReviewsTableUpdateCompanionBuilder,
      (Review, $$ReviewsTableReferences),
      Review,
      PrefetchHooks Function({bool taskId, bool cardResultsRefs})
    >;
typedef $$TaskLineagesTableCreateCompanionBuilder =
    TaskLineagesCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String childTaskId,
      required String parentTaskId,
      required LineageOp op,
      required int at,
      Value<int> rowid,
    });
typedef $$TaskLineagesTableUpdateCompanionBuilder =
    TaskLineagesCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> childTaskId,
      Value<String> parentTaskId,
      Value<LineageOp> op,
      Value<int> at,
      Value<int> rowid,
    });

final class $$TaskLineagesTableReferences
    extends BaseReferences<_$AppDatabase, $TaskLineagesTable, TaskLineage> {
  $$TaskLineagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _childTaskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias(
        $_aliasNameGenerator(db.taskLineages.childTaskId, db.tasks.id),
      );

  $$TasksTableProcessedTableManager get childTaskId {
    final $_column = $_itemColumn<String>('child_task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childTaskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TasksTable _parentTaskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias(
        $_aliasNameGenerator(db.taskLineages.parentTaskId, db.tasks.id),
      );

  $$TasksTableProcessedTableManager get parentTaskId {
    final $_column = $_itemColumn<String>('parent_task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentTaskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskLineagesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskLineagesTable> {
  $$TaskLineagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LineageOp, LineageOp, String> get op =>
      $composableBuilder(
        column: $table.op,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get childTaskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childTaskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableFilterComposer get parentTaskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentTaskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskLineagesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskLineagesTable> {
  $$TaskLineagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get childTaskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childTaskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableOrderingComposer get parentTaskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentTaskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskLineagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskLineagesTable> {
  $$TaskLineagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LineageOp, String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<int> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  $$TasksTableAnnotationComposer get childTaskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childTaskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableAnnotationComposer get parentTaskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentTaskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskLineagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskLineagesTable,
          TaskLineage,
          $$TaskLineagesTableFilterComposer,
          $$TaskLineagesTableOrderingComposer,
          $$TaskLineagesTableAnnotationComposer,
          $$TaskLineagesTableCreateCompanionBuilder,
          $$TaskLineagesTableUpdateCompanionBuilder,
          (TaskLineage, $$TaskLineagesTableReferences),
          TaskLineage,
          PrefetchHooks Function({bool childTaskId, bool parentTaskId})
        > {
  $$TaskLineagesTableTableManager(_$AppDatabase db, $TaskLineagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskLineagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskLineagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskLineagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> childTaskId = const Value.absent(),
                Value<String> parentTaskId = const Value.absent(),
                Value<LineageOp> op = const Value.absent(),
                Value<int> at = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskLineagesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                childTaskId: childTaskId,
                parentTaskId: parentTaskId,
                op: op,
                at: at,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String childTaskId,
                required String parentTaskId,
                required LineageOp op,
                required int at,
                Value<int> rowid = const Value.absent(),
              }) => TaskLineagesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                childTaskId: childTaskId,
                parentTaskId: parentTaskId,
                op: op,
                at: at,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskLineagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({childTaskId = false, parentTaskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (childTaskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childTaskId,
                                referencedTable: $$TaskLineagesTableReferences
                                    ._childTaskIdTable(db),
                                referencedColumn: $$TaskLineagesTableReferences
                                    ._childTaskIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (parentTaskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.parentTaskId,
                                referencedTable: $$TaskLineagesTableReferences
                                    ._parentTaskIdTable(db),
                                referencedColumn: $$TaskLineagesTableReferences
                                    ._parentTaskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskLineagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskLineagesTable,
      TaskLineage,
      $$TaskLineagesTableFilterComposer,
      $$TaskLineagesTableOrderingComposer,
      $$TaskLineagesTableAnnotationComposer,
      $$TaskLineagesTableCreateCompanionBuilder,
      $$TaskLineagesTableUpdateCompanionBuilder,
      (TaskLineage, $$TaskLineagesTableReferences),
      TaskLineage,
      PrefetchHooks Function({bool childTaskId, bool parentTaskId})
    >;
typedef $$CardsTableCreateCompanionBuilder =
    CardsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String taskId,
      required CardType type,
      required String front,
      required String back,
      Value<String?> options,
      required int order,
      Value<int> rowid,
    });
typedef $$CardsTableUpdateCompanionBuilder =
    CardsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> taskId,
      Value<CardType> type,
      Value<String> front,
      Value<String> back,
      Value<String?> options,
      Value<int> order,
      Value<int> rowid,
    });

final class $$CardsTableReferences
    extends BaseReferences<_$AppDatabase, $CardsTable, StudyCard> {
  $$CardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias($_aliasNameGenerator(db.cards.taskId, db.tasks.id));

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CardResultsTable, List<CardResult>>
  _cardResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardResults,
    aliasName: $_aliasNameGenerator(db.cards.id, db.cardResults.cardId),
  );

  $$CardResultsTableProcessedTableManager get cardResultsRefs {
    final manager = $$CardResultsTableTableManager(
      $_db,
      $_db.cardResults,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CardType, CardType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cardResultsRefs(
    Expression<bool> Function($$CardResultsTableFilterComposer f) f,
  ) {
    final $$CardResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardResults,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardResultsTableFilterComposer(
            $db: $db,
            $table: $db.cardResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CardType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get front =>
      $composableBuilder(column: $table.front, builder: (column) => column);

  GeneratedColumn<String> get back =>
      $composableBuilder(column: $table.back, builder: (column) => column);

  GeneratedColumn<String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cardResultsRefs<T extends Object>(
    Expression<T> Function($$CardResultsTableAnnotationComposer a) f,
  ) {
    final $$CardResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardResults,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTable,
          StudyCard,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (StudyCard, $$CardsTableReferences),
          StudyCard,
          PrefetchHooks Function({bool taskId, bool cardResultsRefs})
        > {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<CardType> type = const Value.absent(),
                Value<String> front = const Value.absent(),
                Value<String> back = const Value.absent(),
                Value<String?> options = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                taskId: taskId,
                type: type,
                front: front,
                back: back,
                options: options,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String taskId,
                required CardType type,
                required String front,
                required String back,
                Value<String?> options = const Value.absent(),
                required int order,
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                taskId: taskId,
                type: type,
                front: front,
                back: back,
                options: options,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CardsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false, cardResultsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cardResultsRefs) db.cardResults],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$CardsTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$CardsTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cardResultsRefs)
                    await $_getPrefetchedData<
                      StudyCard,
                      $CardsTable,
                      CardResult
                    >(
                      currentTable: table,
                      referencedTable: $$CardsTableReferences
                          ._cardResultsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CardsTableReferences(db, table, p0).cardResultsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cardId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTable,
      StudyCard,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (StudyCard, $$CardsTableReferences),
      StudyCard,
      PrefetchHooks Function({bool taskId, bool cardResultsRefs})
    >;
typedef $$CardResultsTableCreateCompanionBuilder =
    CardResultsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String cardId,
      required String reviewId,
      required bool correct,
      required int answerMs,
      Value<int> rowid,
    });
typedef $$CardResultsTableUpdateCompanionBuilder =
    CardResultsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> cardId,
      Value<String> reviewId,
      Value<bool> correct,
      Value<int> answerMs,
      Value<int> rowid,
    });

final class $$CardResultsTableReferences
    extends BaseReferences<_$AppDatabase, $CardResultsTable, CardResult> {
  $$CardResultsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) => db.cards.createAlias(
    $_aliasNameGenerator(db.cardResults.cardId, db.cards.id),
  );

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<String>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReviewsTable _reviewIdTable(_$AppDatabase db) =>
      db.reviews.createAlias(
        $_aliasNameGenerator(db.cardResults.reviewId, db.reviews.id),
      );

  $$ReviewsTableProcessedTableManager get reviewId {
    final $_column = $_itemColumn<String>('review_id')!;

    final manager = $$ReviewsTableTableManager(
      $_db,
      $_db.reviews,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reviewIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardResultsTableFilterComposer
    extends Composer<_$AppDatabase, $CardResultsTable> {
  $$CardResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answerMs => $composableBuilder(
    column: $table.answerMs,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReviewsTableFilterComposer get reviewId {
    final $$ReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reviewId,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableFilterComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardResultsTable> {
  $$CardResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answerMs => $composableBuilder(
    column: $table.answerMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReviewsTableOrderingComposer get reviewId {
    final $$ReviewsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reviewId,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableOrderingComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardResultsTable> {
  $$CardResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get answerMs =>
      $composableBuilder(column: $table.answerMs, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReviewsTableAnnotationComposer get reviewId {
    final $$ReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reviewId,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardResultsTable,
          CardResult,
          $$CardResultsTableFilterComposer,
          $$CardResultsTableOrderingComposer,
          $$CardResultsTableAnnotationComposer,
          $$CardResultsTableCreateCompanionBuilder,
          $$CardResultsTableUpdateCompanionBuilder,
          (CardResult, $$CardResultsTableReferences),
          CardResult,
          PrefetchHooks Function({bool cardId, bool reviewId})
        > {
  $$CardResultsTableTableManager(_$AppDatabase db, $CardResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> reviewId = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<int> answerMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardResultsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                cardId: cardId,
                reviewId: reviewId,
                correct: correct,
                answerMs: answerMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String cardId,
                required String reviewId,
                required bool correct,
                required int answerMs,
                Value<int> rowid = const Value.absent(),
              }) => CardResultsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                cardId: cardId,
                reviewId: reviewId,
                correct: correct,
                answerMs: answerMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false, reviewId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cardId,
                                referencedTable: $$CardResultsTableReferences
                                    ._cardIdTable(db),
                                referencedColumn: $$CardResultsTableReferences
                                    ._cardIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (reviewId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.reviewId,
                                referencedTable: $$CardResultsTableReferences
                                    ._reviewIdTable(db),
                                referencedColumn: $$CardResultsTableReferences
                                    ._reviewIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CardResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardResultsTable,
      CardResult,
      $$CardResultsTableFilterComposer,
      $$CardResultsTableOrderingComposer,
      $$CardResultsTableAnnotationComposer,
      $$CardResultsTableCreateCompanionBuilder,
      $$CardResultsTableUpdateCompanionBuilder,
      (CardResult, $$CardResultsTableReferences),
      CardResult,
      PrefetchHooks Function({bool cardId, bool reviewId})
    >;
typedef $$ExamsTableCreateCompanionBuilder =
    ExamsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String name,
      required String date,
      required int priority,
      required ExamStatus status,
      Value<String?> resultNote,
      Value<int> rowid,
    });
typedef $$ExamsTableUpdateCompanionBuilder =
    ExamsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> name,
      Value<String> date,
      Value<int> priority,
      Value<ExamStatus> status,
      Value<String?> resultNote,
      Value<int> rowid,
    });

final class $$ExamsTableReferences
    extends BaseReferences<_$AppDatabase, $ExamsTable, Exam> {
  $$ExamsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExamChunksTable, List<ExamChunk>>
  _examChunksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examChunks,
    aliasName: $_aliasNameGenerator(db.exams.id, db.examChunks.examId),
  );

  $$ExamChunksTableProcessedTableManager get examChunksRefs {
    final manager = $$ExamChunksTableTableManager(
      $_db,
      $_db.examChunks,
    ).filter((f) => f.examId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_examChunksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExamTasksTable, List<ExamTask>>
  _examTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examTasks,
    aliasName: $_aliasNameGenerator(db.exams.id, db.examTasks.examId),
  );

  $$ExamTasksTableProcessedTableManager get examTasksRefs {
    final manager = $$ExamTasksTableTableManager(
      $_db,
      $_db.examTasks,
    ).filter((f) => f.examId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_examTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AvailabilitiesTable, List<Availability>>
  _availabilitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.availabilities,
    aliasName: $_aliasNameGenerator(
      db.exams.id,
      db.availabilities.lockedExamId,
    ),
  );

  $$AvailabilitiesTableProcessedTableManager get availabilitiesRefs {
    final manager = $$AvailabilitiesTableTableManager(
      $_db,
      $_db.availabilities,
    ).filter((f) => f.lockedExamId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_availabilitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AvailabilityOverridesTable,
    List<AvailabilityOverride>
  >
  _availabilityOverridesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.availabilityOverrides,
        aliasName: $_aliasNameGenerator(
          db.exams.id,
          db.availabilityOverrides.lockedExamId,
        ),
      );

  $$AvailabilityOverridesTableProcessedTableManager
  get availabilityOverridesRefs {
    final manager = $$AvailabilityOverridesTableTableManager(
      $_db,
      $_db.availabilityOverrides,
    ).filter((f) => f.lockedExamId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _availabilityOverridesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlanItemsTable, List<PlanItem>>
  _planItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planItems,
    aliasName: $_aliasNameGenerator(db.exams.id, db.planItems.examId),
  );

  $$PlanItemsTableProcessedTableManager get planItemsRefs {
    final manager = $$PlanItemsTableTableManager(
      $_db,
      $_db.planItems,
    ).filter((f) => f.examId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExamsTableFilterComposer extends Composer<_$AppDatabase, $ExamsTable> {
  $$ExamsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExamStatus, ExamStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> examChunksRefs(
    Expression<bool> Function($$ExamChunksTableFilterComposer f) f,
  ) {
    final $$ExamChunksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examChunks,
      getReferencedColumn: (t) => t.examId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamChunksTableFilterComposer(
            $db: $db,
            $table: $db.examChunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> examTasksRefs(
    Expression<bool> Function($$ExamTasksTableFilterComposer f) f,
  ) {
    final $$ExamTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examTasks,
      getReferencedColumn: (t) => t.examId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamTasksTableFilterComposer(
            $db: $db,
            $table: $db.examTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> availabilitiesRefs(
    Expression<bool> Function($$AvailabilitiesTableFilterComposer f) f,
  ) {
    final $$AvailabilitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.availabilities,
      getReferencedColumn: (t) => t.lockedExamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AvailabilitiesTableFilterComposer(
            $db: $db,
            $table: $db.availabilities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> availabilityOverridesRefs(
    Expression<bool> Function($$AvailabilityOverridesTableFilterComposer f) f,
  ) {
    final $$AvailabilityOverridesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.availabilityOverrides,
          getReferencedColumn: (t) => t.lockedExamId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AvailabilityOverridesTableFilterComposer(
                $db: $db,
                $table: $db.availabilityOverrides,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> planItemsRefs(
    Expression<bool> Function($$PlanItemsTableFilterComposer f) f,
  ) {
    final $$PlanItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.examId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableFilterComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamsTable> {
  $$ExamsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamsTable> {
  $$ExamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExamStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => column,
  );

  Expression<T> examChunksRefs<T extends Object>(
    Expression<T> Function($$ExamChunksTableAnnotationComposer a) f,
  ) {
    final $$ExamChunksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examChunks,
      getReferencedColumn: (t) => t.examId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamChunksTableAnnotationComposer(
            $db: $db,
            $table: $db.examChunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> examTasksRefs<T extends Object>(
    Expression<T> Function($$ExamTasksTableAnnotationComposer a) f,
  ) {
    final $$ExamTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examTasks,
      getReferencedColumn: (t) => t.examId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.examTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> availabilitiesRefs<T extends Object>(
    Expression<T> Function($$AvailabilitiesTableAnnotationComposer a) f,
  ) {
    final $$AvailabilitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.availabilities,
      getReferencedColumn: (t) => t.lockedExamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AvailabilitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.availabilities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> availabilityOverridesRefs<T extends Object>(
    Expression<T> Function($$AvailabilityOverridesTableAnnotationComposer a) f,
  ) {
    final $$AvailabilityOverridesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.availabilityOverrides,
          getReferencedColumn: (t) => t.lockedExamId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AvailabilityOverridesTableAnnotationComposer(
                $db: $db,
                $table: $db.availabilityOverrides,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> planItemsRefs<T extends Object>(
    Expression<T> Function($$PlanItemsTableAnnotationComposer a) f,
  ) {
    final $$PlanItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.examId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamsTable,
          Exam,
          $$ExamsTableFilterComposer,
          $$ExamsTableOrderingComposer,
          $$ExamsTableAnnotationComposer,
          $$ExamsTableCreateCompanionBuilder,
          $$ExamsTableUpdateCompanionBuilder,
          (Exam, $$ExamsTableReferences),
          Exam,
          PrefetchHooks Function({
            bool examChunksRefs,
            bool examTasksRefs,
            bool availabilitiesRefs,
            bool availabilityOverridesRefs,
            bool planItemsRefs,
          })
        > {
  $$ExamsTableTableManager(_$AppDatabase db, $ExamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<ExamStatus> status = const Value.absent(),
                Value<String?> resultNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                name: name,
                date: date,
                priority: priority,
                status: status,
                resultNote: resultNote,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String name,
                required String date,
                required int priority,
                required ExamStatus status,
                Value<String?> resultNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                name: name,
                date: date,
                priority: priority,
                status: status,
                resultNote: resultNote,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ExamsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                examChunksRefs = false,
                examTasksRefs = false,
                availabilitiesRefs = false,
                availabilityOverridesRefs = false,
                planItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (examChunksRefs) db.examChunks,
                    if (examTasksRefs) db.examTasks,
                    if (availabilitiesRefs) db.availabilities,
                    if (availabilityOverridesRefs) db.availabilityOverrides,
                    if (planItemsRefs) db.planItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (examChunksRefs)
                        await $_getPrefetchedData<Exam, $ExamsTable, ExamChunk>(
                          currentTable: table,
                          referencedTable: $$ExamsTableReferences
                              ._examChunksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExamsTableReferences(
                                db,
                                table,
                                p0,
                              ).examChunksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (examTasksRefs)
                        await $_getPrefetchedData<Exam, $ExamsTable, ExamTask>(
                          currentTable: table,
                          referencedTable: $$ExamsTableReferences
                              ._examTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExamsTableReferences(
                                db,
                                table,
                                p0,
                              ).examTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (availabilitiesRefs)
                        await $_getPrefetchedData<
                          Exam,
                          $ExamsTable,
                          Availability
                        >(
                          currentTable: table,
                          referencedTable: $$ExamsTableReferences
                              ._availabilitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExamsTableReferences(
                                db,
                                table,
                                p0,
                              ).availabilitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lockedExamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (availabilityOverridesRefs)
                        await $_getPrefetchedData<
                          Exam,
                          $ExamsTable,
                          AvailabilityOverride
                        >(
                          currentTable: table,
                          referencedTable: $$ExamsTableReferences
                              ._availabilityOverridesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExamsTableReferences(
                                db,
                                table,
                                p0,
                              ).availabilityOverridesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lockedExamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (planItemsRefs)
                        await $_getPrefetchedData<Exam, $ExamsTable, PlanItem>(
                          currentTable: table,
                          referencedTable: $$ExamsTableReferences
                              ._planItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExamsTableReferences(
                                db,
                                table,
                                p0,
                              ).planItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamsTable,
      Exam,
      $$ExamsTableFilterComposer,
      $$ExamsTableOrderingComposer,
      $$ExamsTableAnnotationComposer,
      $$ExamsTableCreateCompanionBuilder,
      $$ExamsTableUpdateCompanionBuilder,
      (Exam, $$ExamsTableReferences),
      Exam,
      PrefetchHooks Function({
        bool examChunksRefs,
        bool examTasksRefs,
        bool availabilitiesRefs,
        bool availabilityOverridesRefs,
        bool planItemsRefs,
      })
    >;
typedef $$ExamChunksTableCreateCompanionBuilder =
    ExamChunksCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String examId,
      required String chunkId,
      required Importance importance,
      Value<int> rowid,
    });
typedef $$ExamChunksTableUpdateCompanionBuilder =
    ExamChunksCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> examId,
      Value<String> chunkId,
      Value<Importance> importance,
      Value<int> rowid,
    });

final class $$ExamChunksTableReferences
    extends BaseReferences<_$AppDatabase, $ExamChunksTable, ExamChunk> {
  $$ExamChunksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExamsTable _examIdTable(_$AppDatabase db) => db.exams.createAlias(
    $_aliasNameGenerator(db.examChunks.examId, db.exams.id),
  );

  $$ExamsTableProcessedTableManager get examId {
    final $_column = $_itemColumn<String>('exam_id')!;

    final manager = $$ExamsTableTableManager(
      $_db,
      $_db.exams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChunksTable _chunkIdTable(_$AppDatabase db) => db.chunks.createAlias(
    $_aliasNameGenerator(db.examChunks.chunkId, db.chunks.id),
  );

  $$ChunksTableProcessedTableManager get chunkId {
    final $_column = $_itemColumn<String>('chunk_id')!;

    final manager = $$ChunksTableTableManager(
      $_db,
      $_db.chunks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chunkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExamChunksTableFilterComposer
    extends Composer<_$AppDatabase, $ExamChunksTable> {
  $$ExamChunksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Importance, Importance, String>
  get importance => $composableBuilder(
    column: $table.importance,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ExamsTableFilterComposer get examId {
    final $$ExamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableFilterComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChunksTableFilterComposer get chunkId {
    final $$ChunksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableFilterComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamChunksTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamChunksTable> {
  $$ExamChunksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importance => $composableBuilder(
    column: $table.importance,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExamsTableOrderingComposer get examId {
    final $$ExamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableOrderingComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChunksTableOrderingComposer get chunkId {
    final $$ChunksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableOrderingComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamChunksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamChunksTable> {
  $$ExamChunksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Importance, String> get importance =>
      $composableBuilder(
        column: $table.importance,
        builder: (column) => column,
      );

  $$ExamsTableAnnotationComposer get examId {
    final $$ExamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableAnnotationComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChunksTableAnnotationComposer get chunkId {
    final $$ChunksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChunksTableAnnotationComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamChunksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamChunksTable,
          ExamChunk,
          $$ExamChunksTableFilterComposer,
          $$ExamChunksTableOrderingComposer,
          $$ExamChunksTableAnnotationComposer,
          $$ExamChunksTableCreateCompanionBuilder,
          $$ExamChunksTableUpdateCompanionBuilder,
          (ExamChunk, $$ExamChunksTableReferences),
          ExamChunk,
          PrefetchHooks Function({bool examId, bool chunkId})
        > {
  $$ExamChunksTableTableManager(_$AppDatabase db, $ExamChunksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamChunksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamChunksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamChunksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> examId = const Value.absent(),
                Value<String> chunkId = const Value.absent(),
                Value<Importance> importance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamChunksCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                examId: examId,
                chunkId: chunkId,
                importance: importance,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String examId,
                required String chunkId,
                required Importance importance,
                Value<int> rowid = const Value.absent(),
              }) => ExamChunksCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                examId: examId,
                chunkId: chunkId,
                importance: importance,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExamChunksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examId = false, chunkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (examId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examId,
                                referencedTable: $$ExamChunksTableReferences
                                    ._examIdTable(db),
                                referencedColumn: $$ExamChunksTableReferences
                                    ._examIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (chunkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chunkId,
                                referencedTable: $$ExamChunksTableReferences
                                    ._chunkIdTable(db),
                                referencedColumn: $$ExamChunksTableReferences
                                    ._chunkIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExamChunksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamChunksTable,
      ExamChunk,
      $$ExamChunksTableFilterComposer,
      $$ExamChunksTableOrderingComposer,
      $$ExamChunksTableAnnotationComposer,
      $$ExamChunksTableCreateCompanionBuilder,
      $$ExamChunksTableUpdateCompanionBuilder,
      (ExamChunk, $$ExamChunksTableReferences),
      ExamChunk,
      PrefetchHooks Function({bool examId, bool chunkId})
    >;
typedef $$ExamTasksTableCreateCompanionBuilder =
    ExamTasksCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String examId,
      required String taskId,
      required Importance importance,
      required int targetLevel,
      Value<bool> importanceOverridden,
      Value<int> rowid,
    });
typedef $$ExamTasksTableUpdateCompanionBuilder =
    ExamTasksCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> examId,
      Value<String> taskId,
      Value<Importance> importance,
      Value<int> targetLevel,
      Value<bool> importanceOverridden,
      Value<int> rowid,
    });

final class $$ExamTasksTableReferences
    extends BaseReferences<_$AppDatabase, $ExamTasksTable, ExamTask> {
  $$ExamTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExamsTable _examIdTable(_$AppDatabase db) => db.exams.createAlias(
    $_aliasNameGenerator(db.examTasks.examId, db.exams.id),
  );

  $$ExamsTableProcessedTableManager get examId {
    final $_column = $_itemColumn<String>('exam_id')!;

    final manager = $$ExamsTableTableManager(
      $_db,
      $_db.exams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.examTasks.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExamTasksTableFilterComposer
    extends Composer<_$AppDatabase, $ExamTasksTable> {
  $$ExamTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Importance, Importance, String>
  get importance => $composableBuilder(
    column: $table.importance,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get targetLevel => $composableBuilder(
    column: $table.targetLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get importanceOverridden => $composableBuilder(
    column: $table.importanceOverridden,
    builder: (column) => ColumnFilters(column),
  );

  $$ExamsTableFilterComposer get examId {
    final $$ExamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableFilterComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamTasksTable> {
  $$ExamTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importance => $composableBuilder(
    column: $table.importance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetLevel => $composableBuilder(
    column: $table.targetLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get importanceOverridden => $composableBuilder(
    column: $table.importanceOverridden,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExamsTableOrderingComposer get examId {
    final $$ExamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableOrderingComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamTasksTable> {
  $$ExamTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Importance, String> get importance =>
      $composableBuilder(
        column: $table.importance,
        builder: (column) => column,
      );

  GeneratedColumn<int> get targetLevel => $composableBuilder(
    column: $table.targetLevel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get importanceOverridden => $composableBuilder(
    column: $table.importanceOverridden,
    builder: (column) => column,
  );

  $$ExamsTableAnnotationComposer get examId {
    final $$ExamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableAnnotationComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamTasksTable,
          ExamTask,
          $$ExamTasksTableFilterComposer,
          $$ExamTasksTableOrderingComposer,
          $$ExamTasksTableAnnotationComposer,
          $$ExamTasksTableCreateCompanionBuilder,
          $$ExamTasksTableUpdateCompanionBuilder,
          (ExamTask, $$ExamTasksTableReferences),
          ExamTask,
          PrefetchHooks Function({bool examId, bool taskId})
        > {
  $$ExamTasksTableTableManager(_$AppDatabase db, $ExamTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> examId = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<Importance> importance = const Value.absent(),
                Value<int> targetLevel = const Value.absent(),
                Value<bool> importanceOverridden = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamTasksCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                examId: examId,
                taskId: taskId,
                importance: importance,
                targetLevel: targetLevel,
                importanceOverridden: importanceOverridden,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String examId,
                required String taskId,
                required Importance importance,
                required int targetLevel,
                Value<bool> importanceOverridden = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamTasksCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                examId: examId,
                taskId: taskId,
                importance: importance,
                targetLevel: targetLevel,
                importanceOverridden: importanceOverridden,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExamTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examId = false, taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (examId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examId,
                                referencedTable: $$ExamTasksTableReferences
                                    ._examIdTable(db),
                                referencedColumn: $$ExamTasksTableReferences
                                    ._examIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$ExamTasksTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$ExamTasksTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExamTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamTasksTable,
      ExamTask,
      $$ExamTasksTableFilterComposer,
      $$ExamTasksTableOrderingComposer,
      $$ExamTasksTableAnnotationComposer,
      $$ExamTasksTableCreateCompanionBuilder,
      $$ExamTasksTableUpdateCompanionBuilder,
      (ExamTask, $$ExamTasksTableReferences),
      ExamTask,
      PrefetchHooks Function({bool examId, bool taskId})
    >;
typedef $$AvailabilitiesTableCreateCompanionBuilder =
    AvailabilitiesCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required int weekday,
      required int minutes,
      Value<String?> lockedExamId,
      Value<int> rowid,
    });
typedef $$AvailabilitiesTableUpdateCompanionBuilder =
    AvailabilitiesCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<int> weekday,
      Value<int> minutes,
      Value<String?> lockedExamId,
      Value<int> rowid,
    });

final class $$AvailabilitiesTableReferences
    extends BaseReferences<_$AppDatabase, $AvailabilitiesTable, Availability> {
  $$AvailabilitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExamsTable _lockedExamIdTable(_$AppDatabase db) =>
      db.exams.createAlias(
        $_aliasNameGenerator(db.availabilities.lockedExamId, db.exams.id),
      );

  $$ExamsTableProcessedTableManager? get lockedExamId {
    final $_column = $_itemColumn<String>('locked_exam_id');
    if ($_column == null) return null;
    final manager = $$ExamsTableTableManager(
      $_db,
      $_db.exams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lockedExamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AvailabilitiesTableFilterComposer
    extends Composer<_$AppDatabase, $AvailabilitiesTable> {
  $$AvailabilitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  $$ExamsTableFilterComposer get lockedExamId {
    final $$ExamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lockedExamId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableFilterComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AvailabilitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $AvailabilitiesTable> {
  $$AvailabilitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExamsTableOrderingComposer get lockedExamId {
    final $$ExamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lockedExamId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableOrderingComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AvailabilitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AvailabilitiesTable> {
  $$AvailabilitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  $$ExamsTableAnnotationComposer get lockedExamId {
    final $$ExamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lockedExamId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableAnnotationComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AvailabilitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AvailabilitiesTable,
          Availability,
          $$AvailabilitiesTableFilterComposer,
          $$AvailabilitiesTableOrderingComposer,
          $$AvailabilitiesTableAnnotationComposer,
          $$AvailabilitiesTableCreateCompanionBuilder,
          $$AvailabilitiesTableUpdateCompanionBuilder,
          (Availability, $$AvailabilitiesTableReferences),
          Availability,
          PrefetchHooks Function({bool lockedExamId})
        > {
  $$AvailabilitiesTableTableManager(
    _$AppDatabase db,
    $AvailabilitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AvailabilitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AvailabilitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AvailabilitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<String?> lockedExamId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AvailabilitiesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                weekday: weekday,
                minutes: minutes,
                lockedExamId: lockedExamId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required int weekday,
                required int minutes,
                Value<String?> lockedExamId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AvailabilitiesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                weekday: weekday,
                minutes: minutes,
                lockedExamId: lockedExamId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AvailabilitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lockedExamId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lockedExamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lockedExamId,
                                referencedTable: $$AvailabilitiesTableReferences
                                    ._lockedExamIdTable(db),
                                referencedColumn:
                                    $$AvailabilitiesTableReferences
                                        ._lockedExamIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AvailabilitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AvailabilitiesTable,
      Availability,
      $$AvailabilitiesTableFilterComposer,
      $$AvailabilitiesTableOrderingComposer,
      $$AvailabilitiesTableAnnotationComposer,
      $$AvailabilitiesTableCreateCompanionBuilder,
      $$AvailabilitiesTableUpdateCompanionBuilder,
      (Availability, $$AvailabilitiesTableReferences),
      Availability,
      PrefetchHooks Function({bool lockedExamId})
    >;
typedef $$AvailabilityOverridesTableCreateCompanionBuilder =
    AvailabilityOverridesCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String date,
      required int minutes,
      Value<String?> lockedExamId,
      Value<int> rowid,
    });
typedef $$AvailabilityOverridesTableUpdateCompanionBuilder =
    AvailabilityOverridesCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> date,
      Value<int> minutes,
      Value<String?> lockedExamId,
      Value<int> rowid,
    });

final class $$AvailabilityOverridesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AvailabilityOverridesTable,
          AvailabilityOverride
        > {
  $$AvailabilityOverridesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExamsTable _lockedExamIdTable(_$AppDatabase db) =>
      db.exams.createAlias(
        $_aliasNameGenerator(
          db.availabilityOverrides.lockedExamId,
          db.exams.id,
        ),
      );

  $$ExamsTableProcessedTableManager? get lockedExamId {
    final $_column = $_itemColumn<String>('locked_exam_id');
    if ($_column == null) return null;
    final manager = $$ExamsTableTableManager(
      $_db,
      $_db.exams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lockedExamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AvailabilityOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $AvailabilityOverridesTable> {
  $$AvailabilityOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  $$ExamsTableFilterComposer get lockedExamId {
    final $$ExamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lockedExamId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableFilterComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AvailabilityOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $AvailabilityOverridesTable> {
  $$AvailabilityOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExamsTableOrderingComposer get lockedExamId {
    final $$ExamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lockedExamId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableOrderingComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AvailabilityOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AvailabilityOverridesTable> {
  $$AvailabilityOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  $$ExamsTableAnnotationComposer get lockedExamId {
    final $$ExamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lockedExamId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableAnnotationComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AvailabilityOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AvailabilityOverridesTable,
          AvailabilityOverride,
          $$AvailabilityOverridesTableFilterComposer,
          $$AvailabilityOverridesTableOrderingComposer,
          $$AvailabilityOverridesTableAnnotationComposer,
          $$AvailabilityOverridesTableCreateCompanionBuilder,
          $$AvailabilityOverridesTableUpdateCompanionBuilder,
          (AvailabilityOverride, $$AvailabilityOverridesTableReferences),
          AvailabilityOverride,
          PrefetchHooks Function({bool lockedExamId})
        > {
  $$AvailabilityOverridesTableTableManager(
    _$AppDatabase db,
    $AvailabilityOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AvailabilityOverridesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AvailabilityOverridesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AvailabilityOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<String?> lockedExamId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AvailabilityOverridesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                date: date,
                minutes: minutes,
                lockedExamId: lockedExamId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String date,
                required int minutes,
                Value<String?> lockedExamId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AvailabilityOverridesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                date: date,
                minutes: minutes,
                lockedExamId: lockedExamId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AvailabilityOverridesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lockedExamId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lockedExamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lockedExamId,
                                referencedTable:
                                    $$AvailabilityOverridesTableReferences
                                        ._lockedExamIdTable(db),
                                referencedColumn:
                                    $$AvailabilityOverridesTableReferences
                                        ._lockedExamIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AvailabilityOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AvailabilityOverridesTable,
      AvailabilityOverride,
      $$AvailabilityOverridesTableFilterComposer,
      $$AvailabilityOverridesTableOrderingComposer,
      $$AvailabilityOverridesTableAnnotationComposer,
      $$AvailabilityOverridesTableCreateCompanionBuilder,
      $$AvailabilityOverridesTableUpdateCompanionBuilder,
      (AvailabilityOverride, $$AvailabilityOverridesTableReferences),
      AvailabilityOverride,
      PrefetchHooks Function({bool lockedExamId})
    >;
typedef $$PlanItemsTableCreateCompanionBuilder =
    PlanItemsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String date,
      required String taskId,
      Value<String?> examId,
      required PlanItemKind kind,
      required int estMinutes,
      required PlanItemStatus status,
      required int generation,
      required int order,
      Value<int> rowid,
    });
typedef $$PlanItemsTableUpdateCompanionBuilder =
    PlanItemsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> date,
      Value<String> taskId,
      Value<String?> examId,
      Value<PlanItemKind> kind,
      Value<int> estMinutes,
      Value<PlanItemStatus> status,
      Value<int> generation,
      Value<int> order,
      Value<int> rowid,
    });

final class $$PlanItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PlanItemsTable, PlanItem> {
  $$PlanItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.planItems.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExamsTable _examIdTable(_$AppDatabase db) => db.exams.createAlias(
    $_aliasNameGenerator(db.planItems.examId, db.exams.id),
  );

  $$ExamsTableProcessedTableManager? get examId {
    final $_column = $_itemColumn<String>('exam_id');
    if ($_column == null) return null;
    final manager = $$ExamsTableTableManager(
      $_db,
      $_db.exams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlanItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PlanItemsTable> {
  $$PlanItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PlanItemKind, PlanItemKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get estMinutes => $composableBuilder(
    column: $table.estMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PlanItemStatus, PlanItemStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get generation => $composableBuilder(
    column: $table.generation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExamsTableFilterComposer get examId {
    final $$ExamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableFilterComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanItemsTable> {
  $$PlanItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estMinutes => $composableBuilder(
    column: $table.estMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generation => $composableBuilder(
    column: $table.generation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExamsTableOrderingComposer get examId {
    final $$ExamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableOrderingComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanItemsTable> {
  $$PlanItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PlanItemKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get estMinutes => $composableBuilder(
    column: $table.estMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PlanItemStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get generation => $composableBuilder(
    column: $table.generation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExamsTableAnnotationComposer get examId {
    final $$ExamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examId,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableAnnotationComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanItemsTable,
          PlanItem,
          $$PlanItemsTableFilterComposer,
          $$PlanItemsTableOrderingComposer,
          $$PlanItemsTableAnnotationComposer,
          $$PlanItemsTableCreateCompanionBuilder,
          $$PlanItemsTableUpdateCompanionBuilder,
          (PlanItem, $$PlanItemsTableReferences),
          PlanItem,
          PrefetchHooks Function({bool taskId, bool examId})
        > {
  $$PlanItemsTableTableManager(_$AppDatabase db, $PlanItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String?> examId = const Value.absent(),
                Value<PlanItemKind> kind = const Value.absent(),
                Value<int> estMinutes = const Value.absent(),
                Value<PlanItemStatus> status = const Value.absent(),
                Value<int> generation = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanItemsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                date: date,
                taskId: taskId,
                examId: examId,
                kind: kind,
                estMinutes: estMinutes,
                status: status,
                generation: generation,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String date,
                required String taskId,
                Value<String?> examId = const Value.absent(),
                required PlanItemKind kind,
                required int estMinutes,
                required PlanItemStatus status,
                required int generation,
                required int order,
                Value<int> rowid = const Value.absent(),
              }) => PlanItemsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                date: date,
                taskId: taskId,
                examId: examId,
                kind: kind,
                estMinutes: estMinutes,
                status: status,
                generation: generation,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlanItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false, examId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$PlanItemsTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$PlanItemsTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (examId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examId,
                                referencedTable: $$PlanItemsTableReferences
                                    ._examIdTable(db),
                                referencedColumn: $$PlanItemsTableReferences
                                    ._examIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlanItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanItemsTable,
      PlanItem,
      $$PlanItemsTableFilterComposer,
      $$PlanItemsTableOrderingComposer,
      $$PlanItemsTableAnnotationComposer,
      $$PlanItemsTableCreateCompanionBuilder,
      $$PlanItemsTableUpdateCompanionBuilder,
      (PlanItem, $$PlanItemsTableReferences),
      PlanItem,
      PrefetchHooks Function({bool taskId, bool examId})
    >;
typedef $$QuestsTableCreateCompanionBuilder =
    QuestsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String date,
      required String type,
      required int target,
      required int progress,
      Value<int?> completedAt,
      Value<int> rowid,
    });
typedef $$QuestsTableUpdateCompanionBuilder =
    QuestsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> date,
      Value<String> type,
      Value<int> target,
      Value<int> progress,
      Value<int?> completedAt,
      Value<int> rowid,
    });

class $$QuestsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$QuestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestsTable,
          Quest,
          $$QuestsTableFilterComposer,
          $$QuestsTableOrderingComposer,
          $$QuestsTableAnnotationComposer,
          $$QuestsTableCreateCompanionBuilder,
          $$QuestsTableUpdateCompanionBuilder,
          (Quest, BaseReferences<_$AppDatabase, $QuestsTable, Quest>),
          Quest,
          PrefetchHooks Function()
        > {
  $$QuestsTableTableManager(_$AppDatabase db, $QuestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                date: date,
                type: type,
                target: target,
                progress: progress,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String date,
                required String type,
                required int target,
                required int progress,
                Value<int?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                date: date,
                type: type,
                target: target,
                progress: progress,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestsTable,
      Quest,
      $$QuestsTableFilterComposer,
      $$QuestsTableOrderingComposer,
      $$QuestsTableAnnotationComposer,
      $$QuestsTableCreateCompanionBuilder,
      $$QuestsTableUpdateCompanionBuilder,
      (Quest, BaseReferences<_$AppDatabase, $QuestsTable, Quest>),
      Quest,
      PrefetchHooks Function()
    >;
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String code,
      required int unlockedAt,
      Value<int> rowid,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> code,
      Value<int> unlockedAt,
      Value<int> rowid,
    });

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTable,
          Achievement,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (
            Achievement,
            BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
          ),
          Achievement,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                code: code,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String code,
                required int unlockedAt,
                Value<int> rowid = const Value.absent(),
              }) => AchievementsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                code: code,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTable,
      Achievement,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (
        Achievement,
        BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
      ),
      Achievement,
      PrefetchHooks Function()
    >;
typedef $$RestTokensTableCreateCompanionBuilder =
    RestTokensCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required int earnedAt,
      Value<String?> usedOn,
      Value<int> rowid,
    });
typedef $$RestTokensTableUpdateCompanionBuilder =
    RestTokensCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<int> earnedAt,
      Value<String?> usedOn,
      Value<int> rowid,
    });

class $$RestTokensTableFilterComposer
    extends Composer<_$AppDatabase, $RestTokensTable> {
  $$RestTokensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usedOn => $composableBuilder(
    column: $table.usedOn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RestTokensTableOrderingComposer
    extends Composer<_$AppDatabase, $RestTokensTable> {
  $$RestTokensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usedOn => $composableBuilder(
    column: $table.usedOn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RestTokensTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestTokensTable> {
  $$RestTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);

  GeneratedColumn<String> get usedOn =>
      $composableBuilder(column: $table.usedOn, builder: (column) => column);
}

class $$RestTokensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestTokensTable,
          RestToken,
          $$RestTokensTableFilterComposer,
          $$RestTokensTableOrderingComposer,
          $$RestTokensTableAnnotationComposer,
          $$RestTokensTableCreateCompanionBuilder,
          $$RestTokensTableUpdateCompanionBuilder,
          (
            RestToken,
            BaseReferences<_$AppDatabase, $RestTokensTable, RestToken>,
          ),
          RestToken,
          PrefetchHooks Function()
        > {
  $$RestTokensTableTableManager(_$AppDatabase db, $RestTokensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> earnedAt = const Value.absent(),
                Value<String?> usedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestTokensCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                earnedAt: earnedAt,
                usedOn: usedOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required int earnedAt,
                Value<String?> usedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestTokensCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                earnedAt: earnedAt,
                usedOn: usedOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RestTokensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestTokensTable,
      RestToken,
      $$RestTokensTableFilterComposer,
      $$RestTokensTableOrderingComposer,
      $$RestTokensTableAnnotationComposer,
      $$RestTokensTableCreateCompanionBuilder,
      $$RestTokensTableUpdateCompanionBuilder,
      (RestToken, BaseReferences<_$AppDatabase, $RestTokensTable, RestToken>),
      RestToken,
      PrefetchHooks Function()
    >;
typedef $$TemplatesTableCreateCompanionBuilder =
    TemplatesCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required TemplateKind kind,
      required String name,
      Value<String?> author,
      required int version,
      required TemplateOrigin origin,
      required String payload,
      Value<int?> importedAt,
      Value<int> rowid,
    });
typedef $$TemplatesTableUpdateCompanionBuilder =
    TemplatesCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<TemplateKind> kind,
      Value<String> name,
      Value<String?> author,
      Value<int> version,
      Value<TemplateOrigin> origin,
      Value<String> payload,
      Value<int?> importedAt,
      Value<int> rowid,
    });

final class $$TemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $TemplatesTable, Template> {
  $$TemplatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ImportMapsTable, List<ImportMap>>
  _importMapsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.importMaps,
    aliasName: $_aliasNameGenerator(db.templates.id, db.importMaps.templateId),
  );

  $$ImportMapsTableProcessedTableManager get importMapsRefs {
    final manager = $$ImportMapsTableTableManager(
      $_db,
      $_db.importMaps,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_importMapsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TemplateKind, TemplateKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TemplateOrigin, TemplateOrigin, String>
  get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> importMapsRefs(
    Expression<bool> Function($$ImportMapsTableFilterComposer f) f,
  ) {
    final $$ImportMapsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importMaps,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportMapsTableFilterComposer(
            $db: $db,
            $table: $db.importMaps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TemplateKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TemplateOrigin, String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  Expression<T> importMapsRefs<T extends Object>(
    Expression<T> Function($$ImportMapsTableAnnotationComposer a) f,
  ) {
    final $$ImportMapsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importMaps,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportMapsTableAnnotationComposer(
            $db: $db,
            $table: $db.importMaps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplatesTable,
          Template,
          $$TemplatesTableFilterComposer,
          $$TemplatesTableOrderingComposer,
          $$TemplatesTableAnnotationComposer,
          $$TemplatesTableCreateCompanionBuilder,
          $$TemplatesTableUpdateCompanionBuilder,
          (Template, $$TemplatesTableReferences),
          Template,
          PrefetchHooks Function({bool importMapsRefs})
        > {
  $$TemplatesTableTableManager(_$AppDatabase db, $TemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<TemplateKind> kind = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<TemplateOrigin> origin = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int?> importedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplatesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                kind: kind,
                name: name,
                author: author,
                version: version,
                origin: origin,
                payload: payload,
                importedAt: importedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required TemplateKind kind,
                required String name,
                Value<String?> author = const Value.absent(),
                required int version,
                required TemplateOrigin origin,
                required String payload,
                Value<int?> importedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplatesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                kind: kind,
                name: name,
                author: author,
                version: version,
                origin: origin,
                payload: payload,
                importedAt: importedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({importMapsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (importMapsRefs) db.importMaps],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (importMapsRefs)
                    await $_getPrefetchedData<
                      Template,
                      $TemplatesTable,
                      ImportMap
                    >(
                      currentTable: table,
                      referencedTable: $$TemplatesTableReferences
                          ._importMapsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).importMapsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplatesTable,
      Template,
      $$TemplatesTableFilterComposer,
      $$TemplatesTableOrderingComposer,
      $$TemplatesTableAnnotationComposer,
      $$TemplatesTableCreateCompanionBuilder,
      $$TemplatesTableUpdateCompanionBuilder,
      (Template, $$TemplatesTableReferences),
      Template,
      PrefetchHooks Function({bool importMapsRefs})
    >;
typedef $$ImportMapsTableCreateCompanionBuilder =
    ImportMapsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String templateId,
      required String externalId,
      required String localTable,
      required String localId,
      Value<int> rowid,
    });
typedef $$ImportMapsTableUpdateCompanionBuilder =
    ImportMapsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> templateId,
      Value<String> externalId,
      Value<String> localTable,
      Value<String> localId,
      Value<int> rowid,
    });

final class $$ImportMapsTableReferences
    extends BaseReferences<_$AppDatabase, $ImportMapsTable, ImportMap> {
  $$ImportMapsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.templates.createAlias(
        $_aliasNameGenerator(db.importMaps.templateId, db.templates.id),
      );

  $$TemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<String>('template_id')!;

    final manager = $$TemplatesTableTableManager(
      $_db,
      $_db.templates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ImportMapsTableFilterComposer
    extends Composer<_$AppDatabase, $ImportMapsTable> {
  $$ImportMapsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localTable => $composableBuilder(
    column: $table.localTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  $$TemplatesTableFilterComposer get templateId {
    final $$TemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableFilterComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportMapsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportMapsTable> {
  $$ImportMapsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localTable => $composableBuilder(
    column: $table.localTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  $$TemplatesTableOrderingComposer get templateId {
    final $$TemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportMapsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportMapsTable> {
  $$ImportMapsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localTable => $composableBuilder(
    column: $table.localTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  $$TemplatesTableAnnotationComposer get templateId {
    final $$TemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportMapsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportMapsTable,
          ImportMap,
          $$ImportMapsTableFilterComposer,
          $$ImportMapsTableOrderingComposer,
          $$ImportMapsTableAnnotationComposer,
          $$ImportMapsTableCreateCompanionBuilder,
          $$ImportMapsTableUpdateCompanionBuilder,
          (ImportMap, $$ImportMapsTableReferences),
          ImportMap,
          PrefetchHooks Function({bool templateId})
        > {
  $$ImportMapsTableTableManager(_$AppDatabase db, $ImportMapsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportMapsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportMapsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportMapsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<String> localTable = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportMapsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                templateId: templateId,
                externalId: externalId,
                localTable: localTable,
                localId: localId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String templateId,
                required String externalId,
                required String localTable,
                required String localId,
                Value<int> rowid = const Value.absent(),
              }) => ImportMapsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                templateId: templateId,
                externalId: externalId,
                localTable: localTable,
                localId: localId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ImportMapsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (templateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateId,
                                referencedTable: $$ImportMapsTableReferences
                                    ._templateIdTable(db),
                                referencedColumn: $$ImportMapsTableReferences
                                    ._templateIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ImportMapsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportMapsTable,
      ImportMap,
      $$ImportMapsTableFilterComposer,
      $$ImportMapsTableOrderingComposer,
      $$ImportMapsTableAnnotationComposer,
      $$ImportMapsTableCreateCompanionBuilder,
      $$ImportMapsTableUpdateCompanionBuilder,
      (ImportMap, $$ImportMapsTableReferences),
      ImportMap,
      PrefetchHooks Function({bool templateId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String hlc,
      required String deviceId,
      required String entity,
      required String entityId,
      required EventOp op,
      required String payload,
      Value<int> rowid,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> hlc,
      Value<String> deviceId,
      Value<String> entity,
      Value<String> entityId,
      Value<EventOp> op,
      Value<String> payload,
      Value<int> rowid,
    });

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EventOp, EventOp, String> get op =>
      $composableBuilder(
        column: $table.op,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EventOp, String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, BaseReferences<_$AppDatabase, $EventsTable, Event>),
          Event,
          PrefetchHooks Function()
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<EventOp> op = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                entity: entity,
                entityId: entityId,
                op: op,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String hlc,
                required String deviceId,
                required String entity,
                required String entityId,
                required EventOp op,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                hlc: hlc,
                deviceId: deviceId,
                entity: entity,
                entityId: entityId,
                op: op,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, BaseReferences<_$AppDatabase, $EventsTable, Event>),
      Event,
      PrefetchHooks Function()
    >;
typedef $$ActiveSessionsTableCreateCompanionBuilder =
    ActiveSessionsCompanion Function({
      required String id,
      required String taskId,
      required int startedAt,
      Value<int?> resumeUnit,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ActiveSessionsTableUpdateCompanionBuilder =
    ActiveSessionsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<int> startedAt,
      Value<int?> resumeUnit,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$ActiveSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $ActiveSessionsTable, ActiveSession> {
  $$ActiveSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.activeSessions.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActiveSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveSessionsTable> {
  $$ActiveSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get resumeUnit => $composableBuilder(
    column: $table.resumeUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActiveSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveSessionsTable> {
  $$ActiveSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resumeUnit => $composableBuilder(
    column: $table.resumeUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActiveSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveSessionsTable> {
  $$ActiveSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get resumeUnit => $composableBuilder(
    column: $table.resumeUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActiveSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveSessionsTable,
          ActiveSession,
          $$ActiveSessionsTableFilterComposer,
          $$ActiveSessionsTableOrderingComposer,
          $$ActiveSessionsTableAnnotationComposer,
          $$ActiveSessionsTableCreateCompanionBuilder,
          $$ActiveSessionsTableUpdateCompanionBuilder,
          (ActiveSession, $$ActiveSessionsTableReferences),
          ActiveSession,
          PrefetchHooks Function({bool taskId})
        > {
  $$ActiveSessionsTableTableManager(
    _$AppDatabase db,
    $ActiveSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> resumeUnit = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveSessionsCompanion(
                id: id,
                taskId: taskId,
                startedAt: startedAt,
                resumeUnit: resumeUnit,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required int startedAt,
                Value<int?> resumeUnit = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ActiveSessionsCompanion.insert(
                id: id,
                taskId: taskId,
                startedAt: startedAt,
                resumeUnit: resumeUnit,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActiveSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$ActiveSessionsTableReferences
                                    ._taskIdTable(db),
                                referencedColumn:
                                    $$ActiveSessionsTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActiveSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveSessionsTable,
      ActiveSession,
      $$ActiveSessionsTableFilterComposer,
      $$ActiveSessionsTableOrderingComposer,
      $$ActiveSessionsTableAnnotationComposer,
      $$ActiveSessionsTableCreateCompanionBuilder,
      $$ActiveSessionsTableUpdateCompanionBuilder,
      (ActiveSession, $$ActiveSessionsTableReferences),
      ActiveSession,
      PrefetchHooks Function({bool taskId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db, _db.topics);
  $$SourcesTableTableManager get sources =>
      $$SourcesTableTableManager(_db, _db.sources);
  $$SourceFilesTableTableManager get sourceFiles =>
      $$SourceFilesTableTableManager(_db, _db.sourceFiles);
  $$ChunksTableTableManager get chunks =>
      $$ChunksTableTableManager(_db, _db.chunks);
  $$ChunkSurveysTableTableManager get chunkSurveys =>
      $$ChunkSurveysTableTableManager(_db, _db.chunkSurveys);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TaskChunksTableTableManager get taskChunks =>
      $$TaskChunksTableTableManager(_db, _db.taskChunks);
  $$TaskStatesTableTableManager get taskStates =>
      $$TaskStatesTableTableManager(_db, _db.taskStates);
  $$ReviewsTableTableManager get reviews =>
      $$ReviewsTableTableManager(_db, _db.reviews);
  $$TaskLineagesTableTableManager get taskLineages =>
      $$TaskLineagesTableTableManager(_db, _db.taskLineages);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$CardResultsTableTableManager get cardResults =>
      $$CardResultsTableTableManager(_db, _db.cardResults);
  $$ExamsTableTableManager get exams =>
      $$ExamsTableTableManager(_db, _db.exams);
  $$ExamChunksTableTableManager get examChunks =>
      $$ExamChunksTableTableManager(_db, _db.examChunks);
  $$ExamTasksTableTableManager get examTasks =>
      $$ExamTasksTableTableManager(_db, _db.examTasks);
  $$AvailabilitiesTableTableManager get availabilities =>
      $$AvailabilitiesTableTableManager(_db, _db.availabilities);
  $$AvailabilityOverridesTableTableManager get availabilityOverrides =>
      $$AvailabilityOverridesTableTableManager(_db, _db.availabilityOverrides);
  $$PlanItemsTableTableManager get planItems =>
      $$PlanItemsTableTableManager(_db, _db.planItems);
  $$QuestsTableTableManager get quests =>
      $$QuestsTableTableManager(_db, _db.quests);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$RestTokensTableTableManager get restTokens =>
      $$RestTokensTableTableManager(_db, _db.restTokens);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db, _db.templates);
  $$ImportMapsTableTableManager get importMaps =>
      $$ImportMapsTableTableManager(_db, _db.importMaps);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$ActiveSessionsTableTableManager get activeSessions =>
      $$ActiveSessionsTableTableManager(_db, _db.activeSessions);
}
