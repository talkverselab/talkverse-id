import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../core/constants.dart';
import '../db/app_database.dart';
import '../models/episode.dart';

/// 에피소드 카탈로그(assets JSON 헤더) + 턴/진행(DB) 접근.
class DialogueRepository {
  DialogueRepository(this.db);
  final AppDatabase db;

  final List<EpisodeMeta> _catalog = [];
  final Map<String, Speaker> _speakers = {};
  bool _loaded = false;

  List<EpisodeMeta> get catalog => List.unmodifiable(_catalog);
  Map<String, Speaker> get speakers =>
      _speakers.isEmpty ? Speaker.defaults : _speakers;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    for (final level in Levels.all) {
      try {
        final raw =
            await rootBundle.loadString('assets/data/dialogues/id/$level.json');
        final data = json.decode(raw) as Map<String, dynamic>;
        final units =
            (data['episodes'] as List?) ?? (data['dialogues'] as List?) ?? [];
        for (final ep in units) {
          _catalog.add(EpisodeMeta.fromJson(level, ep as Map<String, dynamic>));
        }
        final chars = data['characters'] as Map<String, dynamic>?;
        if (chars != null && _speakers.isEmpty) {
          chars.forEach((k, v) =>
              _speakers[k] = Speaker.fromJson(k, v as Map<String, dynamic>));
        }
      } catch (_) {
        continue;
      }
    }
    _loaded = true;
  }

  List<EpisodeMeta> byLevel(String level) =>
      _catalog.where((e) => e.level == level).toList();

  Future<List<TurnRow>> turnsOf(EpisodeMeta ep) {
    return (db.select(db.turns)
          ..where((t) => t.level.equals(ep.level) & t.episodeId.equals(ep.id))
          ..orderBy([(t) => OrderingTerm.asc(t.num)]))
        .get();
  }

  Future<Set<int>> learnedTurnIds() async {
    final rows = await (db.select(db.userProgress)
          ..where((p) => p.learned.equals(true)))
        .get();
    return rows.map((r) => r.turnId).toSet();
  }

  Future<void> markLearned(int turnId, bool learned) {
    return db.into(db.userProgress).insertOnConflictUpdate(
          UserProgressCompanion(
            turnId: Value(turnId),
            learned: Value(learned),
            lastReviewed: Value(DateTime.now()),
          ),
        );
  }

  Future<void> toggleFavorite(int turnId) async {
    final row = await (db.select(db.userProgress)
          ..where((p) => p.turnId.equals(turnId)))
        .getSingleOrNull();
    await db.into(db.userProgress).insertOnConflictUpdate(
          UserProgressCompanion(
            turnId: Value(turnId),
            favorite: Value(!(row?.favorite ?? false)),
            learned: Value(row?.learned ?? false),
          ),
        );
  }

  /// 에피소드별 (학습완료 / 전체) 카운트.
  Future<Map<String, (int, int)>> progressByEpisode() async {
    await ensureLoaded();
    final turns = await db.select(db.turns).get();
    final learned = await learnedTurnIds();
    final out = <String, (int, int)>{};
    for (final ep in _catalog) {
      final epTurns = turns
          .where((t) => t.level == ep.level && t.episodeId == ep.id)
          .toList();
      final done = epTurns.where((t) => learned.contains(t.id)).length;
      out[ep.key] = (done, epTurns.length);
    }
    return out;
  }
}
