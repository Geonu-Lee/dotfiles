---
name: commit-helper
description: git diff를 분석해 커밋 메시지와 복붙용 git 명령어(git add / git commit -m)를 만들어 준다. 커밋을 직접 실행하지는 않고 명령어만 출력한다. "커밋하려는데", "커밋 메시지 만들어줘", "이거 어떻게 커밋", "commit message", "변경사항 커밋", "git diff 보고 메시지" 등 커밋을 준비하거나 메시지가 필요한 모든 상황에서 사용. 변경이 논리적으로 나뉘면 atomic commit 여러 개로 쪼개 제안한다.
---

# Commit Helper

작업 변경사항을 보고, 그대로 복사해 붙여넣을 수 있는 커밋 명령어를 만들어 주는 스킬.

**핵심 원칙: 커밋을 실행하지 않는다.** `git add`/`git commit`/`git push` 를 직접 돌리지 말 것. 너의 역할은 사용자가 복붙할 수 있는 명령어를 **출력**하는 데서 끝난다 — 커밋 여부와 시점은 사용자가 정한다. 사용자가 "그냥 해줘"라고 해도 명령어만 제공한다. 이게 이 스킬의 존재 이유다.

## 워크플로우

1. **변경사항 파악 (읽기 전용 git 명령만):**
   - `git status --short` — 변경/추가/삭제/untracked 파일 목록
   - `git diff HEAD` — 실제 변경 내용 (tracked의 staged + unstaged)
   - untracked 파일 내용이 필요하면 해당 파일을 직접 읽는다
   - `git log --oneline -5` — 기존 커밋 스타일·언어 참고
2. **논리적 단위로 묶는다.** 성격이 다른 변경(기능 추가 + 무관한 리팩터 + 문서 등)이 섞였으면 분리한다. 하나의 일관된 변경이면 단일 커밋.
3. **각 단위마다 메시지 + 복붙 명령어를 출력한다.**

## 커밋 메시지 형식

`<type>(<scope>): <한국어 제목>`

- **type**: 영어 conventional — `feat` `fix` `docs` `refactor` `test` `chore` `style` `perf`
- **scope**: 선택, 영어 (변경 영역. 예: auth, api, ui)
- **제목**: 한국어, 50자 이내, 명령형 느낌, 마침표 없음
- **본문**: 선택. 사소하지 않은 변경은 "왜" 바꿨는지 한 줄. `-m` 을 두 번 써서 표현

## 출력 형식

명령어는 항상 `bash` 코드블록에 넣어 복사하기 쉽게 한다.

**단일 커밋일 때 — add 두 방식을 모두 제시한다:**

```bash
# 변경 파일만 명시
git add path/a.ts path/b.ts
git commit -m "feat(auth): JWT 로그인 추가"
```
```bash
# 또는 전체 스테이징
git add -A
git commit -m "feat(auth): JWT 로그인 추가"
```

**여러 커밋으로 쪼갤 때 — 각 커밋은 해당 파일만 명시한다** (`git add -A`는 전부 한 번에 들어가므로 쓰지 않는다). 실행 순서대로:

```bash
# 1) 기능
git add src/auth.ts src/login.ts
git commit -m "feat(auth): JWT 로그인 추가"

# 2) 문서
git add README.md
git commit -m "docs: 로그인 설정 안내 추가"
```

본문이 필요하면 `-m` 을 두 번:

```bash
git add src/api.ts
git commit -m "fix(api): 타임아웃 시 재시도 누락 수정" -m "외부 호출이 5초 후 끊길 때 재시도가 동작하지 않아 빈 응답이 반환되던 문제."
```

## 주의

- **변경 없음**: `git status`가 깨끗하면 그 사실을 알리고 멈춘다.
- **민감정보**: diff에 키·토큰·`.env`·자격증명이 보이면 add 명령에 넣기 전에 경고한다.
- **추측 금지**: 변경 의도가 불분명하면 메시지를 단정하지 말고 사용자에게 무엇을 한 변경인지 확인한다.
- 기존 repo 커밋이 영어로만 돼 있어도, 이 스킬은 한국어 제목을 기본으로 한다(사용자 설정). 다만 명백히 영어 일관성을 원하는 신호가 있으면 맞춘다.

## 예시

**Example 1 — 단일 변경:**
Input: `auth.ts`에 JWT 토큰 검증 함수 추가
Output:
```bash
git add src/auth.ts
git commit -m "feat(auth): JWT 토큰 검증 추가"
```
```bash
git add -A
git commit -m "feat(auth): JWT 토큰 검증 추가"
```

**Example 2 — 섞인 변경 → 분리:**
Input: 로그인 버그 수정 + README 오타 수정 (서로 무관)
Output: 두 개의 atomic 커밋으로 분리 제시
```bash
# 1) 버그 수정
git add src/login.ts
git commit -m "fix(auth): 빈 비밀번호 통과되던 검증 오류 수정"

# 2) 문서 오타
git add README.md
git commit -m "docs: 설치 안내 오타 수정"
```
