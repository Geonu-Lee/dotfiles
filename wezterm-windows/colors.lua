local M = {}

function M.setup()
	return {
		tab_bar = {
			background = "#1e1e2e",
			active_tab = {
				bg_color = "#cba6f7",
				fg_color = "#1e1e2e",
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#313244",
				fg_color = "#a6adc8",
			},
			inactive_tab_hover = {
				bg_color = "#45475a",
				fg_color = "#cdd6f4",
			},
			new_tab = {
				bg_color = "#1e1e2e",
				fg_color = "#6c7086",
			},
			new_tab_hover = {
				bg_color = "#45475a",
				fg_color = "#cdd6f4",
			},
		},
	}
end

return M
