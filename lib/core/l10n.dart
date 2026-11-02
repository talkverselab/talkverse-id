/// 화면 문구 — 지금은 한국어만. 일본어앱에서 옮긴 화면 코드가 쓰는 `tr()`/`trf()` 자리(표시 언어를 넣을 때 사전을 붙인다).
String tr(String ko) => ko;

/// `{0}`·`{1}` … 자리를 채운다.
String trf(String ko, List<Object?> args) {
  var s = ko;
  for (var i = 0; i < args.length; i++) {
    s = s.replaceAll('{$i}', '${args[i]}');
  }
  return s;
}
