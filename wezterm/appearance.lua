local wezterm = require("wezterm")
local M = {}

-- 배경 이미지 설정 (이미지 + 반투명 오버레이)
M.background_image = {
	-- 1. 배경 이미지
	{
		source = { File = wezterm.home_dir .. "/LJJ/dotfiles/dotfiles//b.jpg" },
		hsb = { brightness = 0.05 },
	},
	-- 2. 반투명 오버레이 (opacity 효과)
	{
		source = { Color = "#1e1e2e" }, -- Catppuccin base 색상
		width = "100%",
		height = "100%",
		opacity = 0.1, -- 0.0(투명) ~ 1.0(불투명) - 낮을수록 이미지가 더 보임
	},
}

function M.setup(config)
	config.enable_tab_bar = false -- tmux 사용하므로 탭바 숨김
	config.font = wezterm.font("FiraCode Nerd Font")
	config.font_size = 15
	config.color_scheme = "Catppuccin Mocha"
	config.window_decorations = "RESIZE"
	config.window_padding = {
		left = 4,
		right = 4,
		top = 4,
		bottom = 4,
	}
	config.window_background_opacity = 1.00
end

return M
