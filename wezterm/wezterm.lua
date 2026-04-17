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

return config
