local wezterm = require("wezterm")
local M = {}

-- 배경 이미지 (이미지 + 반투명 오버레이)
M.background_image = {
	{
		source = { File = wezterm.home_dir:gsub("\\", "/") .. "/dotfiles/.wallpaper/landscape.jpg" },
		hsb = { brightness = 0.05 },
	},
	{
		source = { Color = "#1e1e2e" },
		width = "100%",
		height = "100%",
		opacity = 0.1,
	},
}

function M.setup(config)
	config.enable_tab_bar = false -- tmux 사용하므로 탭바 숨김

	-- Windows에 기본 설치된 Cascadia Code를 폴백으로 둠.
	-- Nerd Font 설치 시 자동으로 우선 적용됨.
	config.font = wezterm.font_with_fallback({
		"FiraCode Nerd Font",
		"JetBrainsMono Nerd Font",
		"MesloLGS NF",
		"Cascadia Code",
		"Consolas",
		"Segoe UI Emoji",
	})
	config.font_size = 12

	-- Dracula 팔레트
	config.colors = {
		foreground = "#f8f8f2",
		background = "#282a36",
		cursor_bg = "#f8f8f2",
		cursor_fg = "#282a36",
		cursor_border = "#f8f8f2",
		selection_fg = "#f8f8f2",
		selection_bg = "#44475a",
		ansi = { "#21222c", "#ff5555", "#50fa7b", "#f1fa8c", "#bd93f9", "#ff79c6", "#8be9fd", "#f8f8f2" },
		brights = { "#6272a4", "#ff6e6e", "#69ff94", "#ffffa5", "#d6acff", "#ff92df", "#a4ffff", "#ffffff" },
	}

	config.window_decorations = "RESIZE"
	config.window_padding = {
		left = 4,
		right = 4,
		top = 4,
		bottom = 4,
	}
	config.window_background_opacity = 1.00

	-- Windows 시작 시 최대화
	config.initial_cols = 140
	config.initial_rows = 40
end

return M
