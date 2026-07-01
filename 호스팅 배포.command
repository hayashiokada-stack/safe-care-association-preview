#!/bin/bash
cd "$(dirname "$0")"
echo "========================================="
echo "  한국안전돌봄협회 웹사이트 배포 중..."
echo "========================================="
echo ""
firebase deploy --only hosting
echo ""
if [ $? -eq 0 ]; then
  echo "배포 완료! 사이트에서 강력 새로고침(Cmd+Shift+R) 해보세요."
else
  echo "배포 실패. 위 오류 메시지를 확인해 주세요."
fi
echo "창을 닫으려면 아무 키나 누르세요..."
read -n 1
