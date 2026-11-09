import 'package:flutter/material.dart';

import 'embed.dart';

export 'embed.dart';

/// 단독 앱(인도네시아어유니버스). 초기화와 앱 위젯은 lib/embed.dart — 통합 앱(Talkverse)도 같은 두 함수를 쓴다.
void main() async {
  await embedInit(standalone: true);
  runApp(embedApp());
}
