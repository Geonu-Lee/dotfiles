local wezterm = require("wezterm")
local appearance = require("appearance")
local M = {}

function M.setup()
	return {
		-- 배경 토글 (Cmd+Shift+B)
		{
			key = "B",
			mods = "CMD|SHIFT",
			action = wezterm.action_callback(function(window, pane)
				local overrides = window:get_config_overrides() or {}
				if overrides.background then
					overrides.background = nil
					overrides.window_background_opacity = 0.95
				else
					overrides.background = appearance.background_image
					overrides.window_background_opacity = 1.0
				end
				window:set_config_overrides(overrides)
			end),
		},

		-- 기본 키바인딩
		{ key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
		{ key = "m", mods = "CMD", action = wezterm.action.Hide },
		{ key = "n", mods = "CMD", action = wezterm.action.SpawnWindow },
		-- 폰트 크기 (Cmd+Shift)
		{ key = "+", mods = "CMD|SHIFT", action = wezterm.action.IncreaseFontSize },
		{ key = "_", mods = "CMD|SHIFT", action = wezterm.action.DecreaseFontSize },
		{ key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },

		-- tmux 윈도우 이동 (Cmd+숫자)
		{ key = "1", mods = "CMD", action = wezterm.action.SendString("\x01" .. "1") },
		{ key = "2", mods = "CMD", action = wezterm.action.SendString("\x01" .. "2") },
		{ key = "3", mods = "CMD", action = wezterm.action.SendString("\x01" .. "3") },
		{ key = "4", mods = "CMD", action = wezterm.action.SendString("\x01" .. "4") },
		{ key = "5", mods = "CMD", action = wezterm.action.SendString("\x01" .. "5") },

		-- tmux 윈도우 생성/닫기
		{ key = "t", mods = "CMD", action = wezterm.action.SendString("\x01" .. "c") },
		{ key = "w", mods = "CMD", action = wezterm.action.SendString("\x01" .. "x") },

		-- tmux 윈도우 이동 (이전/다음)
		{ key = "[", mods = "CMD", action = wezterm.action.SendString("\x01" .. "H") },
		{ key = "]", mods = "CMD", action = wezterm.action.SendString("\x01" .. "L") },

		-- tmux Pane 분할
		{ key = "D", mods = "CMD|SHIFT", action = wezterm.action.SendString("\x01" .. "s") },  -- 수직 분할
		{ key = "E", mods = "CMD|SHIFT", action = wezterm.action.SendString("\x01" .. "v") },  -- 수평 분할

		-- tmux Pane 이동 (Ctrl+hjkl)
		{ key = "h", mods = "CTRL", action = wezterm.action.SendString("\x01" .. "h") },
		{ key = "l", mods = "CTRL", action = wezterm.action.SendString("\x01" .. "l") },
		{ key = "k", mods = "CTRL", action = wezterm.action.SendString("\x01" .. "k") },
		{ key = "j", mods = "CTRL", action = wezterm.action.SendString("\x01" .. "j") },

		-- tmux Pane 크기 조절 (Ctrl+Shift)
		{ key = "H", mods = "CTRL|SHIFT", action = wezterm.action.SendString("\x01" .. ",") },
		{ key = "L", mods = "CTRL|SHIFT", action = wezterm.action.SendString("\x01" .. ".") },
		{ key = "K", mods = "CTRL|SHIFT", action = wezterm.action.SendString("\x01" .. "=") },
		{ key = "J", mods = "CTRL|SHIFT", action = wezterm.action.SendString("\x01" .. "-") },

		-- tmux Pane 균등 분배
		{ key = "=", mods = "CMD", action = wezterm.action.SendString("\x01" .. "e") },  -- 수평 균등
		{ key = "-", mods = "CMD", action = wezterm.action.SendString("\x01" .. "E") },  -- 수직 균등

		-- tmux zoom
		{ key = "z", mods = "CMD", action = wezterm.action.SendString("\x01" .. "z") },

		-- tmux floax 팝업
		{ key = "p", mods = "CMD", action = wezterm.action.SendString("\x01" .. "p") },

		-- SSH 호스트 선택
		{ key = "\\", mods = "CMD", action = wezterm.action.SendString("\x01" .. "g") },

		-- tmux 세션 선택
		{ key = ",", mods = "CMD", action = wezterm.action.SendString("\x01" .. "s") },

		-- tmux 세션 생성
		{ key = "N", mods = "CMD|SHIFT", action = wezterm.action.SendString("\x01" .. "S") },

		-- yazi 파일 매니저
		{ key = "f", mods = "CMD", action = wezterm.action.SendString("\x01" .. "f") },
	}
end

return M
