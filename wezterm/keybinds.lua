local wezterm = require("wezterm")
local appearance = require("appearance")
local M = {}

function M.setup()
	return {
		-- 배경 토글 (Cmd+Shift+B)
		{
			key = "phys:B",
			mods = "CMD|SHIFT",
			action = wezterm.action_callback(function(window, pane)
				local overrides = window:get_config_overrides() or {}
				if overrides.background then
					overrides.background = nil
					overrides.window_background_opacity = 1.00
				else
					overrides.background = appearance.background_image
					overrides.window_background_opacity = 1.0
				end
				window:set_config_overrides(overrides)
			end),
		},

		-- 기본 키바인딩
		{ key = "phys:c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "phys:v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "phys:q", mods = "CMD", action = wezterm.action.QuitApplication },
		{ key = "phys:m", mods = "CMD", action = wezterm.action.Hide },
		{ key = "phys:n", mods = "CMD", action = wezterm.action.SpawnWindow },
		-- 폰트 크기 (Cmd+Shift)
		{ key = "+", mods = "CMD|SHIFT", action = wezterm.action.IncreaseFontSize },
		{ key = "_", mods = "CMD|SHIFT", action = wezterm.action.DecreaseFontSize },
		{ key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },

		-- tmux 윈도우 이동 (Cmd+숫자)
		{ key = "1", mods = "CMD", action = wezterm.action.SendString("\x02" .. "1") },
		{ key = "2", mods = "CMD", action = wezterm.action.SendString("\x02" .. "2") },
		{ key = "3", mods = "CMD", action = wezterm.action.SendString("\x02" .. "3") },
		{ key = "4", mods = "CMD", action = wezterm.action.SendString("\x02" .. "4") },
		{ key = "5", mods = "CMD", action = wezterm.action.SendString("\x02" .. "5") },

		-- tmux 윈도우 생성/닫기
		{ key = "phys:t", mods = "CMD", action = wezterm.action.SendString("\x02" .. "c") },
		{ key = "phys:w", mods = "CMD", action = wezterm.action.SendString("\x02" .. "x") },

		-- tmux 윈도우 이동 (이전/다음)
		{ key = "[", mods = "CMD", action = wezterm.action.SendString("\x02" .. "H") },
		{ key = "]", mods = "CMD", action = wezterm.action.SendString("\x02" .. "L") },

		-- tmux Pane 분할
		{ key = "phys:D", mods = "CMD|SHIFT", action = wezterm.action.SendString("\x02" .. "s") }, -- 수직 분할
		{ key = "phys:E", mods = "CMD|SHIFT", action = wezterm.action.SendString("\x02" .. "v") }, -- 수평 분할

		-- tmux Pane 이동 (Cmd+방향키)
		{ key = "LeftArrow", mods = "CMD", action = wezterm.action.SendString("\x02" .. "h") },
		{ key = "RightArrow", mods = "CMD", action = wezterm.action.SendString("\x02" .. "l") },
		{ key = "UpArrow", mods = "CMD", action = wezterm.action.SendString("\x02" .. "k") },
		{ key = "DownArrow", mods = "CMD", action = wezterm.action.SendString("\x02" .. "j") },

		-- tmux Pane 크기 조절 (Ctrl+Shift+방향키)
		{ key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.SendString("\x02" .. ",") },
		{ key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.SendString("\x02" .. ".") },
		{ key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action.SendString("\x02" .. "=") },
		{ key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.SendString("\x02" .. "-") },

		-- tmux Pane 균등 분배
		{ key = "=", mods = "CMD", action = wezterm.action.SendString("\x02" .. "e") }, -- 수평 균등
		{ key = "-", mods = "CMD", action = wezterm.action.SendString("\x02" .. "E") }, -- 수직 균등

		-- tmux zoom
		{ key = "phys:z", mods = "CMD", action = wezterm.action.SendString("\x02" .. "z") },

		-- tmux floax 팝업
		{ key = "phys:p", mods = "CMD", action = wezterm.action.SendString("\x02" .. "p") },

		-- SSH 호스트 선택
		{ key = "\\", mods = "CMD", action = wezterm.action.SendString("\x02" .. "g") },

		-- tmux 세션 선택
		{ key = ",", mods = "CMD", action = wezterm.action.SendString("\x02" .. "s") },

		-- tmux 세션 생성
		{ key = "phys:N", mods = "CMD|SHIFT", action = wezterm.action.SendString("\x02" .. "S") },

		-- tmuxinator 워크스페이스 선택
		{ key = "/", mods = "CMD", action = wezterm.action.SendString("\x02" .. "w") },

		-- yazi 파일 매니저
		{ key = "phys:f", mods = "CMD", action = wezterm.action.SendString("\x02" .. "f") },
	}
end

return M
