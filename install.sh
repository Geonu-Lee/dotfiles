#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Dotfiles Bootstrap
# 사용법: bash ~/dotfiles/install.sh
# 멱등성: 이미 설치된 도구는 스킵
# ============================================================================

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${BLUE}→${NC} $*"; }
ok()    { echo -e "${GREEN}✓${NC} $*"; }
skip()  { echo -e "${YELLOW}⊘${NC} $*  (이미 설치됨)"; }
err()   { echo -e "${RED}✗${NC} $*"; exit 1; }

# ============================================================================
# OS 감지
# ============================================================================
OS="unknown"
if [[ "$OSTYPE" == darwin* ]]; then
    OS="mac"
elif [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" == "ubuntu" || "$ID" == "debian" || "$ID_LIKE" == *"debian"* ]]; then
        OS="debian"
    fi
fi

if [[ "$OS" == "unknown" ]]; then
    err "지원하지 않는 OS. Ubuntu/Debian/macOS만 지원."
fi

echo ""
echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Dotfiles Installer             ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
echo ""
info "OS: $OS"
echo ""

# ============================================================================
# 헬퍼: symlink (기존 파일 백업)
# ============================================================================
backup_and_link() {
    local src="$1" dst="$2"

    if [[ -L "$dst" ]]; then
        if [[ "$(readlink "$dst")" == "$src" ]]; then
            skip "symlink $dst"
            return
        fi
        rm "$dst"
    elif [[ -f "$dst" ]]; then
        local bak="${dst}.bak.$(date +%Y%m%d%H%M%S)"
        info "백업: $dst → $bak"
        mv "$dst" "$bak"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    ok "symlink $dst → $src"
}

# ============================================================================
# 1. 기본 패키지 (Debian/Ubuntu)
# ============================================================================
if [[ "$OS" == "debian" ]]; then
    info "apt 패키지 설치..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq zsh git curl wget unzip xclip fontconfig > /dev/null 2>&1
    ok "기본 패키지"
fi

# ============================================================================
# 1.5 Homebrew + Brewfile (macOS)
#     새 맥 부트스트랩: brew 자체가 없으므로 먼저 설치한 뒤 Brewfile을 적용한다.
#     --no-upgrade: 없는 것만 설치. 기존 패키지를 대량 업그레이드하지 않는다.
# ============================================================================
if [[ "$OS" == "mac" ]]; then
    echo ""
    if command -v brew &> /dev/null; then
        skip "Homebrew"
    else
        info "Homebrew 설치 (암호 입력이 필요할 수 있음)..."
        NONINTERACTIVE=1 /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            [[ -x "$brew_bin" ]] && eval "$("$brew_bin" shellenv)" && break
        done
        command -v brew &> /dev/null || err "Homebrew 설치 실패"
        ok "Homebrew"
    fi

    if [[ -f "$DOTFILES/Brewfile" ]]; then
        info "Brewfile 적용 (앱·CLI 도구 일괄 설치, 시간이 오래 걸릴 수 있음)..."
        brew bundle install --file="$DOTFILES/Brewfile" --no-upgrade
        ok "Brewfile"
    fi
fi

# ============================================================================
# 2. CLI 도구 설치 (Debian용 — mac은 위 Brewfile에서 이미 처리됨)
# ============================================================================
echo ""
info "CLI 도구 설치..."

# --- eza ---
if command -v eza &> /dev/null; then
    skip "eza"
else
    if [[ "$OS" == "debian" ]]; then
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null || true
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt-get update -qq && sudo apt-get install -y -qq eza > /dev/null 2>&1
    elif [[ "$OS" == "mac" ]]; then
        brew install eza
    fi
    ok "eza"
fi

# --- fd ---
if command -v fdfind &> /dev/null || command -v fd &> /dev/null; then
    skip "fd"
else
    if [[ "$OS" == "debian" ]]; then
        sudo apt-get install -y -qq fd-find > /dev/null 2>&1
        if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
            mkdir -p "$HOME/.local/bin"
            ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
        fi
    elif [[ "$OS" == "mac" ]]; then
        brew install fd
    fi
    ok "fd"
fi

# --- bat ---
if command -v batcat &> /dev/null || command -v bat &> /dev/null; then
    skip "bat"
else
    if [[ "$OS" == "debian" ]]; then
        sudo apt-get install -y -qq bat > /dev/null 2>&1
    elif [[ "$OS" == "mac" ]]; then
        brew install bat
    fi
    ok "bat"
fi

# --- jq (Claude Code 상태줄이 사용) ---
if command -v jq &> /dev/null; then
    skip "jq"
else
    if [[ "$OS" == "debian" ]]; then
        sudo apt-get install -y -qq jq > /dev/null 2>&1
    elif [[ "$OS" == "mac" ]]; then
        brew install jq
    fi
    ok "jq"
fi

# --- fzf ---
if command -v fzf &> /dev/null; then
    skip "fzf"
else
    if [[ "$OS" == "debian" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" 2>/dev/null
        "$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
    elif [[ "$OS" == "mac" ]]; then
        brew install fzf
    fi
    ok "fzf"
fi

# --- zoxide ---
if command -v zoxide &> /dev/null; then
    skip "zoxide"
else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    ok "zoxide"
fi

# --- starship ---
if command -v starship &> /dev/null; then
    skip "starship"
else
    curl -sSfL https://starship.rs/install.sh | sh -s -- -y
    ok "starship"
fi

# --- nvm ---
if [[ -d "$HOME/.nvm" ]]; then
    skip "nvm"
else
    curl -sSfLo- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    ok "nvm"
fi

# --- superfile ---
if command -v spf &> /dev/null; then
    skip "superfile"
else
    curl -sSL https://superfile.netlify.app/install.sh | bash
    ok "superfile"
fi

# --- yazi ---
if command -v yazi &> /dev/null; then
    skip "yazi"
else
    if [[ "$OS" == "debian" ]]; then
        YAZI_VERSION=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep tag_name | cut -d '"' -f 4)
        curl -Lo /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip"
        unzip -oq /tmp/yazi.zip -d /tmp/yazi
        sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
        sudo chmod +x /usr/local/bin/yazi
        rm -rf /tmp/yazi /tmp/yazi.zip
    elif [[ "$OS" == "mac" ]]; then
        brew install yazi
    fi
    ok "yazi"
fi

# ============================================================================
# 3. Nerd Font
# ============================================================================
echo ""
FONT_DIR="$HOME/.local/share/fonts"
if fc-list 2>/dev/null | grep -qi "JetBrainsMono\|FiraCode"; then
    skip "Nerd Font"
else
    info "JetBrainsMono Nerd Font 설치..."
    mkdir -p "$FONT_DIR"
    wget -qO /tmp/JetBrainsMono.zip \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -oq /tmp/JetBrainsMono.zip -d "$FONT_DIR"
    rm -f /tmp/JetBrainsMono.zip
    fc-cache -f "$FONT_DIR"
    ok "JetBrainsMono Nerd Font"
fi

# ============================================================================
# 4. Symlinks
# ============================================================================
echo ""
info "Symlink 설정..."

# zsh
backup_and_link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# starship
backup_and_link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"

# yazi
mkdir -p "$HOME/.config/yazi"
backup_and_link "$DOTFILES/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"

# superfile
mkdir -p "$HOME/.config/superfile"
backup_and_link "$DOTFILES/superfile/config.toml" "$HOME/.config/superfile/config.toml"

# tmux (Mac에서만 WezTerm과 함께 사용)
backup_and_link "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
mkdir -p "$HOME/.config/tmux"
backup_and_link "$DOTFILES/tmux/tmux.reset.conf" "$HOME/.config/tmux/tmux.reset.conf"
if [[ -d "$DOTFILES/tmux/scripts" ]]; then
    ln -sfn "$DOTFILES/tmux/scripts" "$HOME/.config/tmux/scripts"
fi

# wezterm (Mac only)
if [[ "$OS" == "mac" ]]; then
    mkdir -p "$HOME/.config/wezterm"
    for f in "$DOTFILES"/wezterm/*.lua; do
        backup_and_link "$f" "$HOME/.config/wezterm/$(basename "$f")"
    done
fi

# ============================================================================
# 5. ~/.zshrc.local (없을 때만 예시 복사)
# ============================================================================
if [[ ! -f "$HOME/.zshrc.local" ]]; then
    cp "$DOTFILES/local/.zshrc.local.example" "$HOME/.zshrc.local"
    ok "~/.zshrc.local 생성됨 — 머신에 맞게 수정하세요"
else
    skip "~/.zshrc.local"
fi

# ============================================================================
# 5.5 Claude Code 설정 (있을 때만)
# ============================================================================
if [[ -f "$DOTFILES/claude/install.sh" ]]; then
    echo ""
    info "Claude Code 설정 설치..."
    bash "$DOTFILES/claude/install.sh"
fi

# ============================================================================
# 6. 기본 셸 → zsh
# ============================================================================
echo ""
ZSH_PATH="$(which zsh)"
if [[ "$SHELL" == "$ZSH_PATH" ]]; then
    skip "zsh 기본 셸"
else
    info "기본 셸 → zsh"
    chsh -s "$ZSH_PATH"
    ok "기본 셸 변경 (다음 로그인부터 적용)"
fi

# ============================================================================
# 완료
# ============================================================================
echo ""
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo -e "${GREEN}  설치 완료!${NC}"
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo ""
echo "  다음 단계:"
echo "  1. exec zsh (또는 새 터미널)"
echo "  2. ~/.zshrc.local 머신별 설정 확인"
echo "  3. 터미널 폰트 → JetBrainsMono Nerd Font"
echo ""
echo "  주요 도구:"
echo "  z <dir>   zoxide (스마트 cd)"
echo "  spf       superfile (파일 매니저)"
echo "  yazi      yazi (파일 매니저)"
echo ""
