# Claude Code 설정

`~/.claude` 의 **공유 가능한** 설정만 담는다. 자격증명·세션·캐시는 제외.

```bash
bash ~/dotfiles/claude/install.sh   # → ~/.claude 로 복사 (install.sh 에 포함되어 자동 실행됨)
```

## 구조

```
claude/
├── install.sh                       # 복사 부트스트랩 (로컬 전용 파일 보존)
├── settings.json                    # 전역 설정 + 플러그인/마켓플레이스 선언
├── CLAUDE.md                        # 모든 세션에 적용될 개인 전역 지침
├── commands/                        # 커스텀 슬래시 커맨드
│   └── review-diff.md               #   review-diff.md → /review-diff
├── agents/                          # 커스텀 서브에이전트
│   └── explainer.md                 #   Task 도구로 호출되는 역할 AI
└── skills/                          # 직접 만든 스킬
    └── conventional-commits/SKILL.md
```

## 무엇을 어디에 넣나

| 만들고 싶은 것 | 위치 | 형식 |
|----------------|------|------|
| 새 슬래시 커맨드 `/foo` | `commands/foo.md` | frontmatter(`description` 등) + 프롬프트 본문. `$ARGUMENTS`, `` !`bash` `` 사용 가능 |
| 새 서브에이전트 | `agents/foo.md` | frontmatter(`name`,`description`,`tools`,`model`) + 시스템 프롬프트 |
| 새 스킬 | `skills/foo/SKILL.md` | frontmatter(`name`,`description`) + 지침. `description`이 트리거 |
| 전역 규칙 | `CLAUDE.md` | 마크다운. 매 세션 자동 로드 |
| 권한·env·hook·statusline | `settings.json` | JSON |

예제 파일들(`review-diff`, `explainer`, `conventional-commits`)은 패턴 학습용 — 수정/삭제 자유.

## 공유 vs 로컬

| 공유 ✅ (이 폴더) | 로컬 전용 ❌ (install.sh가 안 건드림) |
|-------------------|----------------------------------------|
| `settings.json` · `CLAUDE.md` | `.credentials.json` (OAuth/키) |
| `commands/` · `agents/` · `skills/`(직접 작성분) | `settings.local.json` (머신별 권한) |
| | `sessions/` · `history.jsonl` · `cache/` · `projects/` |
| | `plugins/` (선언으로 재설치) · find-skills 설치 스킬 |

## 설계 메모

- **복사(copy) 방식** — 기존 파일은 `~/.claude/.dotfiles-backup.<timestamp>/` 백업 후 덮어씀. 내용 같으면 스킵.
- **플러그인은 선언적 관리** — `plugins/` 캐시(절대경로·stale·수십 MB)는 커밋하지 않는다. `settings.json` 의 `enabledPlugins`/마켓플레이스만 공유하고, `install.sh` 가 거기 적힌 플러그인을 `claude plugin install` 로 **직접 복원**한다 (멱등성). 예: `skill-creator@claude-plugins-official` 한 줄 → 새 서버에서 자동 설치.
- **심볼릭 링크 스킬 제외** — find-skills가 만든 `skills/*` 심링크는 다른 머신에서 깨지므로 공유 안 함.
- 로그인은 머신마다 `claude` 실행 후 직접 인증.
