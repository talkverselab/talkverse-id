import 'dart:convert';

import 'package:drift/drift.dart';

import '../../services/affix_util.dart';
import '../db/app_database.dart';

/// 어근(kata dasar) 파생어 1건.
class RootFamilyItem {
  final String word;
  final String affix; // 'meN-', 'ber-', '-an', 'ke-an' ...
  final String ko;
  const RootFamilyItem({required this.word, required this.affix, required this.ko});

  factory RootFamilyItem.fromJson(Map<String, dynamic> m) => RootFamilyItem(
        word: m['word'] as String,
        affix: (m['affix'] ?? '') as String,
        ko: (m['ko'] ?? '') as String,
      );
}

/// 어근·접사·단어빈도 접근 + AffixUtil 사전 주입.
class RootRepository {
  RootRepository(this.db);
  final AppDatabase db;

  Future<List<RootRow>> allRoots() => (db.select(db.roots)
        ..orderBy([
          (r) => OrderingTerm(expression: r.rank, mode: OrderingMode.asc, nulls: NullsOrder.last)
        ]))
      .get();

  Future<List<RootRow>> rootsOfPhase(int phase) => (db.select(db.roots)
        ..where((r) => r.phase.equals(phase))
        ..orderBy([(r) => OrderingTerm.asc(r.rank)]))
      .get();

  Future<RootRow?> find(String root) =>
      (db.select(db.roots)..where((r) => r.root.equals(root))).getSingleOrNull();

  List<RootFamilyItem> familyOf(RootRow row) {
    if (row.familyJson == null) return const [];
    try {
      final list = json.decode(row.familyJson!) as List;
      return list
          .map((e) => RootFamilyItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<AffixRow>> allAffixes() => db.select(db.affixes).get();

  Future<List<WordRow>> topWords({int limit = 300}) =>
      (db.select(db.words)..orderBy([(w) => OrderingTerm.asc(w.rank)])..limit(limit))
          .get();

  /// 어근 목록을 AffixUtil 에 주입 (앱 시작 시 1회).
  Future<void> primeAffixUtil() async {
    final rows = await allRoots();
    AffixUtil.setKnownRoots(rows.map((r) => r.root));
  }

  Future<void> markKnown(String root, bool known) {
    return db.into(db.rootProgress).insertOnConflictUpdate(
          RootProgressCompanion(
            root: Value(root),
            known: Value(known),
            lastReviewed: Value(DateTime.now()),
          ),
        );
  }

  Future<Set<String>> knownRoots() async {
    final rows = await (db.select(db.rootProgress)
          ..where((p) => p.known.equals(true)))
        .get();
    return rows.map((r) => r.root).toSet();
  }
}
