#!/bin/bash
# GitHub `latest` 릴리스의 CI 빌드 APK 를 Zealot(https://apps.talkverse.uk)에 올린다. 빌드는 하지 않는다.
# 사용: tools/zealot_push.sh ["변경 내용 한 줄"]   (없으면 latest.json 의 notes = 그 빌드의 커밋 제목)
# 순서: main 푸시 → CI 끝날 때까지 기다림(gh run watch) → 이 스크립트. 빌드 번호를 CI 하나로 잇는 규칙(CLAUDE.md §2).
set -euo pipefail

APP_NAME="인도네시아어유니버스"
REPO="talkverselab/talkverse-id"
EXPECTED_SHA1="9cc4bc932638be43a3982df20b71c4750288476b"

cd "$(dirname "$0")/.."
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

gh release download latest -R "$REPO" -p '*.apk' -p 'latest.json' -D "$TMP"
APK=$(ls "$TMP"/*.apk | head -1)
INFO=$(python3 -c 'import json,sys; j=json.load(open(sys.argv[1])); print(j["build"], j["sha"]); print(j.get("notes",""))' "$TMP/latest.json")
BUILD_SHA=$(echo "$INFO" | head -1)
NOTES=$(echo "$INFO" | tail -n +2)

# CI 가 아직 HEAD 를 빌드하지 않았으면 알린다(올리는 것은 막지 않음).
HEAD_SHA=$(git rev-parse --short=7 HEAD)
case "$BUILD_SHA" in
  *"$HEAD_SHA"*) ;;
  *) echo "주의: 릴리스 빌드($BUILD_SHA)가 HEAD($HEAD_SHA)가 아닙니다 — CI 가 끝났는지 확인하세요." >&2 ;;
esac

# 서명이 바뀐 APK 는 폰에서 덮어 설치가 안 된다(CLAUDE.md §1) — 올리기 전에 막는다.
SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}}"
APKSIGNER=$(ls "$SDK"/build-tools/*/apksigner 2>/dev/null | tail -1 || true)
if [ -n "$APKSIGNER" ]; then
  SHA1=$("$APKSIGNER" verify --print-certs "$APK" | grep 'SHA-1' | head -1 | awk '{print $NF}')
  if [ "$SHA1" != "$EXPECTED_SHA1" ]; then
    echo "서명이 다릅니다: $SHA1 (기대 $EXPECTED_SHA1) — 올리지 않습니다. CLAUDE.md §1 참고." >&2
    exit 1
  fi
else
  echo "apksigner 를 찾지 못해 서명 확인을 건너뜁니다." >&2
fi

NOTE="${1:-$NOTES}"
echo "올림: 빌드 $BUILD_SHA"
"$HOME/bin/zealot-upload" "$APK" "$APP_NAME" -c "$NOTE"
