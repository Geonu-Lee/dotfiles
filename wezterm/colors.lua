local M = {}

function M.setup()
	return {
		tab_bar = {
			background = "#1e1e2e", -- Base
			active_tab = {
				bg_color = "#cba6f7", -- Mauve
				fg_color = "#1e1e2e", -- Base
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#313244", -- Surface0
				fg_color = "#a6adc8", -- Subtext0
			},
			inactive_tab_hover = {
				bg_color = "#45475a", -- Surface1
				fg_color = "#cdd6f4", -- Text
			},
			new_tab = {
				bg_color = "#1e1e2e", -- Base
				fg_color = "#6c7086", -- Overlay0
			},
			new_tab_hover = {
				bg_color = "#45475a", -- Surface1
				fg_color = "#cdd6f4", -- Text
			},
		},
	}
end

return M
