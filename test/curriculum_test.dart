// 토크버스 커리큘럼 — 점수 80% 경계, 간격 반복 날짜, 시험 문제 수, 저장 왕복(2026-11-22, CURRICULUM_SPEC §8).
import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/services/curriculum.dart';
import 'package:indo_universe/services/dialogue_service.dart';

void main() {
  test('점수 80% 경계 — 소수점 버림', () {
    expect(scoreOf(8, 10), 80);
    expect(passed(scoreOf(8, 10)), isTrue);
    expect(scoreOf(23, 29), 79); // 79.3 → 79
    expect(passed(scoreOf(23, 29)), isFalse);
    expect(scoreOf(4, 5), 80);
    expect(scoreOf(0, 0), 0);
  });

  test('간격 반복 1·3·7일, 틀리면 1일로, 마지막 간격을 맞히면 뺀다', () {
    final s = CurriculumState();
    s.enqueueLines(['a#1'], '2026-11-22');
    expect(s.review.single.due, '2026-11-23');
    s.answerReview('a#1', true, '2026-11-23');
    expect(s.review.single.due, '2026-11-26');
    s.answerReview('a#1', true, '2026-11-26');
    expect(s.review.single.due, '2026-12-03');
    s.answerReview('a#1', false, '2026-12-03');
    expect((s.review.single.step, s.review.single.due), (0, '2026-12-04'));
    s.answerReview('a#1', true, '2026-12-04');
    s.answerReview('a#1', true, '2026-12-07');
    s.answerReview('a#1', true, '2026-12-14');
    expect(s.review, isEmpty);
    expect(s.dueOn('2026-11-30'), isEmpty);
  });

  test('시험: 편당 최소 3, 합계 최대 30 · 통과/불합격 반영', () {
    expect(examPerDialogue(3), 10);
    expect(examPerDialogue(5), 6);
    expect(examPerDialogue(10), 3);
    final s = CurriculumState()..course = Course('c', ['a', 'b'], practiced: ['a', 'b']);
    s.applyExam(70, {'b'}, '2026-11-22');
    expect(s.course!.practiced, ['a']);
    expect(s.passedDialogues, isEmpty);
    s.course!.practiced.add('b');
    s.applyExam(85, {}, '2026-11-23');
    expect(s.course!.passedAt, '2026-11-23');
    expect(s.passedDialogues, {'a', 'b'});
    expect(s.course!.examScores, [70, 85]);
  });

  test('연속 일수·저장 왕복', () {
    final s = CurriculumState()..dailyGoal = 'light';
    s.rollDay('2026-11-22');
    s.todayNew = 1;
    expect(s.markDoneIfComplete('2026-11-22', newLeft: 3), isTrue);
    s.rollDay('2026-11-23');
    s.todayNew = 1;
    s.markDoneIfComplete('2026-11-23', newLeft: 2);
    expect(s.streakCount, 2);
    final back = CurriculumState.fromJson(json.decode(json.encode(s.toJson())) as Map<String, dynamic>);
    expect((back.streakCount, back.streakLastDay, back.dailyGoal), (2, '2026-11-23', 'light'));
  });

  test('확인 문제 — 4지선다, 정답 하나, 최대 10', () {
    DialogueTurn t(int n, String tl, String ko) => DialogueTurn.fromL1({'num': n, 'speaker': 'A', 'id': tl, 'ko': ko});
    final d = Dialogue(id: 'x', region: 'R1', island: 'life', title: 't', emoji: '', scene: '', speakers: const {}, genders: const {}, expressions: const [],
        turns: [for (var i = 1; i <= 12; i++) t(i, 'Saya makan nasi goreng nomor$i hari ini', '뜻 $i')]);
    final qs = questionsFor(d, pool: const [], rnd: Random(1));
    expect(qs.length, 10);
    for (final q in qs) {
      expect(q.choices.length, 4);
      expect(q.choices.toSet().length, 4);
      expect(q.answer, inInclusiveRange(0, 3));
    }
    expect(recommend([d], {}, 3), ['x']);
  });
}
