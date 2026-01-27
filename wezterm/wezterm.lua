local wezterm = require("wezterm")
local config = wezterm.config_builder()

local colors = require("colors")
local keybinds = require("keybinds")
local appearance = require("appearance")

config.colors = colors.setup()
appearance.setup(config)
config.disable_default_key_bindings = true  -- 기본 키바인딩 비활성화
config.keys = keybinds.setup()
-- tmux 자동 시작 (새 창마다 새 세션)
config.default_prog = { "/opt/homebrew/bin/tmux", "new-session" }

return config
