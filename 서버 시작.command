#!/bin/bash
cd "$(dirname "$0")"
echo "========================================="
echo "  한국안전돌봄협회 웹서버 시작 중..."
echo "========================================="
echo ""
echo "  브라우저에서 아래 주소로 접속하세요:"
echo "  http://localhost:8080"
echo ""
echo "  종료하려면 이 창을 닫으세요."
echo "========================================="
sleep 2
open "http://localhost:8080"
python3 -m http.server 8080
