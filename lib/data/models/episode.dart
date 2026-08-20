/// 에피소드(L1) / 대화(L2·L3) 메타 — assets JSON 의 turns 를 제외한 헤더.
class EpisodeMeta {
  final String level; // L1 | L2 | L3
  final String id; // ep1, d01 ...
  final String title;
  final String emoji;
  final String scenario;
  final int turnCount;

  const EpisodeMeta({
    required this.level,
    required this.id,
    required this.title,
    this.emoji = '💬',
    this.scenario = '',
    this.turnCount = 0,
  });

  factory EpisodeMeta.fromJson(String level, Map<String, dynamic> m) {
    return EpisodeMeta(
      level: level,
      id: m['id'] as String,
      title: (m['title'] ?? m['id']) as String,
      emoji: (m['emoji'] ?? '💬') as String,
      scenario: (m['scenario'] ?? '') as String,
      turnCount: ((m['turns'] as List?)?.length) ?? 0,
    );
  }

  String get key => '$level:$id';
}

/// 대화 화자 정보 (_meta.json / L*.json 의 characters).
class Speaker {
  final String code; // A | B
  final String name;
  final String role;
  final String gender; // male | female
  const Speaker({
    required this.code,
    required this.name,
    required this.role,
    required this.gender,
  });

  factory Speaker.fromJson(String code, Map<String, dynamic> m) => Speaker(
        code: code,
        name: (m['name'] ?? code) as String,
        role: (m['role'] ?? '') as String,
        gender: (m['gender'] ?? (code == 'A' ? 'male' : 'female')) as String,
      );

  static const defaults = {
    'A': Speaker(code: 'A', name: 'Mark', role: '외국인 학습자(남)', gender: 'male'),
    'B': Speaker(code: 'B', name: 'Sari', role: '인도네시아 여성(여)', gender: 'female'),
  };
}
