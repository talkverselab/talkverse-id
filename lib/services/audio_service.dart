import 'dart:convert';
import '../core/embed_env.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;

/// 사전 녹음 mp3 재생. `assets/data/audio_manifest.json` 의
/// { "roots": { "makan": "assets/audio/roots/makan.mp3" }, "turns": { "L1:ep1:1": "..." } }
class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();
  Map<String, String> _rootMap = const {};
  Map<String, String> _turnMap = const {};
  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    try {
      final raw = await rootBundle.loadString(assetPath('assets/data/audio_manifest.json'));
      final data = json.decode(raw) as Map<String, dynamic>;
      _rootMap = ((data['roots'] as Map<String, dynamic>?) ?? {})
          .map((k, v) => MapEntry(k, v.toString()));
      _turnMap = ((data['turns'] as Map<String, dynamic>?) ?? {})
          .map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      _rootMap = const {};
      _turnMap = const {};
    }
    _loaded = true;
  }

  bool hasRoot(String root) => _rootMap.containsKey(root);
  bool hasTurn(String key) => _turnMap.containsKey(key);

  Future<bool> playRoot(String root) => _playPath(_rootMap[root]);
  Future<bool> playTurn(String key) => _playPath(_turnMap[key]);

  Future<bool> _playPath(String? path) async {
    await ensureLoaded();
    if (path == null) return false;
    try {
      await _player.stop();
      // 통합 앱이면 에셋이 packages/indo_universe/ 아래 — 앞 접두(assets/) 없이 전체 경로로 찾는다
      _player.audioCache = AudioCache(prefix: '');
      await _player.play(AssetSource(assetPath(path)));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> stop() => _player.stop();

  Future<void> dispose() async {
    await _player.dispose();
  }
}
