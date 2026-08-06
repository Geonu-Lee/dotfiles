#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# OpenInTerminal.app 빌드 (sudo 불필요, ~/Applications 에 설치)
#   Finder 가 CLI(nvim)를 직접 호출할 수 없어 .app 래퍼가 필요하다.
# ============================================================================

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$HOME/Applications"
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

# macOS 가 모르는 확장자는 동적 UTI(dyn.xxx)로 잡혀 duti 가 핸들러를 못 박는다(error -50).
# 앱이 해당 타입을 직접 선언해 실제 UTI 를 만들어 준다.
UNKNOWN_EXTS=(toml conf ini env properties cjs jsx go rs lua vim fish kt scala sql gradle)

build_app() {
    local script="$1" app_name="$2" bundle_id="$3"
    local app="$APP_DIR/$app_name.app"
    local plist="$app/Contents/Info.plist"

    rm -rf "$app"

    # __OPEN_IN_TERMINAL__ 를 이 repo 의 실제 경로로 치환한 뒤 컴파일한다.
    # 예전에는 스크립트가 $HOME/dotfiles 를 하드코딩해서, repo 를 다른 곳에
    # clone 하면 더블클릭해도 조용히 아무 일도 일어나지 않았다.
    local helper="$(cd "$SRC/.." && pwd)/bin/open-in-terminal"
    [[ -x "$helper" ]] || { echo "  실행 가능한 $helper 가 없습니다"; return 1; }

    # osacompile 은 확장자로 소스를 판별하므로 임시 디렉토리에 같은 이름으로 만든다
    local tmpdir
    tmpdir="$(mktemp -d)"
    sed "s|__OPEN_IN_TERMINAL__|\\\\\"$helper\\\\\"|g" "$SRC/$script" > "$tmpdir/$script"
    osacompile -o "$app" "$tmpdir/$script"
    rm -rf "$tmpdir"

    # osacompile 은 CFBundleIdentifier 를 만들지 않는다. duti 가 이 값으로 앱을 지정하므로 필수.
    /usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string $bundle_id" "$plist"

    # osacompile 이 만든 CFBundleDocumentTypes:0 은 CFBundleTypeExtensions=* 만 선언한다.
    # duti 는 UTI 기준이라 LSItemContentTypes 도 함께 선언해야 핸들러로 인정된다.
    /usr/libexec/PlistBuddy \
        -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes array" \
        -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:0 string public.item" \
        -c "Add :CFBundleDocumentTypes:0:LSHandlerRank string Alternate" \
        "$plist"

    local i=0 ext uti
    for ext in "${UNKNOWN_EXTS[@]}"; do
        uti="$bundle_id.$ext"
        /usr/libexec/PlistBuddy \
            -c "Add :UTExportedTypeDeclarations:$i dict" \
            -c "Add :UTExportedTypeDeclarations:$i:UTTypeIdentifier string $uti" \
            -c "Add :UTExportedTypeDeclarations:$i:UTTypeDescription string '$ext file'" \
            -c "Add :UTExportedTypeDeclarations:$i:UTTypeConformsTo array" \
            -c "Add :UTExportedTypeDeclarations:$i:UTTypeConformsTo:0 string public.plain-text" \
            -c "Add :UTExportedTypeDeclarations:$i:UTTypeTagSpecification dict" \
            -c "Add :UTExportedTypeDeclarations:$i:UTTypeTagSpecification:public.filename-extension array" \
            -c "Add :UTExportedTypeDeclarations:$i:UTTypeTagSpecification:public.filename-extension:0 string $ext" \
            -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes: string $uti" \
            "$plist" > /dev/null
        i=$((i + 1))
    done

    "$LSREGISTER" -f "$app"
    echo "  $app_name.app  ($bundle_id)"
}

mkdir -p "$APP_DIR"
echo "빌드:"
build_app OpenInTerminal.applescript OpenInTerminal local.openinterminal
