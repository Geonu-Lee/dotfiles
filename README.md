# Dotfiles

## Ubuntu Server (install.sh)

zoxide + superfile + yazi 설정

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install.sh
```

### 설치되는 것

- **zoxide**: 스마트 cd (디렉토리 점프)
- **superfile**: 듀얼패널 터미널 파일 매니저
- **yazi**: 터미널 파일 매니저 (이미지 프리뷰 지원)
- **fzf**: fuzzy finder

## Mac (수동 설치)

### WezTerm

```bash
cp -r wezterm/* ~/.config/wezterm/
```

### tmux

```bash
cp tmux/.tmux.conf ~/.tmux.conf
cp tmux/tmux.reset.conf ~/.config/tmux/
cp -r tmux/scripts ~/.config/tmux/
```

## 단축키

### WezTerm + tmux

| 키 | 기능 |
|----|------|
| `Cmd+\` | SSH 호스트 선택 |
| `Cmd+,` | tmux 세션 선택 |
| `Cmd+Shift+N` | 새 세션 생성 |
| `Cmd+t` | 새 윈도우 |
| `Cmd+w` | 윈도우/pane 닫기 |
| `Cmd+1~5` | 윈도우 이동 |
| `Cmd+Shift+D` | 수직 분할 |
| `Cmd+Shift+E` | 수평 분할 |
| `Ctrl+hjkl` | pane 이동 |
| `Cmd+z` | pane 줌 |
| `Cmd+f` | yazi 파일 매니저 |
| `Cmd+Shift+B` | 배경화면 토글 |

### zoxide

```bash
z <dir>     # 스마트 cd
zi          # interactive 모드
```

### superfile (spf)

| 키 | 기능 |
|----|------|
| `h/l` | 패널 이동 |
| `j/k` | 위/아래 이동 |
| `e` | 파일 편집 (nvim) |
| `q` | 종료 |

### yazi

| 키 | 기능 |
|----|------|
| `hjkl` | 이동 |
| `Enter` | 열기 |
| `q` | 종료 |
