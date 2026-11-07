import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/services/content_sync.dart';
import 'package:indo_universe/services/dialogue_audio.dart';
import 'package:indo_universe/services/dialogue_service.dart';
import 'package:indo_universe/services/learner_prefs.dart';

DialogueTurn _t(int n, String tl) => DialogueTurn(num: n, speaker: 'A', tl: tl, gloss: '', rd: '원본', ko: '원본', note: '메모', tags: const [], art: 'a.jpg', lemmas: const [Lemma('Halo', 'halo', '')]);
Dialogue _d(List<DialogueTurn> turns) => Dialogue(id: 'ep', region: 'R1', island: 'life', title: '', emoji: '', scene: '', speakers: const {'A': '{name}'}, genders: const {}, expressions: const [], turns: turns);
const _m = AudioLine('audio/id/ep/01_m.mp4?v=1', 1000, 'Halo, Alex.', '', '할로, 알렉스.', '안녕, 알렉스.');
const _f = AudioLine('audio/id/ep/01_f.mp4?v=2', 1000, 'Halo, Emma.', '', '할로, 에마.', '안녕, 에마.');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    ContentSync.instance.audioIndex = {};
    LearnerPrefs.gender.value = 'male';
  });

  test('음성이 없으면 본문을 그대로 쓰고 이름을 물어야 한다', () {
    final d = _d([_t(1, 'Halo, {name}.')]);
    expect(d.view(d.turns[0]).tl, 'Halo, {name}.');
    expect(DialogueAudio.instance.covers(d), isFalse);
    expect(DialogueAudio.instance.covers(_d([_t(1, 'Halo.')])), isFalse); // 음성 없는 편은 이름 자리가 없어도 덮이지 않는다
  });

  test('음성이 있으면 학습자 성별판 본문으로 바꾸고 나머지 칸은 둔다', () {
    ContentSync.instance.audioIndex = {'ep': {1: {'m': _m, 'f': _f}}};
    final d = _d([_t(1, 'Halo, {name}.')]);
    final v = d.view(d.turns[0]);
    expect((v.tl, v.rd, v.ko), ('Halo, Alex.', '할로, 알렉스.', '안녕, 알렉스.'));
    expect((v.note, v.art, v.lemmas.length), ('메모', 'a.jpg', 1));
    LearnerPrefs.gender.value = 'female';
    expect(d.view(d.turns[0]).tl, 'Halo, Emma.');
    expect(DialogueAudio.instance.covers(d), isTrue);
  });

  test('이름 자리 턴 하나라도 음성이 없으면 덮이지 않는다', () {
    ContentSync.instance.audioIndex = {'ep': {1: {'m': _m, 'f': _f}}};
    expect(DialogueAudio.instance.covers(_d([_t(1, 'Halo.'), _t(2, 'Hai, {name}.')])), isFalse);
  });
}
