# GitHub 자동배포 설정 가이드

목표: `git push` 한 번이면 사이트가 자동으로 배포되게 만들기. 이후로는 터미널에서 `firebase deploy` 실행할 필요가 없어집니다.

## 0. 준비물
- 터미널 (프로젝트 폴더에서 실행)
- GitHub 계정 로그인 (브라우저)
- Firebase 계정 로그인 (브라우저)

## 1단계 — GitHub 인증 새로 걸기

기존 토큰이 만료되어서 새로 발급해야 합니다.

1. https://github.com/settings/tokens/new 접속
2. "repo" 권한 전체 체크 → Generate token
3. 생성된 토큰(ghp_로 시작) 복사
4. 터미널에서:

```
cd "/Users/udcares/projects/safe care association/🏠 한국안전돌봄협회"
git remote set-url origin https://hayashiokada-stack:새로발급받은토큰@github.com/hayashiokada-stack/safe-care-association-preview.git
git push origin main
```

## 2단계 — Firebase Hosting GitHub 자동배포 연결

같은 터미널에서:

```
firebase init hosting:github
```

질문이 뜨면 이렇게 답하시면 됩니다.

- 저장소 이름: `hayashiokada-stack/safe-care-association-preview`
- "Set up the workflow to run a build script before every deploy?" → No
- "Set up automatic deployment to your site's live channel when a PR is merged?" → Yes
- 배포할 브랜치: `main`

완료되면 `.github/workflows/` 폴더에 자동배포 설정 파일이 새로 생깁니다.

## 3단계 — 자동배포 설정 파일 올리기

```
git add .github
git commit -m "GitHub 자동배포 설정 추가"
git push origin main
```

## 이후부터

파일을 수정하고 아래 두 줄만 실행하면 몇 분 안에 사이트에 자동 반영됩니다. 터미널에서 firebase 로그인/배포 명령어를 칠 필요가 없어집니다.

```
git add -A
git commit -m "설명"
git push origin main
```

## 막히면

- `git push`에서 인증 오류 → 1단계 토큰을 다시 발급
- `firebase init` 진행 중 로그인 요청 → 뜨는 브라우저 창에서 로그인만 하면 됨
