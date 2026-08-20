import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// 인도네시아어 ↔ 말레이어 차이 1건.
class VariantPair {
  final String id;
  final String ms;
  final String ko;
  final String category; // vocab | spelling | pronoun | idiom
  final String note;
  const VariantPair({
    required this.id,
    required this.ms,
    required this.ko,
    this.category = 'vocab',
    this.note = '',
  });

  factory VariantPair.fromJson(Map<String, dynamic> m) => VariantPair(
        id: m['id'] as String,
        ms: m['ms'] as String,
        ko: (m['ko'] ?? '') as String,
        category: (m['category'] ?? 'vocab') as String,
        note: (m['note'] ?? '') as String,
      );
}

/// assets/data/variants/id_ms_diff.json 로더 (캐싱).
class VariantRepository {
  VariantRepository._();
  static final VariantRepository instance = VariantRepository._();

  List<VariantPair> _pairs = const [];
  bool _loaded = false;

  List<VariantPair> get all => _pairs;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    try {
      final raw =
          await rootBundle.loadString('assets/data/variants/id_ms_diff.json');
      final data = json.decode(raw) as Map<String, dynamic>;
      _pairs = ((data['pairs'] as List?) ?? [])
          .map((e) => VariantPair.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      _pairs = const [];
    }
    _loaded = true;
  }

  List<VariantPair> byCategory(String category) =>
      _pairs.where((p) => p.category == category).toList();

  Set<String> get categories => _pairs.map((p) => p.category).toSet();
}
