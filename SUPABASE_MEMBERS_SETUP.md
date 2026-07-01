# Supabase 회원관리 설정

## 1. Supabase 프로젝트 만들기

Supabase에서 새 프로젝트를 만든 뒤 아래 값을 확인합니다.

- Project URL
- anon public key

## 2. 홈페이지 설정값 입력

`member/supabase-config.js`를 열어 아래 두 값을 실제 값으로 바꿉니다.

```js
export const SUPABASE_URL = "https://pedxdvjgpxgqjwmwomby.supabase.co";
export const SUPABASE_ANON_KEY = "Supabase anon public key";
```

## 3. 회원 테이블 생성

Supabase Dashboard의 SQL Editor에서 `supabase-setup-members.sql` 내용을 실행합니다.

이 SQL은 다음을 만듭니다.

- `members` 회원 프로필 테이블
- 회원 본인만 자기 정보를 읽을 수 있는 RLS 정책
- Supabase Auth 가입 시 `members` 행을 자동 생성하는 트리거

## 4. 이메일 인증 설정

Supabase Dashboard에서 Authentication 설정을 확인합니다.

- Email provider 활성화
- Confirm email 활성화 권장
- Site URL: 실제 홈페이지 주소
- Redirect URLs: `https://홈페이지주소/member/login.html?verified=1`

## 5. 동작 흐름

1. 사용자가 `/member/join.html`에서 가입합니다.
2. Supabase가 인증 이메일을 보냅니다.
3. 사용자가 이메일 링크를 누릅니다.
4. `/member/login.html`에서 로그인합니다.
5. `/member/mypage-standalone.html`에서 회원 정보를 확인합니다.
