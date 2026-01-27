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
sudo apt install -y git curl fzf xclip unzip fontconfig

# 2. zoxide 설치
print_step "zoxide 설치..."
if ! command -v zoxide &> /dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    print_done "zoxide 설치 완료"
else
    print_done "zoxide 이미 설치됨"
fi

# 3. superfile 설치
print_step "superfile 설치..."
if ! command -v spf &> /dev/null; then
    curl -sSL https://superfile.netlify.app/install.sh | bash
    print_done "superfile 설치 완료"
else
    print_done "superfile 이미 설치됨"
fi

# 4. yazi 설치 (최신 바이너리)
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

# 5. yazi 설정 복사
print_step "yazi 설정 복사..."
mkdir -p ~/.config/yazi
cp yazi/yazi.toml ~/.config/yazi/yazi.toml
print_done "yazi 설정 완료"

# 6. superfile 설정 복사
print_step "superfile 설정 복사..."
mkdir -p ~/.config/superfile
if [ -f superfile/config.toml ]; then
    cp superfile/config.toml ~/.config/superfile/config.toml
    print_done "superfile 설정 완료"
else
    print_done "superfile 기본 설정 사용"
fi

# 7. zshrc에 zoxide 초기화 추가
print_step "zoxide 설정..."
if ! grep -q 'eval "$(zoxide init' ~/.zshrc 2>/dev/null; then
    echo '' >> ~/.zshrc
    echo '# zoxide - smarter cd' >> ~/.zshrc
    echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
    print_done "zoxide zshrc 설정 완료"
else
    print_done "zoxide zshrc 이미 설정됨"
fi

# 8. Nerd Font 설치 (아이콘용)
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
echo "사용법:"
echo "  spf       → superfile 파일 매니저"
echo "  yazi      → yazi 파일 매니저"
echo "  z <dir>   → zoxide (스마트 cd)"
echo "  zi        → zoxide interactive"
echo ""
echo "superfile 단축키:"
echo "  e         → 파일 편집 (nvim)"
echo "  q         → 종료"
echo "  h/l       → 패널 이동"
echo "  j/k       → 위/아래 이동"
echo ""
echo "※ 새 터미널을 열거나 'source ~/.zshrc' 실행"
echo ""
