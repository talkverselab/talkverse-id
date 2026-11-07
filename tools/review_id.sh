#!/bin/zsh
# 리뷰 페이지 다시 만들기 — 시험 편(data/tts/episodes)을 앞에, 그 뒤 앱의 편 전부. uk 세션이 tools/publish_review.sh id 로 게시한다.
cd "$(dirname "$0")/.."
python3 tools/review_html.py data/review/REVIEW_id.html data/tts/episodes/*.json assets/data/dialogues/R*/*/*.json
