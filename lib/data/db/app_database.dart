import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ─── Tables ─────────────────────────────────────────────────────────────────

/// 대화 턴. zh 의 Turns 와 동일 구조 — zh/pinyin/tones 대신
/// body(인도네시아어) / ms(말레이어 변이) / gloss(단어별 뜻).
@DataClassName('TurnRow')
class Turns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get level => text()(); // 'L1' | 'L2' | 'L3'
  TextColumn get variant => text().withDefault(const Constant('id'))(); // 'id' | 'ms'
  TextColumn get episodeId => text().nullable()(); // 'ep1' .. 'ep5'
  IntColumn get num => integer()();
  TextColumn get speaker => text()(); // 'A' | 'B'
  TextColumn get body => text()(); // 인도네시아어 원문
  TextColumn get ms => text().nullable()(); // 말레이어 대응문 (있을 때만)
  TextColumn get ko => text().nullable()();
  TextColumn get gloss => text().nullable()(); // "Nama=이름 saya=나의 Mark"
  TextColumn get note => text().nullable()();
  TextColumn get tagsJson => text().nullable()();
}

/// 어근 (kata dasar). zh 의 Hanzi 테이블에 대응하는 핵심 IP.
@DataClassName('RootRow')
class Roots extends Table {
  TextColumn get root => text()();
  IntColumn get rank => integer().nullable()();
  IntColumn get freq => integer().nullable()();
  TextColumn get pos => text().nullable()(); // v, n, adj, adv, ...
  IntColumn get phase => integer().nullable()(); // 1, 2, 3, 4
  TextColumn get meaningKo => text().nullable()();
  TextColumn get msForm => text().nullable()(); // 말레이어에서 다른 형태면 기록
  TextColumn get familyJson => text().nullable()(); // 파생어 목록 JSON

  @override
  Set<Column> get primaryKey => {root};
}

/// 접사 (afiks). zh 의 PhoneticRoots(발음부) 에 대응 — 소수 규칙으로 다수 단어 풀이.
@DataClassName('AffixRow')
class Affixes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get form => text()(); // 'meN-', 'ber-', '-kan', 'ke-an'
  TextColumn get kind => text()(); // AffixKind 키
  TextColumn get position => text()(); // prefix | suffix | circumfix
  TextColumn get meaningKo => text().nullable()();
  TextColumn get allomorphs => text().nullable()(); // 'mem-,men-,meng-,meny-,menge-'
  TextColumn get examplesJson => text().nullable()();
}

@DataClassName('WordRow')
class Words extends Table {
  IntColumn get rank => integer()();
  TextColumn get word => text()();
  RealColumn get freq => real().nullable()();
  RealColumn get cumPct => real().nullable()();
  TextColumn get region => text().nullable()(); // R1, R2, R3, R4
  TextColumn get root => text().nullable()();

  @override
  Set<Column> get primaryKey => {rank};
}

/// 빨간펜 주석 (접사·소사·어순 자동 추출 + 사용자 편집).
@DataClassName('AnnotationRow')
class Annotations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get turnId => integer().references(Turns, #id)();
  TextColumn get target => text()();
  TextColumn get kind => text()(); // affix, particle, pronoun, order, chunk
  TextColumn get shape => text().withDefault(const Constant('highlight'))();
  TextColumn get color => text().withDefault(const Constant('yellow'))();
  TextColumn get comment => text().nullable()();
  IntColumn get start => integer().nullable()();
  IntColumn get end => integer().nullable()();
}

@DataClassName('UserProgressRow')
class UserProgress extends Table {
  IntColumn get turnId => integer().references(Turns, #id)();
  BoolColumn get learned => boolean().withDefault(const Constant(false))();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastReviewed => dateTime().nullable()();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {turnId};
}

@DataClassName('RootProgressRow')
class RootProgress extends Table {
  TextColumn get root => text().references(Roots, #root)();
  BoolColumn get known => boolean().withDefault(const Constant(false))();
  IntColumn get exposureCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewed => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {root};
}

@DataClassName('UserMemoRow')
class UserMemos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get context => text()(); // screen+turn or 'global'
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ─── Database ───────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  Turns,
  Roots,
  Affixes,
  Words,
  Annotations,
  UserProgress,
  RootProgress,
  UserMemos,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// 테스트용 — 임의 executor 주입 (NativeDatabase.memory() 등).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'indo_universe');
  }
}
