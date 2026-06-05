---
description: 현재 변경사항(staged + unstaged)을 버그·간결성 관점에서 리뷰
argument-hint: "[추가 관점, 예: 보안]"
allowed-tools: Bash(git diff:*), Bash(git status:*)
---

# 예제 슬래시 커맨드 — `/review-diff`
# 이 파일 1개 = 명령어 1개. 파일명(review-diff) → /review-diff 로 호출됨.
# 마음대로 수정/삭제하세요. 새 명령어는 commands/ 에 .md 추가하면 끝.

다음 변경사항을 리뷰해줘. 칭찬은 생략하고 문제만 짚어.
우선순위: 1) 버그·엣지케이스  2) 보안  3) 간결성  $ARGUMENTS

## 현재 상태
!`git status --short`

## 변경 내용
!`git diff HEAD`
