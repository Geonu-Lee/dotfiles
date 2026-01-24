# Dotfiles (Ubuntu Server)

tmux + yazi 설정 for Ubuntu

## 설치

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## 설치되는 것

- **tmux**: 터미널 멀티플렉서 + Catppuccin 테마
- **yazi**: 터미널 파일 매니저 (이미지 프리뷰 지원)
- **fzf**: fuzzy finder
- **TPM**: tmux 플러그인 매니저

## 단축키

### tmux (Prefix: Ctrl+A)

| 키 | 기능 |
|----|------|
| `s` | 세션 선택 (fzf) |
| `S` | 새 세션 생성 |
| `f` | yazi 파일 매니저 |
| `p` | floax 팝업 |
| `g` | SSH 호스트 선택 |
| `v` | 수평 분할 |
| `s` | 수직 분할 |
| `hjkl` | pane 이동 |
| `e/E` | pane 균등 분배 |
| `z` | pane 줌 |
| `H/L` | 이전/다음 윈도우 |

### yazi

| 키 | 기능 |
|----|------|
| `hjkl` | 이동 |
| `Enter` | 열기 |
| `q` | 종료 |
| `/` | 검색 |
| `y/p` | 복사/붙여넣기 |
| `d` | 삭제 |

## WezTerm SSH 연결

Mac에서 WezTerm SSH로 연결하면 이미지 프리뷰도 작동:

```bash
wezterm ssh user@server
```
