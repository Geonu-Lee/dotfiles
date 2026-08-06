# Dotfiles

한 줄이면 어디서든 동일한 셸 환경.

| 플랫폼 | 상태 |
|--------|------|
| macOS | 주 사용 환경. 실제로 검증됨 |
| Ubuntu / Debian | 지원. **아직 실기 검증은 안 됨** |
| Windows | 미지원 — WSL2 안에서 Ubuntu 경로로 동작 |

Debian 계열에서는 neovim 을 apt 대신 공식 릴리스로 설치한다 (apt 버전이 플러그인 요구치 0.9 미만인 경우가 많음).
Finder 연동·Brewfile 은 macOS 전용이라 자동으로 건너뛴다.

```bash
git clone https://github.com/ljj727/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

| 옵션 | 설치 범위 |
|------|-----------|
| (없음) | 셸·터미널 환경 + Claude 설정 전부 |
| `--no-claude` | **셸·터미널 환경만** (zsh·tmux·nvim·CLI 도구·Finder 연동) |
| `--help` | 도움말 |

Claude 설정만 따로 하려면 `bash ~/dotfiles/claude/install.sh`
(`--dry-run` 을 붙이면 뭐가 바뀌는지 미리 볼 수 있다).

## 새 맥 세팅 (맥을 갈아탈 때)

새 맥에는 Homebrew조차 없으므로 `install.sh`가 그것부터 깔고 `Brewfile`로 앱·도구를 일괄 복원한다.

```bash
xcode-select --install                                       # 1. CLT (git 필요)
git clone https://github.com/ljj727/dotfiles.git ~/dotfiles  # 2. clone
bash ~/dotfiles/install.sh                                   # 3. 나머지 전부
```

순서대로 Homebrew → Brewfile(앱·CLI·npm 전역) → Nerd Font → symlink → Claude 설정 → 기본 셸 zsh 까지 진행된다.

| 알아둘 것 | 내용 |
|-----------|------|
| 소요 시간 | Brewfile 전체 설치는 수십 분. GUI 앱(cask)이 대부분의 시간을 차지한다 |
| 암호 입력 | Homebrew 설치와 일부 cask에서 sudo 암호를 물어본다 (완전 무인 진행은 불가) |
| 업그레이드 안 함 | `--no-upgrade`로 **없는 것만** 설치. 기존 패키지를 멋대로 업그레이드하지 않는다 |
| 수동으로 남는 것 | App Store 앱, 로그인·자격증명, 은행 보안 플러그인, 시스템 설정 |

**Brewfile 갱신** — 앱을 새로 깔거나 지운 뒤 현재 상태를 다시 덤프:

```bash
cd ~/dotfiles && brew bundle dump --force --file=Brewfile
```

## 구조

```
~/dotfiles/
├── install.sh                  # bootstrap (이것만 실행)
├── Brewfile                    # macOS 앱·CLI·npm 전역 패키지 목록 (brew bundle)
├── zsh/.zshrc                  # portable zshrc (zinit + plugins)
├── starship/starship.toml      # 프롬프트 테마
├── tmux/.tmux.conf             # tmux 설정 (기본값 + history-limit/mouse 만)
├── yazi/yazi.toml              # yazi 파일 매니저
├── nvim/                       # Neovim (직접 구성, LSP 없음). ~/.config/nvim 으로 심링크
├── bin/open-in-terminal        # Finder에서 연 파일 → Terminal.app + nvim 으로 열기
├── macos/                      # macOS 전용 (Finder 기본 앱 지정, .app 래퍼)
├── claude/                     # Claude Code 설정 (자세히는 claude/README.md)
│   └── install.sh              #   → ~/.claude 로 복사 (로컬 전용 파일 보존)
└── local/.zshrc.local.example  # 머신별 설정 예시
```

## Neovim

배포판(LazyVim) 없이 **직접 구성**한다 (kickstart 방식). 플러그인 매니저 `lazy.nvim` 만
쓰고, 배포판 LazyVim 은 쓰지 않는다 — 둘은 별개다.

**원칙** (`nvim/init.lua` 머리말)
- 모든 줄을 이해한 상태를 유지한다. 이해 못 하는 설정은 넣지 않는다
- **LSP·자동완성은 넣지 않았다.** 코드 인텔리전스는 Claude Code 가 담당하고 nvim 은
  편집·열람에 집중한다. 필요해지면 `init.lua` 에 추가하면 된다
- 플러그인 목표: 15개 이하 — **현재 18개로 목표를 넘겼다**

`nvim/` 을 `~/.config/nvim` 으로 **심링크**한다. `lazy-lock.json`(플러그인 버전 고정)을
nvim 이 직접 갱신하므로, 심링크여야 그 변경이 repo 에 남는다.

새 머신에서는 첫 `nvim` 실행 시 lazy.nvim 이 `lazy-lock.json` 에 적힌 버전 그대로
플러그인을 받는다. 헤드리스로 미리 받으려면:

```bash
nvim --headless "+Lazy! sync" +qa
```

### 플러그인 (18개)

| 플러그인 | 얻는 것 |
|----------|---------|
| fzf-lua | 파일·그렙·버퍼 찾기. 이미 깔린 fd·ripgrep 을 그대로 쓴다 |
| snacks.nvim | 파일 트리(explorer) · 이미지 · 큰 파일 최적화 · 알림 · 들여쓰기 안내선 |
| grug-far.nvim | 프로젝트 전역 찾기·바꾸기. LSP rename 이 없으므로 심볼 개명은 이걸로 |
| gitsigns.nvim | 변경 표시 · hunk 이동 · blame · 되돌리기 (커밋은 lazygit) |
| flash.nvim | 두 글자로 화면 아무 곳이나 점프 |
| persistence.nvim | 디렉토리별 버퍼·창 배치 복원 |
| treesitter | 구문 하이라이팅·구조 인식 (24개 언어). LSP 가 없어 실질 필수 |
| blink.cmp | 자동완성 — 경로와 버퍼 안 단어만 (LSP 소스 없음) |
| render-markdown.nvim | 마크다운을 편집하면서 렌더링된 모습으로 |
| mini.pairs / mini.surround / mini.bufremove | 괄호 자동 닫기 · 둘러싸기 · 창 유지하며 버퍼 닫기 |
| todo-comments.nvim | TODO·FIXME 강조 및 목록 |
| undotree | undo 이력을 트리로 (`undofile` 이라 파일을 닫아도 남는다) |
| lualine · bufferline · which-key | 상태줄 · 버퍼 탭줄 · 키맵 안내 |
| dracula.nvim | 색 테마 |

### 키맵 (leader = `Space`)

| 키 | 기능 |
|----|------|
| `<leader><space>` · `ff` | 파일 찾기 |
| `<leader>fg` · `fw` | 전역 그렙 · 커서 단어 그렙 |
| `<leader>fb` · `fr` · `fs` | 버퍼 · 최근 파일 · git 변경 파일 |
| `<leader>sr` · `sR` · `sw` | 찾기·바꾸기 (현재 확장자 / 전체 / 커서 단어) |
| `<leader>e` | 파일 트리 (`Tab` 은 커서를 트리에 둔 채 오른쪽에 연다) |
| `s` | 두 글자 점프 |
| `]h` `[h` · `<leader>gp` `gr` `gb` `gd` | git hunk 이동 · 미리보기·되돌리기·blame·diff |
| `<leader>um` · `uu` | 마크다운 렌더 토글 · undo 트리 |
| `<leader>qs` | 이 폴더 세션 복원 |
| `<leader>ft` · `]t` `[t` | TODO 목록 · 이동 |
| `<leader>bd` | 버퍼 닫기 (창 배치 유지) |
| `S-h` / `S-l`, `[b` / `]b` | 이전 / 다음 버퍼 |
| `Ctrl+hjkl` | 창 이동 |
| `jk` (insert) | Esc |
| `saiw"` · `sd"` · `sr"'` | 둘러싸기 · 제거 · 교체 |

문서 파일(`markdown`·`text`·`gitcommit`)은 열면 자동으로 줄바꿈·맞춤법(en_us)이 켜지고
`j`/`k` 가 화면 기준으로 움직인다.

**이미지 인라인 표시**(`snacks.image`, 마크다운 안의 이미지)는 조건이 더 필요하다 —
kitty graphics 지원 터미널(Terminal.app 은 미지원), `imagemagick`, tmux 안이라면
`allow-passthrough`. 지금 구성에서는 동작하지 않는다.

## Finder 기본 앱 (macOS)

`md`/`json`/`yaml`/소스코드 등 44개 확장자를 더블클릭했을 때 열릴 앱을 `duti` 로 지정한다.
**현재 기본값은 Terminal.app 새 창의 nvim.**

```bash
bash macos/set-default-apps.sh                      # → Terminal.app 새 창의 nvim (기본값)
bash macos/set-default-apps.sh <번들ID>              # → 다른 앱으로 지정
```

터미널로 여는 쪽을 고르면 `OpenInTerminal.app` 이 처리한다. Finder 가 CLI 를 직접 호출할 수 없어
`.app` 래퍼가 필요하기 때문이다. `osascript` 의 `do script` 로 Terminal.app 새 창을 띄운다.

**구성 요소**

| 파일 | 역할 |
|------|------|
| `macos/set-default-apps.sh` | `duti` 로 확장자별 기본 앱 지정 (인자로 번들 ID 전달 가능) |
| `bin/open-in-terminal` | Terminal.app + nvim 으로 파일 열기 |
| `macos/OpenInTerminal.applescript` | Finder 가 CLI 를 못 부르므로 필요한 `.app` 래퍼 소스 |
| `macos/build-open-in-terminal.sh` | `~/Applications/OpenInTerminal.app` 빌드 (sudo 불필요) |

**되돌리기** — `duti -s com.apple.TextEdit md all` 처럼 원하는 앱으로 다시 지정.

**한계** — `toml`, `conf`, `go`, `rs`, `lua` 등 macOS가 모르는 확장자는 동적 UTI로 잡혀
`duti` 자동 지정이 거부된다. Finder에서 한 번만 "정보 가져오기 → 다음으로 열기 → 모두 변경" 하면 된다.

## install.sh이 하는 일

| 단계 | 내용 |
|------|------|
| OS 감지 | Ubuntu/Debian/macOS 자동 감지 |
| apt 패키지 | zsh, git, curl, wget, unzip, xclip, build-essential, ripgrep, tmux, ruby (Debian) |
| Homebrew | 없으면 설치 (macOS) |
| Brewfile | 앱·CLI·npm 전역 일괄 설치 (macOS, `--no-upgrade`) |
| CLI 도구 | eza, fd, bat, jq, fzf, zoxide, starship, nvm, yazi, neovim, tmuxinator |
| Nerd Font | JetBrainsMono (Debian 전용 — mac 은 Brewfile cask) |
| Symlink | .zshrc, starship, yazi, tmux, nvim |
| Finder 연동 | 기본 앱 지정 + `.app` 래퍼 빌드 (macOS) |
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
| `statusline.sh` · `keybindings.json` · `themes/` | `sessions/` · `history.jsonl` · `cache/` |
| `commands/` · `agents/` · `skills/` | `plugins/` · `projects/` · `shell-snapshots/` |

**외형·조작 설정** (자세히는 `claude/README.md`)

| 항목 | 파일 | 내용 |
|------|------|------|
| 테마 | `settings.json` 의 `theme` | 현재 `light`. 다크로 바꾸려면 `"custom:catppuccin-mocha"` (파일은 `themes/` 에 준비돼 있음) |
| 상태줄 | `statusline.sh` | 모델 · 컨텍스트 게이지 · git 브랜치 · 사용량 · 경로 (`jq` 필요) |
| 키맵 | `keybindings.json` | transcript 뷰(`Ctrl+O`) 반페이지 스크롤 `u`/`d` |
| 알림음 | `settings.json` 의 hook | 응답 완료 시 Glass 사운드 (macOS 전용, 그 외엔 무해하게 무시) |

**동작 방식**
- **복사(copy)** 방식 — 기존 파일은 `~/.claude/.dotfiles-backup.<timestamp>/` 로 백업 후 덮어씀.
- 내용이 같으면 스킵 (멱등성). JSON은 Claude Code가 키 순서를 바꿔 다시 쓰므로 **정규화 후 비교**한다.
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
| `jj` | vi normal mode (nvim 의 insert Esc 는 `jk` 로 다름) |
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
| `yazi` | yazi (파일 매니저 + 이미지 프리뷰) |
| `vf` | fzf로 파일 찾아서 nvim으로 열기 |
| `cx <dir>` | cd + ls |
| `extract <file>` | 압축 해제 (tar/zip/7z 등) |

### tmux 기본 키 (prefix = `Ctrl+B`)

터미널 에뮬레이터는 관리하지 않는다 (macOS 기본 Terminal.app 사용). 창·분할·세션은
전부 tmux 가 맡고, 터미널 고유 키맵이 없으므로 **어느 터미널에서든 조작이 같다.**

| 키 | 기능 | | 키 | 기능 |
|----|------|-|----|------|
| `%` | 좌우 분할 | | `d` | detach (세션은 살아있음) |
| `"` | 위아래 분할 | | `s` / `w` | 세션 / 윈도우 선택 |
| `방향키` | pane 이동 | | `c` / `&` | 윈도우 생성 / 닫기 |
| `o` | 다음 pane | | `n` / `p` | 다음 / 이전 윈도우 |
| `z` | pane 줌 | | `,` | 윈도우 이름 변경 |
| `x` | pane 닫기 | | `[` | 스크롤·복사 모드 (`q` 로 나감) |
| `space` | 레이아웃 순환 | | `?` | 전체 키 목록 |

```bash
tmux ls                  # 세션 목록
tmux attach -t main      # 붙기
tmux source ~/.tmux.conf # 설정 리로드 (kill-server 하지 말 것 — 세션 날아감)
```

**터미널을 열자마자 tmux 로** — Terminal.app 환경설정 → 프로파일 → 셸 →
"시작 시 실행할 명령" 에 `tmux new-session -A -s main` 을 넣으면 된다.
`-A` 라서 세션이 있으면 붙고 없으면 만든다. 단 창을 두 개 열면 같은 세션이
미러링되므로, 작업을 나눌 때는 창이 아니라 tmux 윈도우(`Ctrl+B` `c`)를 쓴다.
