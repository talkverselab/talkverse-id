import 'package:flutter/material.dart';

import '../core/platform.dart';
import '../core/theme.dart';
import '../widgets/indo_decor.dart';

/// 앱 소개 — 이 앱의 뼈대인 **절벽구간**을 설명한다(사용자 지시 2026-11-07: 왼쪽 레일 맨 아래 「앱 소개」, 폰은 프로필 → 정보).
/// 인도네시아어는 글자 기준이 없어 1. 단어 기준 · 2. 산출 방식 · 3. 앱에서 쓰는 곳.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // 절벽 v2(2026-11-03): 누적 55/60/70/80% 에 처음 닿는 순위. R5 는 2,000위에서 끊음(2,000위 누적 91.6%).
  static const wordCliffs = [104, 139, 249, 523];
  static const wordCap = 2000;
  static const wordCapPct = 91.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.washi,
      appBar: AppBar(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('앱 소개', style: TextStyle(color: AppColors.sumi, fontSize: 16, fontWeight: FontWeight.w800)),
            SizedBox(height: 2),
            Text('절벽구간 — 이 앱이 단어를 나누는 기준', style: TextStyle(color: AppColors.sumiLight, fontSize: 10, letterSpacing: 2)),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 24 + bottomInset(context)),
        children: [
          const _Lead('인도네시아 영화·드라마 대사에서 자주 나오는 말은 아주 적습니다. 처음 104개가 대사의 55%를 차지하고, 523개면 80%입니다. 그 뒤로는 단어를 아무리 더 외워도 들리는 비율이 조금씩만 오릅니다 — 이 급한 경사를 「절벽」이라 부르고, 절벽이 끝나는 자리마다 구간(R1~R5)을 나눕니다.'),
          const SizedBox(height: 18),
          const _H('1. 단어 기준'),
          const _CliffTable(
            cliffs: wordCliffs,
            cap: wordCap,
            capPct: wordCapPct,
            note: '어근 1개 = 1, 접사도 각각 1(makanan = makan + -an). 그래서 meN-·-nya 같은 접사도 순위에 나옵니다. R5 는 2,000위에서 끊습니다(누적 91.6%).',
          ),
          const SizedBox(height: 18),
          const _H('2. 산출 방식'),
          const _Para('말뭉치 — 인도네시아에서 제작한 영화·드라마의 대사 자막 686편(작품당 1판, 343만 토큰). 소리 설명·기호·숫자는 뺐습니다.'),
          const _Para('빈도 — 각 어근·접사의 등장 횟수 ÷ 전체 등장 횟수. 가중치 없음.'),
          const _Para('구간 — 빈도순으로 누적해 55%·60%·70%·80%에 처음 닿는 순위가 R1·R2·R3·R4 의 끝. 80% 밖은 R5. 이 네 비율은 Talkverse 19개 언어 공통 기준입니다.'),
          const SizedBox(height: 18),
          const _H('3. 앱에서 쓰는 곳'),
          const _Para('절벽 단어 — R1→R5 순서로 20어씩 한 단원. 「회화 단어 포함」을 누르면 이 앱의 회화에 나오는 단어 중 2,000위 밖의 말이 「회화」 구간으로 뒤에 붙습니다.'),
          const _Para('회화 — 구간별로 나뉘어 있고, R1 부터 차례로 늘어납니다.'),
          const SizedBox(height: 24),
          const SoftDivider(),
          const SizedBox(height: 10),
          const Center(
            child: Text('절벽 v2 · 2026-11-03', style: TextStyle(color: AppColors.sumiLight, fontSize: 11, letterSpacing: 2)),
          ),
        ],
      ),
    );
  }
}

class _Lead extends StatelessWidget {
  final String text;
  const _Lead(this.text);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.washiDeep,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text, style: const TextStyle(color: AppColors.sumi, fontSize: 14, height: 1.6)),
      );
}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(color: AppColors.sumi, fontSize: 16, fontWeight: FontWeight.w800)),
      );
}

class _Para extends StatelessWidget {
  final String text;
  const _Para(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(color: AppColors.sumiLight, fontSize: 13, height: 1.55)),
      );
}

/// 구간표 — 5줄(R1~R5): 순위 범위 · 개수 · 누적 %. 막대는 구간 등폭 5칸.
class _CliffTable extends StatelessWidget {
  final List<int> cliffs; // R1~R4 끝 순위
  final int cap; // R5 끝
  final double capPct; // cap 위 누적 %
  final String note;
  const _CliffTable({required this.cliffs, required this.cap, required this.capPct, required this.note});

  static const _pct = [55, 60, 70, 80];
  static const _colors = [AppColors.beni, AppColors.beniLight, AppColors.kinDeep, AppColors.matcha, AppColors.muted];

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String, String, String)>[];
    var prev = 0;
    for (var i = 0; i < 4; i++) {
      final end = cliffs[i];
      rows.add(('R${i + 1}', '${prev + 1}-$end', '${end - prev}어', '${_pct[i]}%'));
      prev = end;
    }
    rows.add(('R5', '${prev + 1}-$cap', '${cap - prev}어', '$capPct%'));
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Row(
              children: [
                for (var i = 0; i < 5; i++)
                  Expanded(
                    child: Container(
                      height: 10,
                      margin: EdgeInsets.only(right: i < 4 ? 2 : 0),
                      decoration: BoxDecoration(color: _colors[i], borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
              ],
            ),
          ),
          for (var i = 0; i < rows.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.line, width: i == 0 ? 0 : 0.6))),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: _colors[i], borderRadius: BorderRadius.circular(2)),
                    child: Text(rows[i].$1, style: const TextStyle(color: AppColors.washi, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(rows[i].$2, style: const TextStyle(color: AppColors.sumi, fontSize: 13, fontWeight: FontWeight.w700))),
                  SizedBox(width: 64, child: Text(rows[i].$3, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.sumiLight, fontSize: 12))),
                  SizedBox(
                    width: 72,
                    child: Text('누적 ${rows[i].$4}', textAlign: TextAlign.right,
                        style: const TextStyle(color: AppColors.sumi, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Text(note, style: const TextStyle(color: AppColors.sumiLight, fontSize: 11, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
