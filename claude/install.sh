#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Claude Code 설정 부트스트랩
# 사용법:
#   bash ~/dotfiles/claude/install.sh            실제 설치
#   bash ~/dotfiles/claude/install.sh --dry-run  미리보기 (아무것도 바꾸지 않음)
#
# 동작:  dotfiles/claude/* → ~/.claude/ 로 "복사"
# 기존 파일 처리:
#   - 같으면 스킵
#   - 다르면 백업(~/.claude/.dotfiles-backup.<시각>/) 후 덮어씀
#   - commands/agents/skills 는 merge: repo에 없는 로컬 파일은 보존
# 안전:  credentials / sessions / cache / history / settings.local.json /
#        plugins 등 로컬 전용 항목은 절대 건드리지 않음
# ============================================================================

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DST="$HOME/.claude"
STAMP="$(date +%Y%m%d%H%M%S)"
BACKUP="$DST/.dotfiles-backup.$STAMP"

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) DRY_RUN=1 ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "알 수 없는 옵션: $arg (사용법: --dry-run | --help)"; exit 1 ;;
  esac
done

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; NC='\033[0m'
info() { echo -e "${BLUE}→${NC} $*"; }
ok()   { echo -e "${GREEN}✓${NC} $*"; }
new()  { echo -e "${GREEN}+${NC} $*  (신규)"; }
over() { echo -e "${YELLOW}⟳${NC} $*  (덮어씀·백업)"; }
skip() { echo -e "${YELLOW}⊘${NC} $*  (동일·스킵)"; }
warn() { echo -e "${YELLOW}!${NC} $*"; }

# settings.json 의 enabledPlugins 중 값이 true 인 키만 추출 (python3 → grep 폴백)
read_enabled_plugins() {
  local f="$1"
  [[ -f "$f" ]] || return 0
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$f" <<'PY'
import json, sys
try:
    d = json.load(open(sys.argv[1]))
except Exception:
    sys.exit(0)
for k, v in d.get("enabledPlugins", {}).items():
    if v:
        print(k)
PY
  else
    grep -oE '"[^"]+@[^"]+"[[:space:]]*:[[:space:]]*true' "$f" | sed -E 's/^"([^"]+)".*/\1/'
  fi
}

# extraKnownMarketplaces 의 출처(github repo / url / path) 추출 (python3 필요)
read_marketplace_sources() {
  local f="$1"
  [[ -f "$f" ]] || return 0
  command -v python3 >/dev/null 2>&1 || return 0
  python3 - "$f" <<'PY'
import json, sys
try:
    d = json.load(open(sys.argv[1]))
except Exception:
    sys.exit(0)
for name, v in d.get("extraKnownMarketplaces", {}).items():
    s = v.get("source", {})
    arg = s.get("repo") or s.get("url") or s.get("path")
    if arg:
        print(arg)
PY
}

# 공유 대상 (이 목록만 배포 — 나머지 ~/.claude 항목은 로컬 전용으로 보존)
TOP_FILES=(settings.json CLAUDE.md)
SUB_DIRS=(commands agents skills)

echo ""
echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Claude Code Config Installer     ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
echo ""
info "소스: $SRC"
info "대상: $DST"
[[ "$DRY_RUN" == "1" ]] && warn "DRY-RUN: 미리보기만 — 실제로 아무것도 바꾸지 않습니다"
echo ""

backed_up=0
backup_file() {
  local target="$1"
  [[ "$DRY_RUN" == "1" ]] && return 0
  mkdir -p "$BACKUP/$(dirname "${target#$DST/}")"
  cp -a "$target" "$BACKUP/${target#$DST/}"
  backed_up=1
}
do_cp() {  # src dst — dry-run이면 실제 복사 생략
  [[ "$DRY_RUN" == "1" ]] && return 0
  mkdir -p "$(dirname "$2")"; cp "$1" "$2"
}

[[ "$DRY_RUN" == "1" ]] || mkdir -p "$DST"

# --- 1. 최상위 파일 (settings.json, CLAUDE.md) ---
for f in "${TOP_FILES[@]}"; do
  src="$SRC/$f"; dst="$DST/$f"
  [[ -f "$src" ]] || continue
  if [[ -f "$dst" ]] && cmp -s "$src" "$dst"; then
    skip "$f"
  elif [[ -f "$dst" ]]; then
    backup_file "$dst"; do_cp "$src" "$dst"; over "$f"
  else
    do_cp "$src" "$dst"; new "$f"
  fi
done

# --- 2. 디렉토리 merge (commands/, agents/, skills/) ---
# repo의 파일만 비교·복사한다. 대상에만 있는 로컬 파일은 손대지 않는다(보존).
for d in ${SUB_DIRS[@]+"${SUB_DIRS[@]}"}; do
  src="$SRC/$d"
  [[ -d "$src" ]] || continue
  while IFS= read -r srcfile; do
    rel="${srcfile#$src/}"; tgt="$DST/$d/$rel"
    if [[ -f "$tgt" ]] && cmp -s "$srcfile" "$tgt"; then
      skip "$d/$rel"
    elif [[ -f "$tgt" ]]; then
      backup_file "$tgt"; do_cp "$srcfile" "$tgt"; over "$d/$rel"
    else
      do_cp "$srcfile" "$tgt"; new "$d/$rel"
    fi
  done < <(find "$src" -type f -not -name '.DS_Store')
done

# --- 3. 플러그인 선언적 복원 (settings.json 의 enabledPlugins) ---
# plugins/ 캐시는 공유 안 함 → 선언된 플러그인을 마켓플레이스에서 직접 설치(멱등).
echo ""
# dry-run에서는 아직 settings.json을 복사 안 했을 수 있으니 소스 기준으로 미리보기
PLUGIN_SRC="$DST/settings.json"; [[ "$DRY_RUN" == "1" ]] && PLUGIN_SRC="$SRC/settings.json"
if command -v claude >/dev/null 2>&1; then
  info "마켓플레이스 등록..."
  while IFS= read -r m; do
    [[ -z "$m" ]] && continue
    if [[ "$DRY_RUN" == "1" ]]; then new "marketplace: $m (예정)"; continue; fi
    if claude plugin marketplace add "$m" >/dev/null 2>&1; then ok "marketplace: $m"
    else warn "marketplace 보류: $m  (이미 등록됐거나 claude 첫 실행 시 처리)"; fi
  done < <(read_marketplace_sources "$PLUGIN_SRC")

  info "선언된 플러그인 복원..."
  while IFS= read -r p; do
    [[ -z "$p" ]] && continue
    if [[ "$DRY_RUN" == "1" ]]; then new "plugin: $p (예정)"; continue; fi
    if claude plugin install "$p" >/dev/null 2>&1; then ok "plugin: $p"
    else warn "plugin 보류: $p  (claude 첫 실행 시 재시도됨)"; fi
  done < <(read_enabled_plugins "$PLUGIN_SRC")
else
  warn "claude CLI 없음 — 플러그인은 claude 설치 후 첫 실행 시 자동 설치됩니다"
fi

# --- 4. 로컬 전용 파일 안내 (절대 복사하지 않음) ---
echo ""
info "로컬 전용(공유 X) — 그대로 보존됨:"
echo "    .credentials.json · settings.local.json · sessions/ · cache/"
echo "    history.jsonl · projects/ · plugins/ · shell-snapshots/ 등"

# --- 5. 백업 안내 ---
echo ""
if [[ "$DRY_RUN" == "1" ]]; then
  warn "DRY-RUN 종료 — 실제 적용하려면 옵션 없이 다시 실행하세요"
elif [[ "$backed_up" == "1" ]]; then
  ok "덮어쓴 기존 파일 백업: $BACKUP"
else
  skip "백업 불필요 (덮어쓴 기존 파일 없음)"
  rmdir "$BACKUP" 2>/dev/null || true
fi

# --- 6. 완료 / 다음 단계 ---
echo ""
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo -e "${GREEN}  Claude 설정 ${NC}$([[ "$DRY_RUN" == "1" ]] && echo '미리보기 완료' || echo '설치 완료!')"
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo ""
echo "  • 머신 고유 설정은 settings.local.json 에 두세요 (이 스크립트가 건드리지 않음)."
echo "  • 로그인(자격증명)은 머신별로 'claude' 실행 후 직접 인증."
echo "  • 플러그인 변경 적용: 새 세션 또는 /reload-plugins."
echo ""
