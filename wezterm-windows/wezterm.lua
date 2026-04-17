-- Windows + WSL(Ubuntu) + tmux 환경용 WezTerm 설정
local wezterm = require("wezterm")

-- 같은 폴더의 모듈을 require할 수 있게 package.path 보강
local config_dir = wezterm.home_dir:gsub("\\", "/") .. "/dotfiles/wezterm-windows"
package.path = config_dir .. "/?.lua;" .. package.path

local config = wezterm.config_builder()

local keybinds = require("keybinds")
local appearance = require("appearance")

appearance.setup(config)
config.disable_default_key_bindings = true
config.keys = keybinds.setup()

-- WSL Ubuntu를 띄우고 그 안에서 tmux 자동 시작.
-- tmux 미설치 시 로그인 셸로 폴백.
config.default_prog = {
	"wsl.exe",
	"-d", "Ubuntu",
	"--cd", "~",
	"--",
	"bash", "-lc",
	'command -v tmux >/dev/null && exec tmux new-session -A -s main || exec "${SHELL:-bash}" -l',
}

-- 한글 IME
config.use_ime = true
config.cursor_thickness = 1

-- Windows: 기본 GPU 백엔드가 가끔 흐릿함. WebGpu가 보통 가장 선명.
config.front_end = "WebGpu"

return config
