local wezterm = require("wezterm")
local config = wezterm.config_builder()

local keybinds = require("keybinds")
local appearance = require("appearance")

appearance.setup(config)
config.disable_default_key_bindings = true  -- 기본 키바인딩 비활성화
config.keys = keybinds.setup()
-- tmux 자동 시작 (새 창마다 새 세션)
config.default_prog = { "/opt/homebrew/bin/tmux", "new-session", "-A", "-s", "main" }

-- 한글 입력 커서 겹침 완화
config.use_ime = true
config.cursor_thickness = 1

-- 하이퍼링크: 기본 규칙(URL 등) + Cmd+클릭으로 열기
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.mouse_bindings = {
	-- Cmd+클릭으로 링크 열기
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	-- Cmd 누른 채 클릭 시 텍스트 선택이 시작되지 않도록 (링크 열기만 동작)
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.Nop,
	},
}

return config
