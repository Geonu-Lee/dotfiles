-- Windows 키바인딩
-- 원칙:
--   * Mac CMD → Windows CTRL
--   * 셸/readline 충돌(C/V/H/J/K/L/T/W/Z/F/P/N/[) → CTRL+SHIFT로 회피
--   * tmux prefix는 Ctrl+B (\x02) 그대로
local wezterm = require("wezterm")
local appearance = require("appearance")
local M = {}

-- tmux prefix + 단일 키 전송
local function tmux(key)
	return wezterm.action.SendString("\x02" .. key)
end

function M.setup()
	return {
		-- 배경 토글
		{
			key = "phys:B",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(function(window, _pane)
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

		-- 클립보드 (CTRL+C는 SIGINT라 SHIFT 필수)
		{ key = "phys:C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "phys:V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

		-- 앱 제어
		{ key = "phys:Q", mods = "CTRL|SHIFT", action = wezterm.action.QuitApplication },
		{ key = "phys:N", mods = "CTRL|SHIFT", action = wezterm.action.SpawnWindow },

		-- 폰트 크기
		{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
		{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
		{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },

		-- tmux 윈도우 이동 (CTRL+숫자 — 셸 충돌 없음)
		{ key = "1", mods = "CTRL", action = tmux("1") },
		{ key = "2", mods = "CTRL", action = tmux("2") },
		{ key = "3", mods = "CTRL", action = tmux("3") },
		{ key = "4", mods = "CTRL", action = tmux("4") },
		{ key = "5", mods = "CTRL", action = tmux("5") },

		-- tmux 윈도우 생성/닫기 (CTRL+T/W는 fzf/단어삭제 충돌)
		{ key = "phys:T", mods = "CTRL|SHIFT", action = tmux("c") },
		{ key = "phys:W", mods = "CTRL|SHIFT", action = tmux("x") },

		-- tmux 윈도우 이전/다음 (CTRL+[ = ESC 충돌)
		{ key = "[", mods = "CTRL|SHIFT", action = tmux("H") },
		{ key = "]", mods = "CTRL|SHIFT", action = tmux("L") },

		-- tmux Pane 분할
		{ key = "phys:D", mods = "CTRL|SHIFT", action = tmux("s") }, -- 수직 분할
		{ key = "phys:E", mods = "CTRL|SHIFT", action = tmux("v") }, -- 수평 분할

		-- tmux Pane 이동 — 화살표는 CTRL, hjkl은 CTRL+SHIFT (CTRL+H/J/K/L 모두 셸 충돌)
		{ key = "LeftArrow",  mods = "CTRL", action = tmux("h") },
		{ key = "RightArrow", mods = "CTRL", action = tmux("l") },
		{ key = "UpArrow",    mods = "CTRL", action = tmux("k") },
		{ key = "DownArrow",  mods = "CTRL", action = tmux("j") },
		{ key = "phys:H", mods = "CTRL|SHIFT", action = tmux("h") },
		{ key = "phys:L", mods = "CTRL|SHIFT", action = tmux("l") },
		{ key = "phys:K", mods = "CTRL|SHIFT", action = tmux("k") },
		{ key = "phys:J", mods = "CTRL|SHIFT", action = tmux("j") },

		-- tmux Pane 크기 조절 (CTRL+ALT+방향키 — CTRL+SHIFT+방향과 충돌 회피)
		{ key = "LeftArrow",  mods = "CTRL|ALT", action = tmux(",") },
		{ key = "RightArrow", mods = "CTRL|ALT", action = tmux(".") },
		{ key = "UpArrow",    mods = "CTRL|ALT", action = tmux("=") },
		{ key = "DownArrow",  mods = "CTRL|ALT", action = tmux("-") },

		-- tmux Pane 균등 (CTRL+= / CTRL+- 은 폰트 크기에 사용 → SHIFT 추가)
		{ key = "+", mods = "CTRL|SHIFT", action = tmux("e") }, -- 수평 균등
		{ key = "_", mods = "CTRL|SHIFT", action = tmux("E") }, -- 수직 균등

		-- tmux zoom (CTRL+Z = SIGTSTP)
		{ key = "phys:Z", mods = "CTRL|SHIFT", action = tmux("z") },

		-- tmux floax 팝업 (CTRL+P = prev-history)
		{ key = "phys:P", mods = "CTRL|SHIFT", action = tmux("p") },

		-- SSH 호스트 선택 (CTRL+\ = SIGQUIT)
		{ key = "\\", mods = "CTRL|SHIFT", action = tmux("g") },

		-- tmux 세션 선택
		{ key = ",", mods = "CTRL", action = tmux("s") },

		-- tmux 새 세션
		{ key = "phys:S", mods = "CTRL|SHIFT", action = tmux("S") },

		-- tmuxinator 워크스페이스
		{ key = "/", mods = "CTRL", action = tmux("w") },

		-- yazi (CTRL+F = forward-char)
		{ key = "phys:F", mods = "CTRL|SHIFT", action = tmux("f") },
	}
end

return M
