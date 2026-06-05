# Dotfiles

한 줄이면 어디서든 동일한 셸 환경.

```bash
git clone https://github.com/ljj727/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

## 구조

```
~/dotfiles/
├── install.sh                  # bootstrap (이것만 실행)
├── zsh/.zshrc                  # portable zshrc (zinit + plugins)
├── starship/starship.toml      # 프롬프트 테마
├── tmux/.tmux.conf             # tmux 설정 (catppuccin)
├── tmux/tmux.reset.conf        # tmux 키바인딩
├── tmux/scripts/               # tmux 헬퍼 스크립트
├── wezterm/                    # WezTerm 터미널 (Mac only)
├── yazi/yazi.toml              # yazi 파일 매니저
├── superfile/config.toml       # superfile 파일 매니저
├── claude/                     # Claude Code 설정 (settings + SuperClaude)
│   └── install.sh              #   → ~/.claude 로 복사 (로컬 전용 파일 보존)
└── local/.zshrc.local.example  # 머신별 설정 예시
```

## install.sh이 하는 일

| 단계 | 내용 |
|------|------|
| OS 감지 | Ubuntu/Debian/macOS 자동 감지 |
| apt 패키지 | zsh, git, curl, wget, unzip, xclip |
| CLI 도구 | eza, fd, bat, fzf, zoxide, starship, nvm, superfile, yazi |
| Nerd Font | JetBrainsMono |
| Symlink | .zshrc, starship.toml, yazi, superfile, tmux (+ wezterm on Mac) |
| Claude 설정 | `claude/install.sh` 호출 → `~/.claude` 로 복사 |
| 기본 셸 | zsh로 변경 |

이미 설치된 도구는 자동 스킵 (멱등성).

## Claude Code 설정

`claude/` 디렉토리에 공유 가능한 Claude 설정만 담는다 (자격증명·세션·캐시는 제외).

```bash
# 단독 실행도 가능 (install.sh에 포함되어 자동 실행됨)
bash ~/dotfiles/claude/install.sh
```

| 공유 ✅ | 로컬 전용 ❌ (건드리지 않음) |
|---------|------------------------------|
| `settings.json` (플러그인·마켓플레이스 선언) | `.credentials.json` (OAuth/키) |
| `CLAUDE.md` (개인 전역 지침) | `settings.local.json` (머신별 권한) |
| | `sessions/` · `history.jsonl` · `cache/` |
| | `plugins/` · `projects/` · `shell-snapshots/` |

**동작 방식**
- **복사(copy)** 방식 — 기존 파일은 `~/.claude/.dotfiles-backup.<timestamp>/` 로 백업 후 덮어씀.
- 내용이 같으면 스킵 (멱등성).
- **플러그인은 선언적으로 관리**: `plugins/` 캐시(절대경로·stale 상태)는 커밋하지 않고,
  `settings.json` 의 `enabledPlugins`/마켓플레이스만 공유 → 첫 `claude` 실행 시 자동 재설치.
- 로그인은 머신마다 `claude` 실행 후 직접 인증.

## 머신별 설정

`~/.zshrc.local`에서 머신 전용 경로를 관리:

```bash
# GPU 서버 예시
export PATH="/usr/local/cuda-11.8/bin:/opt/nvim-linux64/bin:$PATH"
export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH
export EDITOR=/opt/nvim-linux64/bin/nvim
```

이 파일은 gitignore 대상. 머신마다 다르게 설정.

## Zsh 플러그인 (zinit)

| 플러그인 | 설명 |
|----------|------|
| zsh-completions | 수백 개 명령어 tab completion |
| fzf-tab | tab → fzf 팝업 |
| zsh-autosuggestions | 히스토리 기반 자동 제안 |
| fast-syntax-highlighting | 실시간 구문 하이라이팅 |
| history-search-multi-word | Ctrl+R 다중 키워드 검색 |
| you-should-use | alias 알림 |
| sudo (omz) | ESC ESC → sudo 붙이기 |
| command-not-found (omz) | 패키지 설치 안내 |

## 주요 단축키

### 셸

| 키 | 기능 |
|----|------|
| `jk` | vi normal mode |
| `Ctrl+R` | 히스토리 검색 (multi-word) |
| `Ctrl+E` | autosuggestion accept |
| `↑` / `↓` | 입력 기반 히스토리 검색 |

### Git aliases

| alias | 명령 |
|-------|------|
| `gst` | git status |
| `gc "msg"` | git commit -m |
| `gp` | git push origin HEAD |
| `glog` | git log --graph |
| `ga` | git add -p |
| `gco` | git checkout |

### 도구

| 명령 | 설명 |
|------|------|
| `z <dir>` | zoxide (스마트 cd) |
| `spf` | superfile (듀얼패널 파일 매니저) |
| `yazi` | yazi (파일 매니저 + 이미지 프리뷰) |
| `vf` | fzf로 파일 찾아서 nvim으로 열기 |
| `cx <dir>` | cd + ls |
| `extract <file>` | 압축 해제 (tar/zip/7z 등) |

### WezTerm + tmux (Mac)

| 키 | 기능 |
|----|------|
| `Cmd+\` | SSH 호스트 선택 |
| `Cmd+,` | tmux 세션 선택 |
| `Cmd+Shift+N` | 새 세션 |
| `Cmd+t` / `Cmd+w` | 윈도우 열기/닫기 |
| `Cmd+1~5` | 윈도우 이동 |
| `Cmd+Shift+D/E` | 수직/수평 분할 |
| `Ctrl+hjkl` | pane 이동 |
| `Cmd+z` | pane 줌 |
| `Cmd+f` | yazi |
