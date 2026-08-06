#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Finder 기본 앱 지정
#   기본값은 OpenInTerminal (Terminal.app 새 창의 nvim). 다른 앱으로 보내려면
#   인자로 번들 ID 를 넘긴다:
#     set-default-apps.sh                      → Terminal.app + nvim
#     set-default-apps.sh com.apple.TextEdit   → TextEdit
#
#   되돌리려면: duti -s com.apple.TextEdit <확장자> all
# ============================================================================

BUNDLE_ID="${1:-local.openinterminal}"

# install.sh 가 set -e 로 부르므로 여기서 실패해도 0 으로 빠진다.
# Finder 연동 하나 때문에 Claude 설정·기본 셸 변경까지 건너뛰면 손해가 크다.
command -v duti >/dev/null 2>&1 || { echo "duti 가 없습니다 (brew install duti) — 건너뜁니다."; exit 0; }

# 대상 앱이 실제로 있는지 확인 (없는 앱을 지정하면 Finder 가 깨진다).
# install.sh 가 set -e 로 부르므로, 여기서 exit 1 하면 그 뒤 단계(Claude 설정·
# 기본 셸 변경)까지 통째로 중단된다. 경고만 하고 0 으로 빠진다.
if ! mdfind "kMDItemCFBundleIdentifier == '$BUNDLE_ID'" 2>/dev/null | grep -q .; then
    echo "번들 ID '$BUNDLE_ID' 인 앱을 찾을 수 없습니다 — Finder 기본 앱 지정을 건너뜁니다."
    exit 0
fi
echo "핸들러: $BUNDLE_ID"
echo ""

# 문서·설정
DOC_EXTS=(md markdown json xml yaml yml toml txt log conf ini env csv tsv properties)
# 소스코드
# dockerfile/makefile 은 확장자가 아니라 파일명이라 확장자 매핑 대상이 아니다.
SRC_EXTS=(py js mjs cjs ts tsx jsx go rs rb php pl lua vim sh bash zsh fish
          c h cpp cc hpp java kt swift scala sql gradle)

failed=()
for ext in "${DOC_EXTS[@]}" "${SRC_EXTS[@]}"; do
    if duti -s "$BUNDLE_ID" "$ext" all 2>/dev/null; then
        printf '  %-12s ✓\n' ".$ext"
    else
        failed+=("$ext")
    fi
done

echo ""
total=$((${#DOC_EXTS[@]} + ${#SRC_EXTS[@]}))
echo "$((total - ${#failed[@]}))/$total 개 확장자 매핑 완료"

if ((${#failed[@]})); then
    cat <<EOF

아래 확장자는 macOS 가 아직 모르는 타입이라 동적 UTI(dyn.xxx)로 잡혀 자동 지정이 거부됐다:
  ${failed[*]}

해결: Finder 에서 해당 파일 하나를 우클릭 → 정보 가져오기 → "다음으로 열기"
      → 원하는 앱 선택 → "모두 변경".
      (재로그인 후 이 스크립트를 다시 돌리면 자동으로 잡히기도 한다)
EOF
fi
