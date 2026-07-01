#!/bin/zsh
FIREBASE="$HOME/.npm-packages/node_modules/.bin/firebase"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo "  Firebase Firestore 규칙 배포"
echo "========================================"
echo ""

if [ ! -f "$FIREBASE" ]; then
  echo "⏳ Firebase CLI 설치 중..."
  npm install firebase-tools --prefix "$HOME/.npm-packages"
fi

cd "$SCRIPT_DIR"

echo "🔐 Firebase 로그인..."
$FIREBASE login

echo ""
echo "🚀 Firestore 규칙 배포 중..."
$FIREBASE deploy --only firestore:rules

echo ""
if [ $? -eq 0 ]; then
  echo "✅ 배포 완료! 이제 회원가입이 정상 작동합니다."
else
  echo "❌ 배포 실패. 위 오류 메시지를 확인해 주세요."
fi

echo "창을 닫으려면 아무 키나 누르세요..."
read -k 1
