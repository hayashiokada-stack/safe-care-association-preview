# Upstream

이 스킬은 외부 오픈소스 프로젝트를 이 저장소에 그대로 복사(vendoring)한 것입니다.

- 출처: https://github.com/bradautomates/claude-video
- 스킬 경로: `skills/watch`
- 버전: 0.2.0
- 가져온 커밋: `83da59f` (Fix WATCH_DETAIL silently falling back to default)
- 라이선스: MIT (`LICENSE` 참고, © 2026 Bradley Bonanno)

원본과 다른 점:
- 개발 전용 스크립트 `scripts/build-skill.sh` 제외
- 플러그인 전용 파일(`.claude-plugin/`, `hooks/`, `tests/`) 제외 — 스킬 실행에 필요 없음
- 이 `UPSTREAM.md` 추가

## 업데이트 방법

```bash
git clone --depth 1 https://github.com/bradautomates/claude-video /tmp/claude-video
rm -rf .claude/skills/watch/scripts .claude/skills/watch/SKILL.md
cp -R /tmp/claude-video/skills/watch/. .claude/skills/watch/
rm -f .claude/skills/watch/scripts/build-skill.sh
```

또는 벤더링 대신 Claude Code 플러그인 마켓플레이스로 전환할 수도 있습니다:

```
/plugin marketplace add bradautomates/claude-video
/plugin install watch@claude-video
```

## 실행 요구사항

`ffmpeg`, `ffprobe`, `yt-dlp` 가 필요합니다. 최초 실행 시 아래 명령이 설치를 안내합니다
(macOS + Homebrew 환경에서는 자동 설치).

```bash
python3 .claude/skills/watch/scripts/setup.py
```

자막이 없는 영상의 음성 인식(Whisper fallback)에는 `GROQ_API_KEY` 또는 `OPENAI_API_KEY` 가
`~/.config/watch/.env` 에 필요합니다. 자막이 있는 영상은 키 없이도 동작합니다.
