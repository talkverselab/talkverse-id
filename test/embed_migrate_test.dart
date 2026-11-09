import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/core/embed_env.dart';
import 'package:indo_universe/core/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('단독 앱: 옛 설정 키를 한 번 id_ 접두로 옮기고, 이후 읽기·쓰기는 접두 키로', () async {
    SharedPreferences.setMockInitialValues({'learner_name': 'Budi', 'reading_aid': true, 'iap_pending': <String>['x'], 'id_db_version': 6});
    embedded = false;
    final p = await Prefs.getInstance();
    expect(p.getString('learner_name'), 'Budi');
    expect(p.getBool('reading_aid'), isTrue);
    expect(p.getStringList('iap_pending'), ['x']);
    expect(p.getInt('db_version'), 6);
    final raw = await SharedPreferences.getInstance();
    expect(raw.containsKey('learner_name'), isFalse);
    expect(raw.getString('id_learner_name'), 'Budi');
    await p.setString('learner_gender', 'female');
    expect(raw.getString('id_learner_gender'), 'female');
    expect(p.getKeys(), containsAll(['learner_name', 'learner_gender']));
  });

  test('에셋 경로: 통합 앱이면 패키지 접두, 단독 앱이면 그대로', () {
    embedded = false;
    expect(assetPath('assets/data/version.json'), 'assets/data/version.json');
    embedded = true;
    expect(assetPath('assets/data/version.json'), 'packages/indo_universe/assets/data/version.json');
    expect(assetPath('packages/indo_universe/assets/x.png'), 'packages/indo_universe/assets/x.png');
    expect(stripAssetPrefix('packages/indo_universe/assets/data/dialogues/R1/love/a.json'), 'assets/data/dialogues/R1/love/a.json');
    embedded = false;
  });
}
