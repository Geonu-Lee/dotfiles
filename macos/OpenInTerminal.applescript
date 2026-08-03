-- Finder에서 넘어온 파일을 bin/open-in-terminal 로 넘기는 얇은 래퍼.
-- CLI(nvim/jless/glow)는 Finder가 직접 호출할 수 없어 .app 이 필요하다.
-- 빌드: macos/build-open-in-terminal.sh

on open theFiles
	repeat with f in theFiles
		do shell script "\"$HOME/dotfiles/bin/open-in-terminal\" " & quoted form of (POSIX path of f) & " >/dev/null 2>&1 &"
	end repeat
end open

-- 파일 없이 앱만 실행했을 때는 그냥 터미널을 연다
on run
	do shell script "\"$HOME/dotfiles/bin/open-in-terminal\" --no-file >/dev/null 2>&1 &"
end run
