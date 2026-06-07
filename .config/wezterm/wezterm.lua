local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 15.0
config.use_ime = true
config.window_background_opacity = 1.0
config.macos_window_background_blur = 20
config.window_background_image = wezterm.config_dir .. "/kirby.jpg"
config.window_background_image_hsb = {
	brightness = 0.2,
	saturation = 1.0,
	hue = 1.0,
}
config.color_scheme = "Kanagawa (Gogh)"

-- 合字を無効化
config.harfbuzz_features = { "calt=0", "clig=0", "dlig=0", "liga=0" }

----------------------------------------------------
-- Tab
----------------------------------------------------
config.window_decorations = "RESIZE"
config.show_tabs_in_tab_bar = true

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#658594"
	local foreground = "#FFFFFF"
	local edge_background = "none"

	if tab.is_active then
		background = "#938056"
		foreground = "#FFFFFF"
	end

	local edge_foreground = background
	local index = tab.tab_index + 1
	local title = "   " .. index .. ": " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config
