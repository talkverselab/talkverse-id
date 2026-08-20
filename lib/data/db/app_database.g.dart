// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TurnsTable extends Turns with TableInfo<$TurnsTable, TurnRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TurnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variantMeta = const VerificationMeta(
    'variant',
  );
  @override
  late final GeneratedColumn<String> variant = GeneratedColumn<String>(
    'variant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('id'),
  );
  static const VerificationMeta _episodeIdMeta = const VerificationMeta(
    'episodeId',
  );
  @override
  late final GeneratedColumn<String> episodeId = GeneratedColumn<String>(
    'episode_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numMeta = const VerificationMeta('num');
  @override
  late final GeneratedColumn<int> num = GeneratedColumn<int>(
    'num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speakerMeta = const VerificationMeta(
    'speaker',
  );
  @override
  late final GeneratedColumn<String> speaker = GeneratedColumn<String>(
    'speaker',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _msMeta = const VerificationMeta('ms');
  @override
  late final GeneratedColumn<String> ms = GeneratedColumn<String>(
    'ms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _koMeta = const VerificationMeta('ko');
  @override
  late final GeneratedColumn<String> ko = GeneratedColumn<String>(
    'ko',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _glossMeta = const VerificationMeta('gloss');
  @override
  late final GeneratedColumn<String> gloss = GeneratedColumn<String>(
    'gloss',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    variant,
    episodeId,
    num,
    speaker,
    body,
    ms,
    ko,
    gloss,
    note,
    tagsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'turns';
  @override
  VerificationContext validateIntegrity(
    Insertable<TurnRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('variant')) {
      context.handle(
        _variantMeta,
        variant.isAcceptableOrUnknown(data['variant']!, _variantMeta),
      );
    }
    if (data.containsKey('episode_id')) {
      context.handle(
        _episodeIdMeta,
        episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta),
      );
    }
    if (data.containsKey('num')) {
      context.handle(
        _numMeta,
        num.isAcceptableOrUnknown(data['num']!, _numMeta),
      );
    } else if (isInserting) {
      context.missing(_numMeta);
    }
    if (data.containsKey('speaker')) {
      context.handle(
        _speakerMeta,
        speaker.isAcceptableOrUnknown(data['speaker']!, _speakerMeta),
      );
    } else if (isInserting) {
      context.missing(_speakerMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('ms')) {
      context.handle(_msMeta, ms.isAcceptableOrUnknown(data['ms']!, _msMeta));
    }
    if (data.containsKey('ko')) {
      context.handle(_koMeta, ko.isAcceptableOrUnknown(data['ko']!, _koMeta));
    }
    if (data.containsKey('gloss')) {
      context.handle(
        _glossMeta,
        gloss.isAcceptableOrUnknown(data['gloss']!, _glossMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TurnRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TurnRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      variant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant'],
      )!,
      episodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_id'],
      ),
      num: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num'],
      )!,
      speaker: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speaker'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      ms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ms'],
      ),
      ko: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ko'],
      ),
      gloss: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gloss'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      ),
    );
  }

  @override
  $TurnsTable createAlias(String alias) {
    return $TurnsTable(attachedDatabase, alias);
  }
}

class TurnRow extends DataClass implements Insertable<TurnRow> {
  final int id;
  final String level;
  final String variant;
  final String? episodeId;
  final int num;
  final String speaker;
  final String body;
  final String? ms;
  final String? ko;
  final String? gloss;
  final String? note;
  final String? tagsJson;
  const TurnRow({
    required this.id,
    required this.level,
    required this.variant,
    this.episodeId,
    required this.num,
    required this.speaker,
    required this.body,
    this.ms,
    this.ko,
    this.gloss,
    this.note,
    this.tagsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<String>(level);
    map['variant'] = Variable<String>(variant);
    if (!nullToAbsent || episodeId != null) {
      map['episode_id'] = Variable<String>(episodeId);
    }
    map['num'] = Variable<int>(num);
    map['speaker'] = Variable<String>(speaker);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || ms != null) {
      map['ms'] = Variable<String>(ms);
    }
    if (!nullToAbsent || ko != null) {
      map['ko'] = Variable<String>(ko);
    }
    if (!nullToAbsent || gloss != null) {
      map['gloss'] = Variable<String>(gloss);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || tagsJson != null) {
      map['tags_json'] = Variable<String>(tagsJson);
    }
    return map;
  }

  TurnsCompanion toCompanion(bool nullToAbsent) {
    return TurnsCompanion(
      id: Value(id),
      level: Value(level),
      variant: Value(variant),
      episodeId: episodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(episodeId),
      num: Value(num),
      speaker: Value(speaker),
      body: Value(body),
      ms: ms == null && nullToAbsent ? const Value.absent() : Value(ms),
      ko: ko == null && nullToAbsent ? const Value.absent() : Value(ko),
      gloss: gloss == null && nullToAbsent
          ? const Value.absent()
          : Value(gloss),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      tagsJson: tagsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(tagsJson),
    );
  }

  factory TurnRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TurnRow(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      variant: serializer.fromJson<String>(json['variant']),
      episodeId: serializer.fromJson<String?>(json['episodeId']),
      num: serializer.fromJson<int>(json['num']),
      speaker: serializer.fromJson<String>(json['speaker']),
      body: serializer.fromJson<String>(json['body']),
      ms: serializer.fromJson<String?>(json['ms']),
      ko: serializer.fromJson<String?>(json['ko']),
      gloss: serializer.fromJson<String?>(json['gloss']),
      note: serializer.fromJson<String?>(json['note']),
      tagsJson: serializer.fromJson<String?>(json['tagsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<String>(level),
      'variant': serializer.toJson<String>(variant),
      'episodeId': serializer.toJson<String?>(episodeId),
      'num': serializer.toJson<int>(num),
      'speaker': serializer.toJson<String>(speaker),
      'body': serializer.toJson<String>(body),
      'ms': serializer.toJson<String?>(ms),
      'ko': serializer.toJson<String?>(ko),
      'gloss': serializer.toJson<String?>(gloss),
      'note': serializer.toJson<String?>(note),
      'tagsJson': serializer.toJson<String?>(tagsJson),
    };
  }

  TurnRow copyWith({
    int? id,
    String? level,
    String? variant,
    Value<String?> episodeId = const Value.absent(),
    int? num,
    String? speaker,
    String? body,
    Value<String?> ms = const Value.absent(),
    Value<String?> ko = const Value.absent(),
    Value<String?> gloss = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> tagsJson = const Value.absent(),
  }) => TurnRow(
    id: id ?? this.id,
    level: level ?? this.level,
    variant: variant ?? this.variant,
    episodeId: episodeId.present ? episodeId.value : this.episodeId,
    num: num ?? this.num,
    speaker: speaker ?? this.speaker,
    body: body ?? this.body,
    ms: ms.present ? ms.value : this.ms,
    ko: ko.present ? ko.value : this.ko,
    gloss: gloss.present ? gloss.value : this.gloss,
    note: note.present ? note.value : this.note,
    tagsJson: tagsJson.present ? tagsJson.value : this.tagsJson,
  );
  TurnRow copyWithCompanion(TurnsCompanion data) {
    return TurnRow(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      variant: data.variant.present ? data.variant.value : this.variant,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      num: data.num.present ? data.num.value : this.num,
      speaker: data.speaker.present ? data.speaker.value : this.speaker,
      body: data.body.present ? data.body.value : this.body,
      ms: data.ms.present ? data.ms.value : this.ms,
      ko: data.ko.present ? data.ko.value : this.ko,
      gloss: data.gloss.present ? data.gloss.value : this.gloss,
      note: data.note.present ? data.note.value : this.note,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TurnRow(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('variant: $variant, ')
          ..write('episodeId: $episodeId, ')
          ..write('num: $num, ')
          ..write('speaker: $speaker, ')
          ..write('body: $body, ')
          ..write('ms: $ms, ')
          ..write('ko: $ko, ')
          ..write('gloss: $gloss, ')
          ..write('note: $note, ')
          ..write('tagsJson: $tagsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    level,
    variant,
    episodeId,
    num,
    speaker,
    body,
    ms,
    ko,
    gloss,
    note,
    tagsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TurnRow &&
          other.id == this.id &&
          other.level == this.level &&
          other.variant == this.variant &&
          other.episodeId == this.episodeId &&
          other.num == this.num &&
          other.speaker == this.speaker &&
          other.body == this.body &&
          other.ms == this.ms &&
          other.ko == this.ko &&
          other.gloss == this.gloss &&
          other.note == this.note &&
          other.tagsJson == this.tagsJson);
}

class TurnsCompanion extends UpdateCompanion<TurnRow> {
  final Value<int> id;
  final Value<String> level;
  final Value<String> variant;
  final Value<String?> episodeId;
  final Value<int> num;
  final Value<String> speaker;
  final Value<String> body;
  final Value<String?> ms;
  final Value<String?> ko;
  final Value<String?> gloss;
  final Value<String?> note;
  final Value<String?> tagsJson;
  const TurnsCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.variant = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.num = const Value.absent(),
    this.speaker = const Value.absent(),
    this.body = const Value.absent(),
    this.ms = const Value.absent(),
    this.ko = const Value.absent(),
    this.gloss = const Value.absent(),
    this.note = const Value.absent(),
    this.tagsJson = const Value.absent(),
  });
  TurnsCompanion.insert({
    this.id = const Value.absent(),
    required String level,
    this.variant = const Value.absent(),
    this.episodeId = const Value.absent(),
    required int num,
    required String speaker,
    required String body,
    this.ms = const Value.absent(),
    this.ko = const Value.absent(),
    this.gloss = const Value.absent(),
    this.note = const Value.absent(),
    this.tagsJson = const Value.absent(),
  }) : level = Value(level),
       num = Value(num),
       speaker = Value(speaker),
       body = Value(body);
  static Insertable<TurnRow> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<String>? variant,
    Expression<String>? episodeId,
    Expression<int>? num,
    Expression<String>? speaker,
    Expression<String>? body,
    Expression<String>? ms,
    Expression<String>? ko,
    Expression<String>? gloss,
    Expression<String>? note,
    Expression<String>? tagsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (variant != null) 'variant': variant,
      if (episodeId != null) 'episode_id': episodeId,
      if (num != null) 'num': num,
      if (speaker != null) 'speaker': speaker,
      if (body != null) 'body': body,
      if (ms != null) 'ms': ms,
      if (ko != null) 'ko': ko,
      if (gloss != null) 'gloss': gloss,
      if (note != null) 'note': note,
      if (tagsJson != null) 'tags_json': tagsJson,
    });
  }

  TurnsCompanion copyWith({
    Value<int>? id,
    Value<String>? level,
    Value<String>? variant,
    Value<String?>? episodeId,
    Value<int>? num,
    Value<String>? speaker,
    Value<String>? body,
    Value<String?>? ms,
    Value<String?>? ko,
    Value<String?>? gloss,
    Value<String?>? note,
    Value<String?>? tagsJson,
  }) {
    return TurnsCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      variant: variant ?? this.variant,
      episodeId: episodeId ?? this.episodeId,
      num: num ?? this.num,
      speaker: speaker ?? this.speaker,
      body: body ?? this.body,
      ms: ms ?? this.ms,
      ko: ko ?? this.ko,
      gloss: gloss ?? this.gloss,
      note: note ?? this.note,
      tagsJson: tagsJson ?? this.tagsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (variant.present) {
      map['variant'] = Variable<String>(variant.value);
    }
    if (episodeId.present) {
      map['episode_id'] = Variable<String>(episodeId.value);
    }
    if (num.present) {
      map['num'] = Variable<int>(num.value);
    }
    if (speaker.present) {
      map['speaker'] = Variable<String>(speaker.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (ms.present) {
      map['ms'] = Variable<String>(ms.value);
    }
    if (ko.present) {
      map['ko'] = Variable<String>(ko.value);
    }
    if (gloss.present) {
      map['gloss'] = Variable<String>(gloss.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TurnsCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('variant: $variant, ')
          ..write('episodeId: $episodeId, ')
          ..write('num: $num, ')
          ..write('speaker: $speaker, ')
          ..write('body: $body, ')
          ..write('ms: $ms, ')
          ..write('ko: $ko, ')
          ..write('gloss: $gloss, ')
          ..write('note: $note, ')
          ..write('tagsJson: $tagsJson')
          ..write(')'))
        .toString();
  }
}

class $RootsTable extends Roots with TableInfo<$RootsTable, RootRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RootsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rootMeta = const VerificationMeta('root');
  @override
  late final GeneratedColumn<String> root = GeneratedColumn<String>(
    'root',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _freqMeta = const VerificationMeta('freq');
  @override
  late final GeneratedColumn<int> freq = GeneratedColumn<int>(
    'freq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
    'pos',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<int> phase = GeneratedColumn<int>(
    'phase',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meaningKoMeta = const VerificationMeta(
    'meaningKo',
  );
  @override
  late final GeneratedColumn<String> meaningKo = GeneratedColumn<String>(
    'meaning_ko',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _msFormMeta = const VerificationMeta('msForm');
  @override
  late final GeneratedColumn<String> msForm = GeneratedColumn<String>(
    'ms_form',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _familyJsonMeta = const VerificationMeta(
    'familyJson',
  );
  @override
  late final GeneratedColumn<String> familyJson = GeneratedColumn<String>(
    'family_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    root,
    rank,
    freq,
    pos,
    phase,
    meaningKo,
    msForm,
    familyJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roots';
  @override
  VerificationContext validateIntegrity(
    Insertable<RootRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('root')) {
      context.handle(
        _rootMeta,
        root.isAcceptableOrUnknown(data['root']!, _rootMeta),
      );
    } else if (isInserting) {
      context.missing(_rootMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    }
    if (data.containsKey('freq')) {
      context.handle(
        _freqMeta,
        freq.isAcceptableOrUnknown(data['freq']!, _freqMeta),
      );
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    }
    if (data.containsKey('meaning_ko')) {
      context.handle(
        _meaningKoMeta,
        meaningKo.isAcceptableOrUnknown(data['meaning_ko']!, _meaningKoMeta),
      );
    }
    if (data.containsKey('ms_form')) {
      context.handle(
        _msFormMeta,
        msForm.isAcceptableOrUnknown(data['ms_form']!, _msFormMeta),
      );
    }
    if (data.containsKey('family_json')) {
      context.handle(
        _familyJsonMeta,
        familyJson.isAcceptableOrUnknown(data['family_json']!, _familyJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {root};
  @override
  RootRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RootRow(
      root: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      ),
      freq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}freq'],
      ),
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos'],
      ),
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phase'],
      ),
      meaningKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_ko'],
      ),
      msForm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ms_form'],
      ),
      familyJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_json'],
      ),
    );
  }

  @override
  $RootsTable createAlias(String alias) {
    return $RootsTable(attachedDatabase, alias);
  }
}

class RootRow extends DataClass implements Insertable<RootRow> {
  final String root;
  final int? rank;
  final int? freq;
  final String? pos;
  final int? phase;
  final String? meaningKo;
  final String? msForm;
  final String? familyJson;
  const RootRow({
    required this.root,
    this.rank,
    this.freq,
    this.pos,
    this.phase,
    this.meaningKo,
    this.msForm,
    this.familyJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['root'] = Variable<String>(root);
    if (!nullToAbsent || rank != null) {
      map['rank'] = Variable<int>(rank);
    }
    if (!nullToAbsent || freq != null) {
      map['freq'] = Variable<int>(freq);
    }
    if (!nullToAbsent || pos != null) {
      map['pos'] = Variable<String>(pos);
    }
    if (!nullToAbsent || phase != null) {
      map['phase'] = Variable<int>(phase);
    }
    if (!nullToAbsent || meaningKo != null) {
      map['meaning_ko'] = Variable<String>(meaningKo);
    }
    if (!nullToAbsent || msForm != null) {
      map['ms_form'] = Variable<String>(msForm);
    }
    if (!nullToAbsent || familyJson != null) {
      map['family_json'] = Variable<String>(familyJson);
    }
    return map;
  }

  RootsCompanion toCompanion(bool nullToAbsent) {
    return RootsCompanion(
      root: Value(root),
      rank: rank == null && nullToAbsent ? const Value.absent() : Value(rank),
      freq: freq == null && nullToAbsent ? const Value.absent() : Value(freq),
      pos: pos == null && nullToAbsent ? const Value.absent() : Value(pos),
      phase: phase == null && nullToAbsent
          ? const Value.absent()
          : Value(phase),
      meaningKo: meaningKo == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningKo),
      msForm: msForm == null && nullToAbsent
          ? const Value.absent()
          : Value(msForm),
      familyJson: familyJson == null && nullToAbsent
          ? const Value.absent()
          : Value(familyJson),
    );
  }

  factory RootRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RootRow(
      root: serializer.fromJson<String>(json['root']),
      rank: serializer.fromJson<int?>(json['rank']),
      freq: serializer.fromJson<int?>(json['freq']),
      pos: serializer.fromJson<String?>(json['pos']),
      phase: serializer.fromJson<int?>(json['phase']),
      meaningKo: serializer.fromJson<String?>(json['meaningKo']),
      msForm: serializer.fromJson<String?>(json['msForm']),
      familyJson: serializer.fromJson<String?>(json['familyJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'root': serializer.toJson<String>(root),
      'rank': serializer.toJson<int?>(rank),
      'freq': serializer.toJson<int?>(freq),
      'pos': serializer.toJson<String?>(pos),
      'phase': serializer.toJson<int?>(phase),
      'meaningKo': serializer.toJson<String?>(meaningKo),
      'msForm': serializer.toJson<String?>(msForm),
      'familyJson': serializer.toJson<String?>(familyJson),
    };
  }

  RootRow copyWith({
    String? root,
    Value<int?> rank = const Value.absent(),
    Value<int?> freq = const Value.absent(),
    Value<String?> pos = const Value.absent(),
    Value<int?> phase = const Value.absent(),
    Value<String?> meaningKo = const Value.absent(),
    Value<String?> msForm = const Value.absent(),
    Value<String?> familyJson = const Value.absent(),
  }) => RootRow(
    root: root ?? this.root,
    rank: rank.present ? rank.value : this.rank,
    freq: freq.present ? freq.value : this.freq,
    pos: pos.present ? pos.value : this.pos,
    phase: phase.present ? phase.value : this.phase,
    meaningKo: meaningKo.present ? meaningKo.value : this.meaningKo,
    msForm: msForm.present ? msForm.value : this.msForm,
    familyJson: familyJson.present ? familyJson.value : this.familyJson,
  );
  RootRow copyWithCompanion(RootsCompanion data) {
    return RootRow(
      root: data.root.present ? data.root.value : this.root,
      rank: data.rank.present ? data.rank.value : this.rank,
      freq: data.freq.present ? data.freq.value : this.freq,
      pos: data.pos.present ? data.pos.value : this.pos,
      phase: data.phase.present ? data.phase.value : this.phase,
      meaningKo: data.meaningKo.present ? data.meaningKo.value : this.meaningKo,
      msForm: data.msForm.present ? data.msForm.value : this.msForm,
      familyJson: data.familyJson.present
          ? data.familyJson.value
          : this.familyJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RootRow(')
          ..write('root: $root, ')
          ..write('rank: $rank, ')
          ..write('freq: $freq, ')
          ..write('pos: $pos, ')
          ..write('phase: $phase, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('msForm: $msForm, ')
          ..write('familyJson: $familyJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(root, rank, freq, pos, phase, meaningKo, msForm, familyJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RootRow &&
          other.root == this.root &&
          other.rank == this.rank &&
          other.freq == this.freq &&
          other.pos == this.pos &&
          other.phase == this.phase &&
          other.meaningKo == this.meaningKo &&
          other.msForm == this.msForm &&
          other.familyJson == this.familyJson);
}

class RootsCompanion extends UpdateCompanion<RootRow> {
  final Value<String> root;
  final Value<int?> rank;
  final Value<int?> freq;
  final Value<String?> pos;
  final Value<int?> phase;
  final Value<String?> meaningKo;
  final Value<String?> msForm;
  final Value<String?> familyJson;
  final Value<int> rowid;
  const RootsCompanion({
    this.root = const Value.absent(),
    this.rank = const Value.absent(),
    this.freq = const Value.absent(),
    this.pos = const Value.absent(),
    this.phase = const Value.absent(),
    this.meaningKo = const Value.absent(),
    this.msForm = const Value.absent(),
    this.familyJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RootsCompanion.insert({
    required String root,
    this.rank = const Value.absent(),
    this.freq = const Value.absent(),
    this.pos = const Value.absent(),
    this.phase = const Value.absent(),
    this.meaningKo = const Value.absent(),
    this.msForm = const Value.absent(),
    this.familyJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : root = Value(root);
  static Insertable<RootRow> custom({
    Expression<String>? root,
    Expression<int>? rank,
    Expression<int>? freq,
    Expression<String>? pos,
    Expression<int>? phase,
    Expression<String>? meaningKo,
    Expression<String>? msForm,
    Expression<String>? familyJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (root != null) 'root': root,
      if (rank != null) 'rank': rank,
      if (freq != null) 'freq': freq,
      if (pos != null) 'pos': pos,
      if (phase != null) 'phase': phase,
      if (meaningKo != null) 'meaning_ko': meaningKo,
      if (msForm != null) 'ms_form': msForm,
      if (familyJson != null) 'family_json': familyJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RootsCompanion copyWith({
    Value<String>? root,
    Value<int?>? rank,
    Value<int?>? freq,
    Value<String?>? pos,
    Value<int?>? phase,
    Value<String?>? meaningKo,
    Value<String?>? msForm,
    Value<String?>? familyJson,
    Value<int>? rowid,
  }) {
    return RootsCompanion(
      root: root ?? this.root,
      rank: rank ?? this.rank,
      freq: freq ?? this.freq,
      pos: pos ?? this.pos,
      phase: phase ?? this.phase,
      meaningKo: meaningKo ?? this.meaningKo,
      msForm: msForm ?? this.msForm,
      familyJson: familyJson ?? this.familyJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (root.present) {
      map['root'] = Variable<String>(root.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (freq.present) {
      map['freq'] = Variable<int>(freq.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (phase.present) {
      map['phase'] = Variable<int>(phase.value);
    }
    if (meaningKo.present) {
      map['meaning_ko'] = Variable<String>(meaningKo.value);
    }
    if (msForm.present) {
      map['ms_form'] = Variable<String>(msForm.value);
    }
    if (familyJson.present) {
      map['family_json'] = Variable<String>(familyJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RootsCompanion(')
          ..write('root: $root, ')
          ..write('rank: $rank, ')
          ..write('freq: $freq, ')
          ..write('pos: $pos, ')
          ..write('phase: $phase, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('msForm: $msForm, ')
          ..write('familyJson: $familyJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AffixesTable extends Affixes with TableInfo<$AffixesTable, AffixRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AffixesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
    'form',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningKoMeta = const VerificationMeta(
    'meaningKo',
  );
  @override
  late final GeneratedColumn<String> meaningKo = GeneratedColumn<String>(
    'meaning_ko',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allomorphsMeta = const VerificationMeta(
    'allomorphs',
  );
  @override
  late final GeneratedColumn<String> allomorphs = GeneratedColumn<String>(
    'allomorphs',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _examplesJsonMeta = const VerificationMeta(
    'examplesJson',
  );
  @override
  late final GeneratedColumn<String> examplesJson = GeneratedColumn<String>(
    'examples_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    form,
    kind,
    position,
    meaningKo,
    allomorphs,
    examplesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'affixes';
  @override
  VerificationContext validateIntegrity(
    Insertable<AffixRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('form')) {
      context.handle(
        _formMeta,
        form.isAcceptableOrUnknown(data['form']!, _formMeta),
      );
    } else if (isInserting) {
      context.missing(_formMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('meaning_ko')) {
      context.handle(
        _meaningKoMeta,
        meaningKo.isAcceptableOrUnknown(data['meaning_ko']!, _meaningKoMeta),
      );
    }
    if (data.containsKey('allomorphs')) {
      context.handle(
        _allomorphsMeta,
        allomorphs.isAcceptableOrUnknown(data['allomorphs']!, _allomorphsMeta),
      );
    }
    if (data.containsKey('examples_json')) {
      context.handle(
        _examplesJsonMeta,
        examplesJson.isAcceptableOrUnknown(
          data['examples_json']!,
          _examplesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AffixRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AffixRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      form: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      )!,
      meaningKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_ko'],
      ),
      allomorphs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allomorphs'],
      ),
      examplesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examples_json'],
      ),
    );
  }

  @override
  $AffixesTable createAlias(String alias) {
    return $AffixesTable(attachedDatabase, alias);
  }
}

class AffixRow extends DataClass implements Insertable<AffixRow> {
  final int id;
  final String form;
  final String kind;
  final String position;
  final String? meaningKo;
  final String? allomorphs;
  final String? examplesJson;
  const AffixRow({
    required this.id,
    required this.form,
    required this.kind,
    required this.position,
    this.meaningKo,
    this.allomorphs,
    this.examplesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['form'] = Variable<String>(form);
    map['kind'] = Variable<String>(kind);
    map['position'] = Variable<String>(position);
    if (!nullToAbsent || meaningKo != null) {
      map['meaning_ko'] = Variable<String>(meaningKo);
    }
    if (!nullToAbsent || allomorphs != null) {
      map['allomorphs'] = Variable<String>(allomorphs);
    }
    if (!nullToAbsent || examplesJson != null) {
      map['examples_json'] = Variable<String>(examplesJson);
    }
    return map;
  }

  AffixesCompanion toCompanion(bool nullToAbsent) {
    return AffixesCompanion(
      id: Value(id),
      form: Value(form),
      kind: Value(kind),
      position: Value(position),
      meaningKo: meaningKo == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningKo),
      allomorphs: allomorphs == null && nullToAbsent
          ? const Value.absent()
          : Value(allomorphs),
      examplesJson: examplesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(examplesJson),
    );
  }

  factory AffixRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AffixRow(
      id: serializer.fromJson<int>(json['id']),
      form: serializer.fromJson<String>(json['form']),
      kind: serializer.fromJson<String>(json['kind']),
      position: serializer.fromJson<String>(json['position']),
      meaningKo: serializer.fromJson<String?>(json['meaningKo']),
      allomorphs: serializer.fromJson<String?>(json['allomorphs']),
      examplesJson: serializer.fromJson<String?>(json['examplesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'form': serializer.toJson<String>(form),
      'kind': serializer.toJson<String>(kind),
      'position': serializer.toJson<String>(position),
      'meaningKo': serializer.toJson<String?>(meaningKo),
      'allomorphs': serializer.toJson<String?>(allomorphs),
      'examplesJson': serializer.toJson<String?>(examplesJson),
    };
  }

  AffixRow copyWith({
    int? id,
    String? form,
    String? kind,
    String? position,
    Value<String?> meaningKo = const Value.absent(),
    Value<String?> allomorphs = const Value.absent(),
    Value<String?> examplesJson = const Value.absent(),
  }) => AffixRow(
    id: id ?? this.id,
    form: form ?? this.form,
    kind: kind ?? this.kind,
    position: position ?? this.position,
    meaningKo: meaningKo.present ? meaningKo.value : this.meaningKo,
    allomorphs: allomorphs.present ? allomorphs.value : this.allomorphs,
    examplesJson: examplesJson.present ? examplesJson.value : this.examplesJson,
  );
  AffixRow copyWithCompanion(AffixesCompanion data) {
    return AffixRow(
      id: data.id.present ? data.id.value : this.id,
      form: data.form.present ? data.form.value : this.form,
      kind: data.kind.present ? data.kind.value : this.kind,
      position: data.position.present ? data.position.value : this.position,
      meaningKo: data.meaningKo.present ? data.meaningKo.value : this.meaningKo,
      allomorphs: data.allomorphs.present
          ? data.allomorphs.value
          : this.allomorphs,
      examplesJson: data.examplesJson.present
          ? data.examplesJson.value
          : this.examplesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AffixRow(')
          ..write('id: $id, ')
          ..write('form: $form, ')
          ..write('kind: $kind, ')
          ..write('position: $position, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('allomorphs: $allomorphs, ')
          ..write('examplesJson: $examplesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    form,
    kind,
    position,
    meaningKo,
    allomorphs,
    examplesJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AffixRow &&
          other.id == this.id &&
          other.form == this.form &&
          other.kind == this.kind &&
          other.position == this.position &&
          other.meaningKo == this.meaningKo &&
          other.allomorphs == this.allomorphs &&
          other.examplesJson == this.examplesJson);
}

class AffixesCompanion extends UpdateCompanion<AffixRow> {
  final Value<int> id;
  final Value<String> form;
  final Value<String> kind;
  final Value<String> position;
  final Value<String?> meaningKo;
  final Value<String?> allomorphs;
  final Value<String?> examplesJson;
  const AffixesCompanion({
    this.id = const Value.absent(),
    this.form = const Value.absent(),
    this.kind = const Value.absent(),
    this.position = const Value.absent(),
    this.meaningKo = const Value.absent(),
    this.allomorphs = const Value.absent(),
    this.examplesJson = const Value.absent(),
  });
  AffixesCompanion.insert({
    this.id = const Value.absent(),
    required String form,
    required String kind,
    required String position,
    this.meaningKo = const Value.absent(),
    this.allomorphs = const Value.absent(),
    this.examplesJson = const Value.absent(),
  }) : form = Value(form),
       kind = Value(kind),
       position = Value(position);
  static Insertable<AffixRow> custom({
    Expression<int>? id,
    Expression<String>? form,
    Expression<String>? kind,
    Expression<String>? position,
    Expression<String>? meaningKo,
    Expression<String>? allomorphs,
    Expression<String>? examplesJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (form != null) 'form': form,
      if (kind != null) 'kind': kind,
      if (position != null) 'position': position,
      if (meaningKo != null) 'meaning_ko': meaningKo,
      if (allomorphs != null) 'allomorphs': allomorphs,
      if (examplesJson != null) 'examples_json': examplesJson,
    });
  }

  AffixesCompanion copyWith({
    Value<int>? id,
    Value<String>? form,
    Value<String>? kind,
    Value<String>? position,
    Value<String?>? meaningKo,
    Value<String?>? allomorphs,
    Value<String?>? examplesJson,
  }) {
    return AffixesCompanion(
      id: id ?? this.id,
      form: form ?? this.form,
      kind: kind ?? this.kind,
      position: position ?? this.position,
      meaningKo: meaningKo ?? this.meaningKo,
      allomorphs: allomorphs ?? this.allomorphs,
      examplesJson: examplesJson ?? this.examplesJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (meaningKo.present) {
      map['meaning_ko'] = Variable<String>(meaningKo.value);
    }
    if (allomorphs.present) {
      map['allomorphs'] = Variable<String>(allomorphs.value);
    }
    if (examplesJson.present) {
      map['examples_json'] = Variable<String>(examplesJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AffixesCompanion(')
          ..write('id: $id, ')
          ..write('form: $form, ')
          ..write('kind: $kind, ')
          ..write('position: $position, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('allomorphs: $allomorphs, ')
          ..write('examplesJson: $examplesJson')
          ..write(')'))
        .toString();
  }
}

class $WordsTable extends Words with TableInfo<$WordsTable, WordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _freqMeta = const VerificationMeta('freq');
  @override
  late final GeneratedColumn<double> freq = GeneratedColumn<double>(
    'freq',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cumPctMeta = const VerificationMeta('cumPct');
  @override
  late final GeneratedColumn<double> cumPct = GeneratedColumn<double>(
    'cum_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rootMeta = const VerificationMeta('root');
  @override
  late final GeneratedColumn<String> root = GeneratedColumn<String>(
    'root',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rank,
    word,
    freq,
    cumPct,
    region,
    root,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('freq')) {
      context.handle(
        _freqMeta,
        freq.isAcceptableOrUnknown(data['freq']!, _freqMeta),
      );
    }
    if (data.containsKey('cum_pct')) {
      context.handle(
        _cumPctMeta,
        cumPct.isAcceptableOrUnknown(data['cum_pct']!, _cumPctMeta),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('root')) {
      context.handle(
        _rootMeta,
        root.isAcceptableOrUnknown(data['root']!, _rootMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rank};
  @override
  WordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordRow(
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      freq: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}freq'],
      ),
      cumPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cum_pct'],
      ),
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      root: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root'],
      ),
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class WordRow extends DataClass implements Insertable<WordRow> {
  final int rank;
  final String word;
  final double? freq;
  final double? cumPct;
  final String? region;
  final String? root;
  const WordRow({
    required this.rank,
    required this.word,
    this.freq,
    this.cumPct,
    this.region,
    this.root,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rank'] = Variable<int>(rank);
    map['word'] = Variable<String>(word);
    if (!nullToAbsent || freq != null) {
      map['freq'] = Variable<double>(freq);
    }
    if (!nullToAbsent || cumPct != null) {
      map['cum_pct'] = Variable<double>(cumPct);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    if (!nullToAbsent || root != null) {
      map['root'] = Variable<String>(root);
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      rank: Value(rank),
      word: Value(word),
      freq: freq == null && nullToAbsent ? const Value.absent() : Value(freq),
      cumPct: cumPct == null && nullToAbsent
          ? const Value.absent()
          : Value(cumPct),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      root: root == null && nullToAbsent ? const Value.absent() : Value(root),
    );
  }

  factory WordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordRow(
      rank: serializer.fromJson<int>(json['rank']),
      word: serializer.fromJson<String>(json['word']),
      freq: serializer.fromJson<double?>(json['freq']),
      cumPct: serializer.fromJson<double?>(json['cumPct']),
      region: serializer.fromJson<String?>(json['region']),
      root: serializer.fromJson<String?>(json['root']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rank': serializer.toJson<int>(rank),
      'word': serializer.toJson<String>(word),
      'freq': serializer.toJson<double?>(freq),
      'cumPct': serializer.toJson<double?>(cumPct),
      'region': serializer.toJson<String?>(region),
      'root': serializer.toJson<String?>(root),
    };
  }

  WordRow copyWith({
    int? rank,
    String? word,
    Value<double?> freq = const Value.absent(),
    Value<double?> cumPct = const Value.absent(),
    Value<String?> region = const Value.absent(),
    Value<String?> root = const Value.absent(),
  }) => WordRow(
    rank: rank ?? this.rank,
    word: word ?? this.word,
    freq: freq.present ? freq.value : this.freq,
    cumPct: cumPct.present ? cumPct.value : this.cumPct,
    region: region.present ? region.value : this.region,
    root: root.present ? root.value : this.root,
  );
  WordRow copyWithCompanion(WordsCompanion data) {
    return WordRow(
      rank: data.rank.present ? data.rank.value : this.rank,
      word: data.word.present ? data.word.value : this.word,
      freq: data.freq.present ? data.freq.value : this.freq,
      cumPct: data.cumPct.present ? data.cumPct.value : this.cumPct,
      region: data.region.present ? data.region.value : this.region,
      root: data.root.present ? data.root.value : this.root,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordRow(')
          ..write('rank: $rank, ')
          ..write('word: $word, ')
          ..write('freq: $freq, ')
          ..write('cumPct: $cumPct, ')
          ..write('region: $region, ')
          ..write('root: $root')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rank, word, freq, cumPct, region, root);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordRow &&
          other.rank == this.rank &&
          other.word == this.word &&
          other.freq == this.freq &&
          other.cumPct == this.cumPct &&
          other.region == this.region &&
          other.root == this.root);
}

class WordsCompanion extends UpdateCompanion<WordRow> {
  final Value<int> rank;
  final Value<String> word;
  final Value<double?> freq;
  final Value<double?> cumPct;
  final Value<String?> region;
  final Value<String?> root;
  const WordsCompanion({
    this.rank = const Value.absent(),
    this.word = const Value.absent(),
    this.freq = const Value.absent(),
    this.cumPct = const Value.absent(),
    this.region = const Value.absent(),
    this.root = const Value.absent(),
  });
  WordsCompanion.insert({
    this.rank = const Value.absent(),
    required String word,
    this.freq = const Value.absent(),
    this.cumPct = const Value.absent(),
    this.region = const Value.absent(),
    this.root = const Value.absent(),
  }) : word = Value(word);
  static Insertable<WordRow> custom({
    Expression<int>? rank,
    Expression<String>? word,
    Expression<double>? freq,
    Expression<double>? cumPct,
    Expression<String>? region,
    Expression<String>? root,
  }) {
    return RawValuesInsertable({
      if (rank != null) 'rank': rank,
      if (word != null) 'word': word,
      if (freq != null) 'freq': freq,
      if (cumPct != null) 'cum_pct': cumPct,
      if (region != null) 'region': region,
      if (root != null) 'root': root,
    });
  }

  WordsCompanion copyWith({
    Value<int>? rank,
    Value<String>? word,
    Value<double?>? freq,
    Value<double?>? cumPct,
    Value<String?>? region,
    Value<String?>? root,
  }) {
    return WordsCompanion(
      rank: rank ?? this.rank,
      word: word ?? this.word,
      freq: freq ?? this.freq,
      cumPct: cumPct ?? this.cumPct,
      region: region ?? this.region,
      root: root ?? this.root,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (freq.present) {
      map['freq'] = Variable<double>(freq.value);
    }
    if (cumPct.present) {
      map['cum_pct'] = Variable<double>(cumPct.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (root.present) {
      map['root'] = Variable<String>(root.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('rank: $rank, ')
          ..write('word: $word, ')
          ..write('freq: $freq, ')
          ..write('cumPct: $cumPct, ')
          ..write('region: $region, ')
          ..write('root: $root')
          ..write(')'))
        .toString();
  }
}

class $AnnotationsTable extends Annotations
    with TableInfo<$AnnotationsTable, AnnotationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnotationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _turnIdMeta = const VerificationMeta('turnId');
  @override
  late final GeneratedColumn<int> turnId = GeneratedColumn<int>(
    'turn_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES turns (id)',
    ),
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shapeMeta = const VerificationMeta('shape');
  @override
  late final GeneratedColumn<String> shape = GeneratedColumn<String>(
    'shape',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('highlight'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('yellow'),
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<int> start = GeneratedColumn<int>(
    'start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<int> end = GeneratedColumn<int>(
    'end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    turnId,
    target,
    kind,
    shape,
    color,
    comment,
    start,
    end,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'annotations';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnnotationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('turn_id')) {
      context.handle(
        _turnIdMeta,
        turnId.isAcceptableOrUnknown(data['turn_id']!, _turnIdMeta),
      );
    } else if (isInserting) {
      context.missing(_turnIdMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('shape')) {
      context.handle(
        _shapeMeta,
        shape.isAcceptableOrUnknown(data['shape']!, _shapeMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnnotationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnnotationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      turnId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}turn_id'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      shape: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shape'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start'],
      ),
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end'],
      ),
    );
  }

  @override
  $AnnotationsTable createAlias(String alias) {
    return $AnnotationsTable(attachedDatabase, alias);
  }
}

class AnnotationRow extends DataClass implements Insertable<AnnotationRow> {
  final int id;
  final int turnId;
  final String target;
  final String kind;
  final String shape;
  final String color;
  final String? comment;
  final int? start;
  final int? end;
  const AnnotationRow({
    required this.id,
    required this.turnId,
    required this.target,
    required this.kind,
    required this.shape,
    required this.color,
    this.comment,
    this.start,
    this.end,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['turn_id'] = Variable<int>(turnId);
    map['target'] = Variable<String>(target);
    map['kind'] = Variable<String>(kind);
    map['shape'] = Variable<String>(shape);
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<int>(start);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<int>(end);
    }
    return map;
  }

  AnnotationsCompanion toCompanion(bool nullToAbsent) {
    return AnnotationsCompanion(
      id: Value(id),
      turnId: Value(turnId),
      target: Value(target),
      kind: Value(kind),
      shape: Value(shape),
      color: Value(color),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      start: start == null && nullToAbsent
          ? const Value.absent()
          : Value(start),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
    );
  }

  factory AnnotationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnnotationRow(
      id: serializer.fromJson<int>(json['id']),
      turnId: serializer.fromJson<int>(json['turnId']),
      target: serializer.fromJson<String>(json['target']),
      kind: serializer.fromJson<String>(json['kind']),
      shape: serializer.fromJson<String>(json['shape']),
      color: serializer.fromJson<String>(json['color']),
      comment: serializer.fromJson<String?>(json['comment']),
      start: serializer.fromJson<int?>(json['start']),
      end: serializer.fromJson<int?>(json['end']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'turnId': serializer.toJson<int>(turnId),
      'target': serializer.toJson<String>(target),
      'kind': serializer.toJson<String>(kind),
      'shape': serializer.toJson<String>(shape),
      'color': serializer.toJson<String>(color),
      'comment': serializer.toJson<String?>(comment),
      'start': serializer.toJson<int?>(start),
      'end': serializer.toJson<int?>(end),
    };
  }

  AnnotationRow copyWith({
    int? id,
    int? turnId,
    String? target,
    String? kind,
    String? shape,
    String? color,
    Value<String?> comment = const Value.absent(),
    Value<int?> start = const Value.absent(),
    Value<int?> end = const Value.absent(),
  }) => AnnotationRow(
    id: id ?? this.id,
    turnId: turnId ?? this.turnId,
    target: target ?? this.target,
    kind: kind ?? this.kind,
    shape: shape ?? this.shape,
    color: color ?? this.color,
    comment: comment.present ? comment.value : this.comment,
    start: start.present ? start.value : this.start,
    end: end.present ? end.value : this.end,
  );
  AnnotationRow copyWithCompanion(AnnotationsCompanion data) {
    return AnnotationRow(
      id: data.id.present ? data.id.value : this.id,
      turnId: data.turnId.present ? data.turnId.value : this.turnId,
      target: data.target.present ? data.target.value : this.target,
      kind: data.kind.present ? data.kind.value : this.kind,
      shape: data.shape.present ? data.shape.value : this.shape,
      color: data.color.present ? data.color.value : this.color,
      comment: data.comment.present ? data.comment.value : this.comment,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnnotationRow(')
          ..write('id: $id, ')
          ..write('turnId: $turnId, ')
          ..write('target: $target, ')
          ..write('kind: $kind, ')
          ..write('shape: $shape, ')
          ..write('color: $color, ')
          ..write('comment: $comment, ')
          ..write('start: $start, ')
          ..write('end: $end')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, turnId, target, kind, shape, color, comment, start, end);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnnotationRow &&
          other.id == this.id &&
          other.turnId == this.turnId &&
          other.target == this.target &&
          other.kind == this.kind &&
          other.shape == this.shape &&
          other.color == this.color &&
          other.comment == this.comment &&
          other.start == this.start &&
          other.end == this.end);
}

class AnnotationsCompanion extends UpdateCompanion<AnnotationRow> {
  final Value<int> id;
  final Value<int> turnId;
  final Value<String> target;
  final Value<String> kind;
  final Value<String> shape;
  final Value<String> color;
  final Value<String?> comment;
  final Value<int?> start;
  final Value<int?> end;
  const AnnotationsCompanion({
    this.id = const Value.absent(),
    this.turnId = const Value.absent(),
    this.target = const Value.absent(),
    this.kind = const Value.absent(),
    this.shape = const Value.absent(),
    this.color = const Value.absent(),
    this.comment = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
  });
  AnnotationsCompanion.insert({
    this.id = const Value.absent(),
    required int turnId,
    required String target,
    required String kind,
    this.shape = const Value.absent(),
    this.color = const Value.absent(),
    this.comment = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
  }) : turnId = Value(turnId),
       target = Value(target),
       kind = Value(kind);
  static Insertable<AnnotationRow> custom({
    Expression<int>? id,
    Expression<int>? turnId,
    Expression<String>? target,
    Expression<String>? kind,
    Expression<String>? shape,
    Expression<String>? color,
    Expression<String>? comment,
    Expression<int>? start,
    Expression<int>? end,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (turnId != null) 'turn_id': turnId,
      if (target != null) 'target': target,
      if (kind != null) 'kind': kind,
      if (shape != null) 'shape': shape,
      if (color != null) 'color': color,
      if (comment != null) 'comment': comment,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
    });
  }

  AnnotationsCompanion copyWith({
    Value<int>? id,
    Value<int>? turnId,
    Value<String>? target,
    Value<String>? kind,
    Value<String>? shape,
    Value<String>? color,
    Value<String?>? comment,
    Value<int?>? start,
    Value<int?>? end,
  }) {
    return AnnotationsCompanion(
      id: id ?? this.id,
      turnId: turnId ?? this.turnId,
      target: target ?? this.target,
      kind: kind ?? this.kind,
      shape: shape ?? this.shape,
      color: color ?? this.color,
      comment: comment ?? this.comment,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (turnId.present) {
      map['turn_id'] = Variable<int>(turnId.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (shape.present) {
      map['shape'] = Variable<String>(shape.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (start.present) {
      map['start'] = Variable<int>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<int>(end.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnotationsCompanion(')
          ..write('id: $id, ')
          ..write('turnId: $turnId, ')
          ..write('target: $target, ')
          ..write('kind: $kind, ')
          ..write('shape: $shape, ')
          ..write('color: $color, ')
          ..write('comment: $comment, ')
          ..write('start: $start, ')
          ..write('end: $end')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _turnIdMeta = const VerificationMeta('turnId');
  @override
  late final GeneratedColumn<int> turnId = GeneratedColumn<int>(
    'turn_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES turns (id)',
    ),
  );
  static const VerificationMeta _learnedMeta = const VerificationMeta(
    'learned',
  );
  @override
  late final GeneratedColumn<bool> learned = GeneratedColumn<bool>(
    'learned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("learned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastReviewedMeta = const VerificationMeta(
    'lastReviewed',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewed = GeneratedColumn<DateTime>(
    'last_reviewed',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewCountMeta = const VerificationMeta(
    'reviewCount',
  );
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
    'review_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    turnId,
    learned,
    favorite,
    lastReviewed,
    reviewCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('turn_id')) {
      context.handle(
        _turnIdMeta,
        turnId.isAcceptableOrUnknown(data['turn_id']!, _turnIdMeta),
      );
    }
    if (data.containsKey('learned')) {
      context.handle(
        _learnedMeta,
        learned.isAcceptableOrUnknown(data['learned']!, _learnedMeta),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('last_reviewed')) {
      context.handle(
        _lastReviewedMeta,
        lastReviewed.isAcceptableOrUnknown(
          data['last_reviewed']!,
          _lastReviewedMeta,
        ),
      );
    }
    if (data.containsKey('review_count')) {
      context.handle(
        _reviewCountMeta,
        reviewCount.isAcceptableOrUnknown(
          data['review_count']!,
          _reviewCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {turnId};
  @override
  UserProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressRow(
      turnId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}turn_id'],
      )!,
      learned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}learned'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
      lastReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed'],
      ),
      reviewCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_count'],
      )!,
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressRow extends DataClass implements Insertable<UserProgressRow> {
  final int turnId;
  final bool learned;
  final bool favorite;
  final DateTime? lastReviewed;
  final int reviewCount;
  const UserProgressRow({
    required this.turnId,
    required this.learned,
    required this.favorite,
    this.lastReviewed,
    required this.reviewCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['turn_id'] = Variable<int>(turnId);
    map['learned'] = Variable<bool>(learned);
    map['favorite'] = Variable<bool>(favorite);
    if (!nullToAbsent || lastReviewed != null) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed);
    }
    map['review_count'] = Variable<int>(reviewCount);
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      turnId: Value(turnId),
      learned: Value(learned),
      favorite: Value(favorite),
      lastReviewed: lastReviewed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewed),
      reviewCount: Value(reviewCount),
    );
  }

  factory UserProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressRow(
      turnId: serializer.fromJson<int>(json['turnId']),
      learned: serializer.fromJson<bool>(json['learned']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      lastReviewed: serializer.fromJson<DateTime?>(json['lastReviewed']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'turnId': serializer.toJson<int>(turnId),
      'learned': serializer.toJson<bool>(learned),
      'favorite': serializer.toJson<bool>(favorite),
      'lastReviewed': serializer.toJson<DateTime?>(lastReviewed),
      'reviewCount': serializer.toJson<int>(reviewCount),
    };
  }

  UserProgressRow copyWith({
    int? turnId,
    bool? learned,
    bool? favorite,
    Value<DateTime?> lastReviewed = const Value.absent(),
    int? reviewCount,
  }) => UserProgressRow(
    turnId: turnId ?? this.turnId,
    learned: learned ?? this.learned,
    favorite: favorite ?? this.favorite,
    lastReviewed: lastReviewed.present ? lastReviewed.value : this.lastReviewed,
    reviewCount: reviewCount ?? this.reviewCount,
  );
  UserProgressRow copyWithCompanion(UserProgressCompanion data) {
    return UserProgressRow(
      turnId: data.turnId.present ? data.turnId.value : this.turnId,
      learned: data.learned.present ? data.learned.value : this.learned,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      lastReviewed: data.lastReviewed.present
          ? data.lastReviewed.value
          : this.lastReviewed,
      reviewCount: data.reviewCount.present
          ? data.reviewCount.value
          : this.reviewCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressRow(')
          ..write('turnId: $turnId, ')
          ..write('learned: $learned, ')
          ..write('favorite: $favorite, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('reviewCount: $reviewCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(turnId, learned, favorite, lastReviewed, reviewCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressRow &&
          other.turnId == this.turnId &&
          other.learned == this.learned &&
          other.favorite == this.favorite &&
          other.lastReviewed == this.lastReviewed &&
          other.reviewCount == this.reviewCount);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressRow> {
  final Value<int> turnId;
  final Value<bool> learned;
  final Value<bool> favorite;
  final Value<DateTime?> lastReviewed;
  final Value<int> reviewCount;
  const UserProgressCompanion({
    this.turnId = const Value.absent(),
    this.learned = const Value.absent(),
    this.favorite = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.reviewCount = const Value.absent(),
  });
  UserProgressCompanion.insert({
    this.turnId = const Value.absent(),
    this.learned = const Value.absent(),
    this.favorite = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.reviewCount = const Value.absent(),
  });
  static Insertable<UserProgressRow> custom({
    Expression<int>? turnId,
    Expression<bool>? learned,
    Expression<bool>? favorite,
    Expression<DateTime>? lastReviewed,
    Expression<int>? reviewCount,
  }) {
    return RawValuesInsertable({
      if (turnId != null) 'turn_id': turnId,
      if (learned != null) 'learned': learned,
      if (favorite != null) 'favorite': favorite,
      if (lastReviewed != null) 'last_reviewed': lastReviewed,
      if (reviewCount != null) 'review_count': reviewCount,
    });
  }

  UserProgressCompanion copyWith({
    Value<int>? turnId,
    Value<bool>? learned,
    Value<bool>? favorite,
    Value<DateTime?>? lastReviewed,
    Value<int>? reviewCount,
  }) {
    return UserProgressCompanion(
      turnId: turnId ?? this.turnId,
      learned: learned ?? this.learned,
      favorite: favorite ?? this.favorite,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (turnId.present) {
      map['turn_id'] = Variable<int>(turnId.value);
    }
    if (learned.present) {
      map['learned'] = Variable<bool>(learned.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (lastReviewed.present) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('turnId: $turnId, ')
          ..write('learned: $learned, ')
          ..write('favorite: $favorite, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('reviewCount: $reviewCount')
          ..write(')'))
        .toString();
  }
}

class $RootProgressTable extends RootProgress
    with TableInfo<$RootProgressTable, RootProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RootProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rootMeta = const VerificationMeta('root');
  @override
  late final GeneratedColumn<String> root = GeneratedColumn<String>(
    'root',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES roots (root)',
    ),
  );
  static const VerificationMeta _knownMeta = const VerificationMeta('known');
  @override
  late final GeneratedColumn<bool> known = GeneratedColumn<bool>(
    'known',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("known" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _exposureCountMeta = const VerificationMeta(
    'exposureCount',
  );
  @override
  late final GeneratedColumn<int> exposureCount = GeneratedColumn<int>(
    'exposure_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewedMeta = const VerificationMeta(
    'lastReviewed',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewed = GeneratedColumn<DateTime>(
    'last_reviewed',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    root,
    known,
    exposureCount,
    lastReviewed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'root_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<RootProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('root')) {
      context.handle(
        _rootMeta,
        root.isAcceptableOrUnknown(data['root']!, _rootMeta),
      );
    } else if (isInserting) {
      context.missing(_rootMeta);
    }
    if (data.containsKey('known')) {
      context.handle(
        _knownMeta,
        known.isAcceptableOrUnknown(data['known']!, _knownMeta),
      );
    }
    if (data.containsKey('exposure_count')) {
      context.handle(
        _exposureCountMeta,
        exposureCount.isAcceptableOrUnknown(
          data['exposure_count']!,
          _exposureCountMeta,
        ),
      );
    }
    if (data.containsKey('last_reviewed')) {
      context.handle(
        _lastReviewedMeta,
        lastReviewed.isAcceptableOrUnknown(
          data['last_reviewed']!,
          _lastReviewedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {root};
  @override
  RootProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RootProgressRow(
      root: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root'],
      )!,
      known: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}known'],
      )!,
      exposureCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exposure_count'],
      )!,
      lastReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed'],
      ),
    );
  }

  @override
  $RootProgressTable createAlias(String alias) {
    return $RootProgressTable(attachedDatabase, alias);
  }
}

class RootProgressRow extends DataClass implements Insertable<RootProgressRow> {
  final String root;
  final bool known;
  final int exposureCount;
  final DateTime? lastReviewed;
  const RootProgressRow({
    required this.root,
    required this.known,
    required this.exposureCount,
    this.lastReviewed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['root'] = Variable<String>(root);
    map['known'] = Variable<bool>(known);
    map['exposure_count'] = Variable<int>(exposureCount);
    if (!nullToAbsent || lastReviewed != null) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed);
    }
    return map;
  }

  RootProgressCompanion toCompanion(bool nullToAbsent) {
    return RootProgressCompanion(
      root: Value(root),
      known: Value(known),
      exposureCount: Value(exposureCount),
      lastReviewed: lastReviewed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewed),
    );
  }

  factory RootProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RootProgressRow(
      root: serializer.fromJson<String>(json['root']),
      known: serializer.fromJson<bool>(json['known']),
      exposureCount: serializer.fromJson<int>(json['exposureCount']),
      lastReviewed: serializer.fromJson<DateTime?>(json['lastReviewed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'root': serializer.toJson<String>(root),
      'known': serializer.toJson<bool>(known),
      'exposureCount': serializer.toJson<int>(exposureCount),
      'lastReviewed': serializer.toJson<DateTime?>(lastReviewed),
    };
  }

  RootProgressRow copyWith({
    String? root,
    bool? known,
    int? exposureCount,
    Value<DateTime?> lastReviewed = const Value.absent(),
  }) => RootProgressRow(
    root: root ?? this.root,
    known: known ?? this.known,
    exposureCount: exposureCount ?? this.exposureCount,
    lastReviewed: lastReviewed.present ? lastReviewed.value : this.lastReviewed,
  );
  RootProgressRow copyWithCompanion(RootProgressCompanion data) {
    return RootProgressRow(
      root: data.root.present ? data.root.value : this.root,
      known: data.known.present ? data.known.value : this.known,
      exposureCount: data.exposureCount.present
          ? data.exposureCount.value
          : this.exposureCount,
      lastReviewed: data.lastReviewed.present
          ? data.lastReviewed.value
          : this.lastReviewed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RootProgressRow(')
          ..write('root: $root, ')
          ..write('known: $known, ')
          ..write('exposureCount: $exposureCount, ')
          ..write('lastReviewed: $lastReviewed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(root, known, exposureCount, lastReviewed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RootProgressRow &&
          other.root == this.root &&
          other.known == this.known &&
          other.exposureCount == this.exposureCount &&
          other.lastReviewed == this.lastReviewed);
}

class RootProgressCompanion extends UpdateCompanion<RootProgressRow> {
  final Value<String> root;
  final Value<bool> known;
  final Value<int> exposureCount;
  final Value<DateTime?> lastReviewed;
  final Value<int> rowid;
  const RootProgressCompanion({
    this.root = const Value.absent(),
    this.known = const Value.absent(),
    this.exposureCount = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RootProgressCompanion.insert({
    required String root,
    this.known = const Value.absent(),
    this.exposureCount = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : root = Value(root);
  static Insertable<RootProgressRow> custom({
    Expression<String>? root,
    Expression<bool>? known,
    Expression<int>? exposureCount,
    Expression<DateTime>? lastReviewed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (root != null) 'root': root,
      if (known != null) 'known': known,
      if (exposureCount != null) 'exposure_count': exposureCount,
      if (lastReviewed != null) 'last_reviewed': lastReviewed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RootProgressCompanion copyWith({
    Value<String>? root,
    Value<bool>? known,
    Value<int>? exposureCount,
    Value<DateTime?>? lastReviewed,
    Value<int>? rowid,
  }) {
    return RootProgressCompanion(
      root: root ?? this.root,
      known: known ?? this.known,
      exposureCount: exposureCount ?? this.exposureCount,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (root.present) {
      map['root'] = Variable<String>(root.value);
    }
    if (known.present) {
      map['known'] = Variable<bool>(known.value);
    }
    if (exposureCount.present) {
      map['exposure_count'] = Variable<int>(exposureCount.value);
    }
    if (lastReviewed.present) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RootProgressCompanion(')
          ..write('root: $root, ')
          ..write('known: $known, ')
          ..write('exposureCount: $exposureCount, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserMemosTable extends UserMemos
    with TableInfo<$UserMemosTable, UserMemoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserMemosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contextMeta = const VerificationMeta(
    'context',
  );
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
    'context',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, context, body, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_memos';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserMemoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('context')) {
      context.handle(
        _contextMeta,
        this.context.isAcceptableOrUnknown(data['context']!, _contextMeta),
      );
    } else if (isInserting) {
      context.missing(_contextMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserMemoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserMemoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      context: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserMemosTable createAlias(String alias) {
    return $UserMemosTable(attachedDatabase, alias);
  }
}

class UserMemoRow extends DataClass implements Insertable<UserMemoRow> {
  final int id;
  final String context;
  final String body;
  final DateTime createdAt;
  const UserMemoRow({
    required this.id,
    required this.context,
    required this.body,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['context'] = Variable<String>(context);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserMemosCompanion toCompanion(bool nullToAbsent) {
    return UserMemosCompanion(
      id: Value(id),
      context: Value(context),
      body: Value(body),
      createdAt: Value(createdAt),
    );
  }

  factory UserMemoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserMemoRow(
      id: serializer.fromJson<int>(json['id']),
      context: serializer.fromJson<String>(json['context']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'context': serializer.toJson<String>(context),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserMemoRow copyWith({
    int? id,
    String? context,
    String? body,
    DateTime? createdAt,
  }) => UserMemoRow(
    id: id ?? this.id,
    context: context ?? this.context,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
  );
  UserMemoRow copyWithCompanion(UserMemosCompanion data) {
    return UserMemoRow(
      id: data.id.present ? data.id.value : this.id,
      context: data.context.present ? data.context.value : this.context,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserMemoRow(')
          ..write('id: $id, ')
          ..write('context: $context, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, context, body, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserMemoRow &&
          other.id == this.id &&
          other.context == this.context &&
          other.body == this.body &&
          other.createdAt == this.createdAt);
}

class UserMemosCompanion extends UpdateCompanion<UserMemoRow> {
  final Value<int> id;
  final Value<String> context;
  final Value<String> body;
  final Value<DateTime> createdAt;
  const UserMemosCompanion({
    this.id = const Value.absent(),
    this.context = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserMemosCompanion.insert({
    this.id = const Value.absent(),
    required String context,
    required String body,
    this.createdAt = const Value.absent(),
  }) : context = Value(context),
       body = Value(body);
  static Insertable<UserMemoRow> custom({
    Expression<int>? id,
    Expression<String>? context,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (context != null) 'context': context,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserMemosCompanion copyWith({
    Value<int>? id,
    Value<String>? context,
    Value<String>? body,
    Value<DateTime>? createdAt,
  }) {
    return UserMemosCompanion(
      id: id ?? this.id,
      context: context ?? this.context,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserMemosCompanion(')
          ..write('id: $id, ')
          ..write('context: $context, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TurnsTable turns = $TurnsTable(this);
  late final $RootsTable roots = $RootsTable(this);
  late final $AffixesTable affixes = $AffixesTable(this);
  late final $WordsTable words = $WordsTable(this);
  late final $AnnotationsTable annotations = $AnnotationsTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $RootProgressTable rootProgress = $RootProgressTable(this);
  late final $UserMemosTable userMemos = $UserMemosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    turns,
    roots,
    affixes,
    words,
    annotations,
    userProgress,
    rootProgress,
    userMemos,
  ];
}

typedef $$TurnsTableCreateCompanionBuilder =
    TurnsCompanion Function({
      Value<int> id,
      required String level,
      Value<String> variant,
      Value<String?> episodeId,
      required int num,
      required String speaker,
      required String body,
      Value<String?> ms,
      Value<String?> ko,
      Value<String?> gloss,
      Value<String?> note,
      Value<String?> tagsJson,
    });
typedef $$TurnsTableUpdateCompanionBuilder =
    TurnsCompanion Function({
      Value<int> id,
      Value<String> level,
      Value<String> variant,
      Value<String?> episodeId,
      Value<int> num,
      Value<String> speaker,
      Value<String> body,
      Value<String?> ms,
      Value<String?> ko,
      Value<String?> gloss,
      Value<String?> note,
      Value<String?> tagsJson,
    });

final class $$TurnsTableReferences
    extends BaseReferences<_$AppDatabase, $TurnsTable, TurnRow> {
  $$TurnsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AnnotationsTable, List<AnnotationRow>>
  _annotationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.annotations,
    aliasName: $_aliasNameGenerator(db.turns.id, db.annotations.turnId),
  );

  $$AnnotationsTableProcessedTableManager get annotationsRefs {
    final manager = $$AnnotationsTableTableManager(
      $_db,
      $_db.annotations,
    ).filter((f) => f.turnId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_annotationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserProgressTable, List<UserProgressRow>>
  _userProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userProgress,
    aliasName: $_aliasNameGenerator(db.turns.id, db.userProgress.turnId),
  );

  $$UserProgressTableProcessedTableManager get userProgressRefs {
    final manager = $$UserProgressTableTableManager(
      $_db,
      $_db.userProgress,
    ).filter((f) => f.turnId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TurnsTableFilterComposer extends Composer<_$AppDatabase, $TurnsTable> {
  $$TurnsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get num => $composableBuilder(
    column: $table.num,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ms => $composableBuilder(
    column: $table.ms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ko => $composableBuilder(
    column: $table.ko,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gloss => $composableBuilder(
    column: $table.gloss,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> annotationsRefs(
    Expression<bool> Function($$AnnotationsTableFilterComposer f) f,
  ) {
    final $$AnnotationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotations,
      getReferencedColumn: (t) => t.turnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableFilterComposer(
            $db: $db,
            $table: $db.annotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userProgressRefs(
    Expression<bool> Function($$UserProgressTableFilterComposer f) f,
  ) {
    final $$UserProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProgress,
      getReferencedColumn: (t) => t.turnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProgressTableFilterComposer(
            $db: $db,
            $table: $db.userProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TurnsTableOrderingComposer
    extends Composer<_$AppDatabase, $TurnsTable> {
  $$TurnsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get num => $composableBuilder(
    column: $table.num,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ms => $composableBuilder(
    column: $table.ms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ko => $composableBuilder(
    column: $table.ko,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gloss => $composableBuilder(
    column: $table.gloss,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TurnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TurnsTable> {
  $$TurnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get variant =>
      $composableBuilder(column: $table.variant, builder: (column) => column);

  GeneratedColumn<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<int> get num =>
      $composableBuilder(column: $table.num, builder: (column) => column);

  GeneratedColumn<String> get speaker =>
      $composableBuilder(column: $table.speaker, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get ms =>
      $composableBuilder(column: $table.ms, builder: (column) => column);

  GeneratedColumn<String> get ko =>
      $composableBuilder(column: $table.ko, builder: (column) => column);

  GeneratedColumn<String> get gloss =>
      $composableBuilder(column: $table.gloss, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  Expression<T> annotationsRefs<T extends Object>(
    Expression<T> Function($$AnnotationsTableAnnotationComposer a) f,
  ) {
    final $$AnnotationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotations,
      getReferencedColumn: (t) => t.turnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableAnnotationComposer(
            $db: $db,
            $table: $db.annotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userProgressRefs<T extends Object>(
    Expression<T> Function($$UserProgressTableAnnotationComposer a) f,
  ) {
    final $$UserProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProgress,
      getReferencedColumn: (t) => t.turnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.userProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TurnsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TurnsTable,
          TurnRow,
          $$TurnsTableFilterComposer,
          $$TurnsTableOrderingComposer,
          $$TurnsTableAnnotationComposer,
          $$TurnsTableCreateCompanionBuilder,
          $$TurnsTableUpdateCompanionBuilder,
          (TurnRow, $$TurnsTableReferences),
          TurnRow,
          PrefetchHooks Function({bool annotationsRefs, bool userProgressRefs})
        > {
  $$TurnsTableTableManager(_$AppDatabase db, $TurnsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TurnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TurnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TurnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> variant = const Value.absent(),
                Value<String?> episodeId = const Value.absent(),
                Value<int> num = const Value.absent(),
                Value<String> speaker = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> ms = const Value.absent(),
                Value<String?> ko = const Value.absent(),
                Value<String?> gloss = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> tagsJson = const Value.absent(),
              }) => TurnsCompanion(
                id: id,
                level: level,
                variant: variant,
                episodeId: episodeId,
                num: num,
                speaker: speaker,
                body: body,
                ms: ms,
                ko: ko,
                gloss: gloss,
                note: note,
                tagsJson: tagsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String level,
                Value<String> variant = const Value.absent(),
                Value<String?> episodeId = const Value.absent(),
                required int num,
                required String speaker,
                required String body,
                Value<String?> ms = const Value.absent(),
                Value<String?> ko = const Value.absent(),
                Value<String?> gloss = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> tagsJson = const Value.absent(),
              }) => TurnsCompanion.insert(
                id: id,
                level: level,
                variant: variant,
                episodeId: episodeId,
                num: num,
                speaker: speaker,
                body: body,
                ms: ms,
                ko: ko,
                gloss: gloss,
                note: note,
                tagsJson: tagsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TurnsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({annotationsRefs = false, userProgressRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (annotationsRefs) db.annotations,
                    if (userProgressRefs) db.userProgress,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (annotationsRefs)
                        await $_getPrefetchedData<
                          TurnRow,
                          $TurnsTable,
                          AnnotationRow
                        >(
                          currentTable: table,
                          referencedTable: $$TurnsTableReferences
                              ._annotationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TurnsTableReferences(
                                db,
                                table,
                                p0,
                              ).annotationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.turnId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userProgressRefs)
                        await $_getPrefetchedData<
                          TurnRow,
                          $TurnsTable,
                          UserProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$TurnsTableReferences
                              ._userProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TurnsTableReferences(
                                db,
                                table,
                                p0,
                              ).userProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.turnId == item.id,
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

typedef $$TurnsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TurnsTable,
      TurnRow,
      $$TurnsTableFilterComposer,
      $$TurnsTableOrderingComposer,
      $$TurnsTableAnnotationComposer,
      $$TurnsTableCreateCompanionBuilder,
      $$TurnsTableUpdateCompanionBuilder,
      (TurnRow, $$TurnsTableReferences),
      TurnRow,
      PrefetchHooks Function({bool annotationsRefs, bool userProgressRefs})
    >;
typedef $$RootsTableCreateCompanionBuilder =
    RootsCompanion Function({
      required String root,
      Value<int?> rank,
      Value<int?> freq,
      Value<String?> pos,
      Value<int?> phase,
      Value<String?> meaningKo,
      Value<String?> msForm,
      Value<String?> familyJson,
      Value<int> rowid,
    });
typedef $$RootsTableUpdateCompanionBuilder =
    RootsCompanion Function({
      Value<String> root,
      Value<int?> rank,
      Value<int?> freq,
      Value<String?> pos,
      Value<int?> phase,
      Value<String?> meaningKo,
      Value<String?> msForm,
      Value<String?> familyJson,
      Value<int> rowid,
    });

final class $$RootsTableReferences
    extends BaseReferences<_$AppDatabase, $RootsTable, RootRow> {
  $$RootsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RootProgressTable, List<RootProgressRow>>
  _rootProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rootProgress,
    aliasName: $_aliasNameGenerator(db.roots.root, db.rootProgress.root),
  );

  $$RootProgressTableProcessedTableManager get rootProgressRefs {
    final manager = $$RootProgressTableTableManager(
      $_db,
      $_db.rootProgress,
    ).filter((f) => f.root.root.sqlEquals($_itemColumn<String>('root')!));

    final cache = $_typedResult.readTableOrNull(_rootProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RootsTableFilterComposer extends Composer<_$AppDatabase, $RootsTable> {
  $$RootsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get root => $composableBuilder(
    column: $table.root,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freq => $composableBuilder(
    column: $table.freq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningKo => $composableBuilder(
    column: $table.meaningKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get msForm => $composableBuilder(
    column: $table.msForm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyJson => $composableBuilder(
    column: $table.familyJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> rootProgressRefs(
    Expression<bool> Function($$RootProgressTableFilterComposer f) f,
  ) {
    final $$RootProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.root,
      referencedTable: $db.rootProgress,
      getReferencedColumn: (t) => t.root,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootProgressTableFilterComposer(
            $db: $db,
            $table: $db.rootProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RootsTableOrderingComposer
    extends Composer<_$AppDatabase, $RootsTable> {
  $$RootsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get root => $composableBuilder(
    column: $table.root,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freq => $composableBuilder(
    column: $table.freq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningKo => $composableBuilder(
    column: $table.meaningKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get msForm => $composableBuilder(
    column: $table.msForm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyJson => $composableBuilder(
    column: $table.familyJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RootsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RootsTable> {
  $$RootsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get root =>
      $composableBuilder(column: $table.root, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<int> get freq =>
      $composableBuilder(column: $table.freq, builder: (column) => column);

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<int> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get meaningKo =>
      $composableBuilder(column: $table.meaningKo, builder: (column) => column);

  GeneratedColumn<String> get msForm =>
      $composableBuilder(column: $table.msForm, builder: (column) => column);

  GeneratedColumn<String> get familyJson => $composableBuilder(
    column: $table.familyJson,
    builder: (column) => column,
  );

  Expression<T> rootProgressRefs<T extends Object>(
    Expression<T> Function($$RootProgressTableAnnotationComposer a) f,
  ) {
    final $$RootProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.root,
      referencedTable: $db.rootProgress,
      getReferencedColumn: (t) => t.root,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.rootProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RootsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RootsTable,
          RootRow,
          $$RootsTableFilterComposer,
          $$RootsTableOrderingComposer,
          $$RootsTableAnnotationComposer,
          $$RootsTableCreateCompanionBuilder,
          $$RootsTableUpdateCompanionBuilder,
          (RootRow, $$RootsTableReferences),
          RootRow,
          PrefetchHooks Function({bool rootProgressRefs})
        > {
  $$RootsTableTableManager(_$AppDatabase db, $RootsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RootsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RootsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RootsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> root = const Value.absent(),
                Value<int?> rank = const Value.absent(),
                Value<int?> freq = const Value.absent(),
                Value<String?> pos = const Value.absent(),
                Value<int?> phase = const Value.absent(),
                Value<String?> meaningKo = const Value.absent(),
                Value<String?> msForm = const Value.absent(),
                Value<String?> familyJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RootsCompanion(
                root: root,
                rank: rank,
                freq: freq,
                pos: pos,
                phase: phase,
                meaningKo: meaningKo,
                msForm: msForm,
                familyJson: familyJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String root,
                Value<int?> rank = const Value.absent(),
                Value<int?> freq = const Value.absent(),
                Value<String?> pos = const Value.absent(),
                Value<int?> phase = const Value.absent(),
                Value<String?> meaningKo = const Value.absent(),
                Value<String?> msForm = const Value.absent(),
                Value<String?> familyJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RootsCompanion.insert(
                root: root,
                rank: rank,
                freq: freq,
                pos: pos,
                phase: phase,
                meaningKo: meaningKo,
                msForm: msForm,
                familyJson: familyJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RootsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({rootProgressRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (rootProgressRefs) db.rootProgress],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (rootProgressRefs)
                    await $_getPrefetchedData<
                      RootRow,
                      $RootsTable,
                      RootProgressRow
                    >(
                      currentTable: table,
                      referencedTable: $$RootsTableReferences
                          ._rootProgressRefsTable(db),
                      managerFromTypedResult: (p0) => $$RootsTableReferences(
                        db,
                        table,
                        p0,
                      ).rootProgressRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.root == item.root),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RootsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RootsTable,
      RootRow,
      $$RootsTableFilterComposer,
      $$RootsTableOrderingComposer,
      $$RootsTableAnnotationComposer,
      $$RootsTableCreateCompanionBuilder,
      $$RootsTableUpdateCompanionBuilder,
      (RootRow, $$RootsTableReferences),
      RootRow,
      PrefetchHooks Function({bool rootProgressRefs})
    >;
typedef $$AffixesTableCreateCompanionBuilder =
    AffixesCompanion Function({
      Value<int> id,
      required String form,
      required String kind,
      required String position,
      Value<String?> meaningKo,
      Value<String?> allomorphs,
      Value<String?> examplesJson,
    });
typedef $$AffixesTableUpdateCompanionBuilder =
    AffixesCompanion Function({
      Value<int> id,
      Value<String> form,
      Value<String> kind,
      Value<String> position,
      Value<String?> meaningKo,
      Value<String?> allomorphs,
      Value<String?> examplesJson,
    });

class $$AffixesTableFilterComposer
    extends Composer<_$AppDatabase, $AffixesTable> {
  $$AffixesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningKo => $composableBuilder(
    column: $table.meaningKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allomorphs => $composableBuilder(
    column: $table.allomorphs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examplesJson => $composableBuilder(
    column: $table.examplesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AffixesTableOrderingComposer
    extends Composer<_$AppDatabase, $AffixesTable> {
  $$AffixesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningKo => $composableBuilder(
    column: $table.meaningKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allomorphs => $composableBuilder(
    column: $table.allomorphs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examplesJson => $composableBuilder(
    column: $table.examplesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AffixesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AffixesTable> {
  $$AffixesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get meaningKo =>
      $composableBuilder(column: $table.meaningKo, builder: (column) => column);

  GeneratedColumn<String> get allomorphs => $composableBuilder(
    column: $table.allomorphs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get examplesJson => $composableBuilder(
    column: $table.examplesJson,
    builder: (column) => column,
  );
}

class $$AffixesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AffixesTable,
          AffixRow,
          $$AffixesTableFilterComposer,
          $$AffixesTableOrderingComposer,
          $$AffixesTableAnnotationComposer,
          $$AffixesTableCreateCompanionBuilder,
          $$AffixesTableUpdateCompanionBuilder,
          (AffixRow, BaseReferences<_$AppDatabase, $AffixesTable, AffixRow>),
          AffixRow,
          PrefetchHooks Function()
        > {
  $$AffixesTableTableManager(_$AppDatabase db, $AffixesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AffixesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AffixesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AffixesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> form = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> position = const Value.absent(),
                Value<String?> meaningKo = const Value.absent(),
                Value<String?> allomorphs = const Value.absent(),
                Value<String?> examplesJson = const Value.absent(),
              }) => AffixesCompanion(
                id: id,
                form: form,
                kind: kind,
                position: position,
                meaningKo: meaningKo,
                allomorphs: allomorphs,
                examplesJson: examplesJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String form,
                required String kind,
                required String position,
                Value<String?> meaningKo = const Value.absent(),
                Value<String?> allomorphs = const Value.absent(),
                Value<String?> examplesJson = const Value.absent(),
              }) => AffixesCompanion.insert(
                id: id,
                form: form,
                kind: kind,
                position: position,
                meaningKo: meaningKo,
                allomorphs: allomorphs,
                examplesJson: examplesJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AffixesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AffixesTable,
      AffixRow,
      $$AffixesTableFilterComposer,
      $$AffixesTableOrderingComposer,
      $$AffixesTableAnnotationComposer,
      $$AffixesTableCreateCompanionBuilder,
      $$AffixesTableUpdateCompanionBuilder,
      (AffixRow, BaseReferences<_$AppDatabase, $AffixesTable, AffixRow>),
      AffixRow,
      PrefetchHooks Function()
    >;
typedef $$WordsTableCreateCompanionBuilder =
    WordsCompanion Function({
      Value<int> rank,
      required String word,
      Value<double?> freq,
      Value<double?> cumPct,
      Value<String?> region,
      Value<String?> root,
    });
typedef $$WordsTableUpdateCompanionBuilder =
    WordsCompanion Function({
      Value<int> rank,
      Value<String> word,
      Value<double?> freq,
      Value<double?> cumPct,
      Value<String?> region,
      Value<String?> root,
    });

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get freq => $composableBuilder(
    column: $table.freq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cumPct => $composableBuilder(
    column: $table.cumPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get root => $composableBuilder(
    column: $table.root,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get freq => $composableBuilder(
    column: $table.freq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cumPct => $composableBuilder(
    column: $table.cumPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get root => $composableBuilder(
    column: $table.root,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<double> get freq =>
      $composableBuilder(column: $table.freq, builder: (column) => column);

  GeneratedColumn<double> get cumPct =>
      $composableBuilder(column: $table.cumPct, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get root =>
      $composableBuilder(column: $table.root, builder: (column) => column);
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTable,
          WordRow,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (WordRow, BaseReferences<_$AppDatabase, $WordsTable, WordRow>),
          WordRow,
          PrefetchHooks Function()
        > {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rank = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<double?> freq = const Value.absent(),
                Value<double?> cumPct = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> root = const Value.absent(),
              }) => WordsCompanion(
                rank: rank,
                word: word,
                freq: freq,
                cumPct: cumPct,
                region: region,
                root: root,
              ),
          createCompanionCallback:
              ({
                Value<int> rank = const Value.absent(),
                required String word,
                Value<double?> freq = const Value.absent(),
                Value<double?> cumPct = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> root = const Value.absent(),
              }) => WordsCompanion.insert(
                rank: rank,
                word: word,
                freq: freq,
                cumPct: cumPct,
                region: region,
                root: root,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTable,
      WordRow,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (WordRow, BaseReferences<_$AppDatabase, $WordsTable, WordRow>),
      WordRow,
      PrefetchHooks Function()
    >;
typedef $$AnnotationsTableCreateCompanionBuilder =
    AnnotationsCompanion Function({
      Value<int> id,
      required int turnId,
      required String target,
      required String kind,
      Value<String> shape,
      Value<String> color,
      Value<String?> comment,
      Value<int?> start,
      Value<int?> end,
    });
typedef $$AnnotationsTableUpdateCompanionBuilder =
    AnnotationsCompanion Function({
      Value<int> id,
      Value<int> turnId,
      Value<String> target,
      Value<String> kind,
      Value<String> shape,
      Value<String> color,
      Value<String?> comment,
      Value<int?> start,
      Value<int?> end,
    });

final class $$AnnotationsTableReferences
    extends BaseReferences<_$AppDatabase, $AnnotationsTable, AnnotationRow> {
  $$AnnotationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TurnsTable _turnIdTable(_$AppDatabase db) => db.turns.createAlias(
    $_aliasNameGenerator(db.annotations.turnId, db.turns.id),
  );

  $$TurnsTableProcessedTableManager get turnId {
    final $_column = $_itemColumn<int>('turn_id')!;

    final manager = $$TurnsTableTableManager(
      $_db,
      $_db.turns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_turnIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnnotationsTableFilterComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shape => $composableBuilder(
    column: $table.shape,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  $$TurnsTableFilterComposer get turnId {
    final $$TurnsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turnId,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableFilterComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shape => $composableBuilder(
    column: $table.shape,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  $$TurnsTableOrderingComposer get turnId {
    final $$TurnsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turnId,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableOrderingComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get shape =>
      $composableBuilder(column: $table.shape, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<int> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<int> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  $$TurnsTableAnnotationComposer get turnId {
    final $$TurnsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turnId,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableAnnotationComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnnotationsTable,
          AnnotationRow,
          $$AnnotationsTableFilterComposer,
          $$AnnotationsTableOrderingComposer,
          $$AnnotationsTableAnnotationComposer,
          $$AnnotationsTableCreateCompanionBuilder,
          $$AnnotationsTableUpdateCompanionBuilder,
          (AnnotationRow, $$AnnotationsTableReferences),
          AnnotationRow,
          PrefetchHooks Function({bool turnId})
        > {
  $$AnnotationsTableTableManager(_$AppDatabase db, $AnnotationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnnotationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnnotationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnnotationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> turnId = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> shape = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int?> start = const Value.absent(),
                Value<int?> end = const Value.absent(),
              }) => AnnotationsCompanion(
                id: id,
                turnId: turnId,
                target: target,
                kind: kind,
                shape: shape,
                color: color,
                comment: comment,
                start: start,
                end: end,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int turnId,
                required String target,
                required String kind,
                Value<String> shape = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int?> start = const Value.absent(),
                Value<int?> end = const Value.absent(),
              }) => AnnotationsCompanion.insert(
                id: id,
                turnId: turnId,
                target: target,
                kind: kind,
                shape: shape,
                color: color,
                comment: comment,
                start: start,
                end: end,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AnnotationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({turnId = false}) {
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
                    if (turnId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.turnId,
                                referencedTable: $$AnnotationsTableReferences
                                    ._turnIdTable(db),
                                referencedColumn: $$AnnotationsTableReferences
                                    ._turnIdTable(db)
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

typedef $$AnnotationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnnotationsTable,
      AnnotationRow,
      $$AnnotationsTableFilterComposer,
      $$AnnotationsTableOrderingComposer,
      $$AnnotationsTableAnnotationComposer,
      $$AnnotationsTableCreateCompanionBuilder,
      $$AnnotationsTableUpdateCompanionBuilder,
      (AnnotationRow, $$AnnotationsTableReferences),
      AnnotationRow,
      PrefetchHooks Function({bool turnId})
    >;
typedef $$UserProgressTableCreateCompanionBuilder =
    UserProgressCompanion Function({
      Value<int> turnId,
      Value<bool> learned,
      Value<bool> favorite,
      Value<DateTime?> lastReviewed,
      Value<int> reviewCount,
    });
typedef $$UserProgressTableUpdateCompanionBuilder =
    UserProgressCompanion Function({
      Value<int> turnId,
      Value<bool> learned,
      Value<bool> favorite,
      Value<DateTime?> lastReviewed,
      Value<int> reviewCount,
    });

final class $$UserProgressTableReferences
    extends BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressRow> {
  $$UserProgressTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TurnsTable _turnIdTable(_$AppDatabase db) => db.turns.createAlias(
    $_aliasNameGenerator(db.userProgress.turnId, db.turns.id),
  );

  $$TurnsTableProcessedTableManager get turnId {
    final $_column = $_itemColumn<int>('turn_id')!;

    final manager = $$TurnsTableTableManager(
      $_db,
      $_db.turns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_turnIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get learned => $composableBuilder(
    column: $table.learned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnFilters(column),
  );

  $$TurnsTableFilterComposer get turnId {
    final $$TurnsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turnId,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableFilterComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get learned => $composableBuilder(
    column: $table.learned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$TurnsTableOrderingComposer get turnId {
    final $$TurnsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turnId,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableOrderingComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get learned =>
      $composableBuilder(column: $table.learned, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => column,
  );

  $$TurnsTableAnnotationComposer get turnId {
    final $$TurnsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turnId,
      referencedTable: $db.turns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurnsTableAnnotationComposer(
            $db: $db,
            $table: $db.turns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProgressTable,
          UserProgressRow,
          $$UserProgressTableFilterComposer,
          $$UserProgressTableOrderingComposer,
          $$UserProgressTableAnnotationComposer,
          $$UserProgressTableCreateCompanionBuilder,
          $$UserProgressTableUpdateCompanionBuilder,
          (UserProgressRow, $$UserProgressTableReferences),
          UserProgressRow,
          PrefetchHooks Function({bool turnId})
        > {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> turnId = const Value.absent(),
                Value<bool> learned = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<DateTime?> lastReviewed = const Value.absent(),
                Value<int> reviewCount = const Value.absent(),
              }) => UserProgressCompanion(
                turnId: turnId,
                learned: learned,
                favorite: favorite,
                lastReviewed: lastReviewed,
                reviewCount: reviewCount,
              ),
          createCompanionCallback:
              ({
                Value<int> turnId = const Value.absent(),
                Value<bool> learned = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<DateTime?> lastReviewed = const Value.absent(),
                Value<int> reviewCount = const Value.absent(),
              }) => UserProgressCompanion.insert(
                turnId: turnId,
                learned: learned,
                favorite: favorite,
                lastReviewed: lastReviewed,
                reviewCount: reviewCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({turnId = false}) {
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
                    if (turnId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.turnId,
                                referencedTable: $$UserProgressTableReferences
                                    ._turnIdTable(db),
                                referencedColumn: $$UserProgressTableReferences
                                    ._turnIdTable(db)
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

typedef $$UserProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProgressTable,
      UserProgressRow,
      $$UserProgressTableFilterComposer,
      $$UserProgressTableOrderingComposer,
      $$UserProgressTableAnnotationComposer,
      $$UserProgressTableCreateCompanionBuilder,
      $$UserProgressTableUpdateCompanionBuilder,
      (UserProgressRow, $$UserProgressTableReferences),
      UserProgressRow,
      PrefetchHooks Function({bool turnId})
    >;
typedef $$RootProgressTableCreateCompanionBuilder =
    RootProgressCompanion Function({
      required String root,
      Value<bool> known,
      Value<int> exposureCount,
      Value<DateTime?> lastReviewed,
      Value<int> rowid,
    });
typedef $$RootProgressTableUpdateCompanionBuilder =
    RootProgressCompanion Function({
      Value<String> root,
      Value<bool> known,
      Value<int> exposureCount,
      Value<DateTime?> lastReviewed,
      Value<int> rowid,
    });

final class $$RootProgressTableReferences
    extends BaseReferences<_$AppDatabase, $RootProgressTable, RootProgressRow> {
  $$RootProgressTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RootsTable _rootTable(_$AppDatabase db) => db.roots.createAlias(
    $_aliasNameGenerator(db.rootProgress.root, db.roots.root),
  );

  $$RootsTableProcessedTableManager get root {
    final $_column = $_itemColumn<String>('root')!;

    final manager = $$RootsTableTableManager(
      $_db,
      $_db.roots,
    ).filter((f) => f.root.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rootTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RootProgressTableFilterComposer
    extends Composer<_$AppDatabase, $RootProgressTable> {
  $$RootProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get known => $composableBuilder(
    column: $table.known,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exposureCount => $composableBuilder(
    column: $table.exposureCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => ColumnFilters(column),
  );

  $$RootsTableFilterComposer get root {
    final $$RootsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.root,
      referencedTable: $db.roots,
      getReferencedColumn: (t) => t.root,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootsTableFilterComposer(
            $db: $db,
            $table: $db.roots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RootProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $RootProgressTable> {
  $$RootProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get known => $composableBuilder(
    column: $table.known,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exposureCount => $composableBuilder(
    column: $table.exposureCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  $$RootsTableOrderingComposer get root {
    final $$RootsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.root,
      referencedTable: $db.roots,
      getReferencedColumn: (t) => t.root,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootsTableOrderingComposer(
            $db: $db,
            $table: $db.roots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RootProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $RootProgressTable> {
  $$RootProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get known =>
      $composableBuilder(column: $table.known, builder: (column) => column);

  GeneratedColumn<int> get exposureCount => $composableBuilder(
    column: $table.exposureCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => column,
  );

  $$RootsTableAnnotationComposer get root {
    final $$RootsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.root,
      referencedTable: $db.roots,
      getReferencedColumn: (t) => t.root,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootsTableAnnotationComposer(
            $db: $db,
            $table: $db.roots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RootProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RootProgressTable,
          RootProgressRow,
          $$RootProgressTableFilterComposer,
          $$RootProgressTableOrderingComposer,
          $$RootProgressTableAnnotationComposer,
          $$RootProgressTableCreateCompanionBuilder,
          $$RootProgressTableUpdateCompanionBuilder,
          (RootProgressRow, $$RootProgressTableReferences),
          RootProgressRow,
          PrefetchHooks Function({bool root})
        > {
  $$RootProgressTableTableManager(_$AppDatabase db, $RootProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RootProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RootProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RootProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> root = const Value.absent(),
                Value<bool> known = const Value.absent(),
                Value<int> exposureCount = const Value.absent(),
                Value<DateTime?> lastReviewed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RootProgressCompanion(
                root: root,
                known: known,
                exposureCount: exposureCount,
                lastReviewed: lastReviewed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String root,
                Value<bool> known = const Value.absent(),
                Value<int> exposureCount = const Value.absent(),
                Value<DateTime?> lastReviewed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RootProgressCompanion.insert(
                root: root,
                known: known,
                exposureCount: exposureCount,
                lastReviewed: lastReviewed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RootProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({root = false}) {
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
                    if (root) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.root,
                                referencedTable: $$RootProgressTableReferences
                                    ._rootTable(db),
                                referencedColumn: $$RootProgressTableReferences
                                    ._rootTable(db)
                                    .root,
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

typedef $$RootProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RootProgressTable,
      RootProgressRow,
      $$RootProgressTableFilterComposer,
      $$RootProgressTableOrderingComposer,
      $$RootProgressTableAnnotationComposer,
      $$RootProgressTableCreateCompanionBuilder,
      $$RootProgressTableUpdateCompanionBuilder,
      (RootProgressRow, $$RootProgressTableReferences),
      RootProgressRow,
      PrefetchHooks Function({bool root})
    >;
typedef $$UserMemosTableCreateCompanionBuilder =
    UserMemosCompanion Function({
      Value<int> id,
      required String context,
      required String body,
      Value<DateTime> createdAt,
    });
typedef $$UserMemosTableUpdateCompanionBuilder =
    UserMemosCompanion Function({
      Value<int> id,
      Value<String> context,
      Value<String> body,
      Value<DateTime> createdAt,
    });

class $$UserMemosTableFilterComposer
    extends Composer<_$AppDatabase, $UserMemosTable> {
  $$UserMemosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserMemosTableOrderingComposer
    extends Composer<_$AppDatabase, $UserMemosTable> {
  $$UserMemosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserMemosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserMemosTable> {
  $$UserMemosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserMemosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserMemosTable,
          UserMemoRow,
          $$UserMemosTableFilterComposer,
          $$UserMemosTableOrderingComposer,
          $$UserMemosTableAnnotationComposer,
          $$UserMemosTableCreateCompanionBuilder,
          $$UserMemosTableUpdateCompanionBuilder,
          (
            UserMemoRow,
            BaseReferences<_$AppDatabase, $UserMemosTable, UserMemoRow>,
          ),
          UserMemoRow,
          PrefetchHooks Function()
        > {
  $$UserMemosTableTableManager(_$AppDatabase db, $UserMemosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserMemosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserMemosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserMemosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> context = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserMemosCompanion(
                id: id,
                context: context,
                body: body,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String context,
                required String body,
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserMemosCompanion.insert(
                id: id,
                context: context,
                body: body,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserMemosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserMemosTable,
      UserMemoRow,
      $$UserMemosTableFilterComposer,
      $$UserMemosTableOrderingComposer,
      $$UserMemosTableAnnotationComposer,
      $$UserMemosTableCreateCompanionBuilder,
      $$UserMemosTableUpdateCompanionBuilder,
      (
        UserMemoRow,
        BaseReferences<_$AppDatabase, $UserMemosTable, UserMemoRow>,
      ),
      UserMemoRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TurnsTableTableManager get turns =>
      $$TurnsTableTableManager(_db, _db.turns);
  $$RootsTableTableManager get roots =>
      $$RootsTableTableManager(_db, _db.roots);
  $$AffixesTableTableManager get affixes =>
      $$AffixesTableTableManager(_db, _db.affixes);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$AnnotationsTableTableManager get annotations =>
      $$AnnotationsTableTableManager(_db, _db.annotations);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$RootProgressTableTableManager get rootProgress =>
      $$RootProgressTableTableManager(_db, _db.rootProgress);
  $$UserMemosTableTableManager get userMemos =>
      $$UserMemosTableTableManager(_db, _db.userMemos);
}
