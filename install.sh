#!/bin/bash
# Ubuntu dotfiles 설치 스크립트

set -e

echo "🚀 dotfiles 설치 시작..."

# 색상 정의
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}→${NC} $1"
}

print_done() {
    echo -e "${GREEN}✓${NC} $1"
}

# 1. 필수 패키지 설치
print_step "필수 패키지 설치..."
sudo apt update
sudo apt install -y git curl tmux fzf xclip unzip fontconfig

# 2. yazi 설치 (최신 바이너리)
print_step "yazi 설치..."
if ! command -v yazi &> /dev/null; then
    YAZI_VERSION=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep tag_name | cut -d '"' -f 4)
    curl -Lo /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip"
    unzip -o /tmp/yazi.zip -d /tmp/yazi
    sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
    sudo chmod +x /usr/local/bin/yazi
    rm -rf /tmp/yazi /tmp/yazi.zip
    print_done "yazi 설치 완료"
else
    print_done "yazi 이미 설치됨"
fi

# 3. yazi 의존성 (이미지/PDF 프리뷰용)
print_step "yazi 의존성 설치..."
sudo apt install -y ffmpegthumbnailer poppler-utils

# 4. tmux 설정 복사
print_step "tmux 설정 복사..."
mkdir -p ~/.config/tmux
cp tmux/tmux.conf ~/.config/tmux/tmux.conf
cp tmux/tmux.reset.conf ~/.config/tmux/tmux.reset.conf
ln -sf ~/.config/tmux/tmux.conf ~/.tmux.conf
print_done "tmux 설정 완료"

# 5. TPM (Tmux Plugin Manager) 설치
print_step "TPM 설치..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    print_done "TPM 설치 완료"
else
    print_done "TPM 이미 설치됨"
fi

# 6. yazi 설정 복사
print_step "yazi 설정 복사..."
mkdir -p ~/.config/yazi
cp yazi/yazi.toml ~/.config/yazi/yazi.toml
print_done "yazi 설정 완료"

# 7. Nerd Font 설치 (아이콘용)
print_step "Nerd Font 설치..."
FONT_DIR="$HOME/.local/share/fonts"
if [ ! -f "$FONT_DIR/FiraCodeNerdFont-Regular.ttf" ]; then
    mkdir -p "$FONT_DIR"
    curl -Lo /tmp/FiraCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    unzip -o /tmp/FiraCode.zip -d "$FONT_DIR"
    fc-cache -fv
    rm /tmp/FiraCode.zip
    print_done "Nerd Font 설치 완료"
else
    print_done "Nerd Font 이미 설치됨"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}✅ 설치 완료!${NC}"
echo "=========================================="
echo ""
echo "다음 단계:"
echo "  1. tmux 실행: tmux"
echo "  2. TPM 플러그인 설치: Ctrl+A I (대문자 I)"
echo "  3. tmux 재시작"
echo ""
echo "단축키:"
echo "  Ctrl+A s  → 세션 선택 (fzf)"
echo "  Ctrl+A S  → 새 세션 생성"
echo "  Ctrl+A f  → yazi 파일 매니저"
echo "  Ctrl+A p  → floax 팝업"
echo "  Ctrl+A g  → SSH 호스트 선택"
echo ""
