-- Finder에서 넘어온 파일을 bin/open-in-terminal 로 넘기는 얇은 래퍼.
-- CLI(nvim)는 Finder가 직접 호출할 수 없어 .app 이 필요하다.
--
-- __OPEN_IN_TERMINAL__ 는 빌드할 때 실제 절대경로로 치환된다.
-- (repo 를 ~/dotfiles 가 아닌 곳에 두어도 동작하게 하려는 것 —
--  build-open-in-terminal.sh 참조)
-- 빌드: macos/build-open-in-terminal.sh

on open theFiles
	repeat with f in theFiles
		do shell script "__OPEN_IN_TERMINAL__ " & quoted form of (POSIX path of f) & " >/dev/null 2>&1 &"
	end repeat
end open

-- 파일 없이 앱만 실행했을 때는 그냥 터미널을 연다
on run
	do shell script "__OPEN_IN_TERMINAL__ --no-file >/dev/null 2>&1 &"
end run
