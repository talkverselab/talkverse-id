import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';
import 'app_database.dart';

/// 앱 최초 실행 시 assets/data → SQLite 시딩.
/// 콘텐츠가 바뀌면 [_kSeededKey] 버전을 올려 재시딩한다.
class SeedLoader {
  // v1: 초기 scaffold (L1 ep1 샘플 + 어근 core + 접사)
  static const _kSeededKey = 'db_seeded_v1';

  final AppDatabase db;
  SeedLoader(this.db);

  Future<void> seedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kSeededKey) == true) return;

    await _seedRoots();
    await _seedAffixes();
    await _seedWords();
    await _seedTurns();

    await prefs.setBool(_kSeededKey, true);
  }

  Future<void> _seedRoots() async {
    final Map<String, dynamic> data;
    try {
      final raw =
          await rootBundle.loadString('assets/data/roots/kata_dasar_core.json');
      data = json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    final items = (data['roots'] as List?) ?? [];
    final batch = <Insertable<RootRow>>[];
    for (final r in items) {
      final m = r as Map<String, dynamic>;
      batch.add(RootsCompanion.insert(
        root: m['root'] as String,
        rank: Value(m['rank'] as int?),
        freq: Value(m['freq'] as int?),
        pos: Value(m['pos'] as String?),
        phase: Value(m['phase'] as int?),
        meaningKo: Value(m['ko'] as String?),
        msForm: Value(m['ms'] as String?),
        familyJson:
            Value(m['family'] != null ? json.encode(m['family']) : null),
      ));
    }
    if (batch.isNotEmpty) {
      await db.batch((b) => b.insertAllOnConflictUpdate(db.roots, batch));
    }
  }

  Future<void> _seedAffixes() async {
    final Map<String, dynamic> data;
    try {
      final raw =
          await rootBundle.loadString('assets/data/grammar/affixes.json');
      data = json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    final items = (data['affixes'] as List?) ?? [];
    final batch = <Insertable<AffixRow>>[];
    for (final a in items) {
      final m = a as Map<String, dynamic>;
      batch.add(AffixesCompanion.insert(
        form: m['form'] as String,
        kind: m['kind'] as String,
        position: m['position'] as String,
        meaningKo: Value(m['ko'] as String?),
        allomorphs: Value((m['allomorphs'] as List?)?.join(',')),
        examplesJson:
            Value(m['examples'] != null ? json.encode(m['examples']) : null),
      ));
    }
    if (batch.isNotEmpty) {
      await db.delete(db.affixes).go();
      await db.batch((b) => b.insertAll(db.affixes, batch));
    }
  }

  Future<void> _seedWords() async {
    final String raw;
    try {
      raw = await rootBundle.loadString('assets/data/freq/lang_id_top2500.csv');
    } catch (_) {
      return;
    }
    final rows = const CsvToListConverter(eol: '\n').convert(raw);
    final batch = <Insertable<WordRow>>[];
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 5) continue;
      batch.add(WordsCompanion.insert(
        rank: Value(int.tryParse('${row[0]}') ?? 0),
        word: '${row[1]}',
        freq: Value(double.tryParse('${row[2]}')),
        cumPct: Value(double.tryParse('${row[3]}')),
        region: Value('${row[4]}'),
        root: Value(
            row.length > 5 && '${row[5]}'.isNotEmpty ? '${row[5]}' : null),
      ));
    }
    if (batch.isNotEmpty) {
      await db.batch((b) => b.insertAllOnConflictUpdate(db.words, batch));
    }
  }

  /// L1~L3 전체 턴 시딩. L1은 'episodes', L2/L3은 'dialogues' 키 사용 (zh 와 동일).
  Future<void> _seedTurns() async {
    final batch = <Insertable<TurnRow>>[];
    for (final level in Levels.all) {
      final Map<String, dynamic> data;
      try {
        final raw =
            await rootBundle.loadString('assets/data/dialogues/id/$level.json');
        data = json.decode(raw) as Map<String, dynamic>;
      } catch (_) {
        continue;
      }
      final units =
          (data['episodes'] as List?) ?? (data['dialogues'] as List?) ?? [];
      for (final ep in units) {
        final epMap = ep as Map<String, dynamic>;
        final epId = epMap['id'] as String?;
        final turns = (epMap['turns'] as List?) ?? [];
        for (final t in turns) {
          final m = t as Map<String, dynamic>;
          batch.add(TurnsCompanion.insert(
            level: level,
            variant: const Value('id'),
            episodeId: Value(epId),
            num: m['num'] as int,
            speaker: m['speaker'] as String,
            body: m['id'] as String,
            ms: Value(m['ms'] as String?),
            ko: Value(m['ko'] as String?),
            gloss: Value(m['gloss'] as String?),
            note: Value(m['note'] as String?),
            tagsJson: Value(m['tags'] != null ? json.encode(m['tags']) : null),
          ));
        }
      }
    }
    if (batch.isNotEmpty) {
      // 재시딩: 이전 버전 턴·진행 기록 제거 후 삽입 (turnId 재발급)
      await db.delete(db.userProgress).go();
      await db.delete(db.turns).go();
      await db.batch((b) => b.insertAll(db.turns, batch));
    }
  }

  Future<int> turnCount() => db.turns.count().getSingle();
  Future<int> rootCount() => db.roots.count().getSingle();
  Future<int> wordCount() => db.words.count().getSingle();
}
