local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 15.0
config.use_ime = true
config.window_background_image = wezterm.config_dir .. "/kirby.jpg"
config.window_background_image_hsb = {
	brightness = 0.2,
}

config.color_scheme = "Kanagawa (Gogh)"
local palette = {
	sumiInk0 = "#16161D",
	sumiInk1 = "#1F1F28",
	fujiGray = "#727169",
	waveAqua2 = "#7AA89F",
}

-- 合字を無効化
config.harfbuzz_features = { "calt=0", "clig=0", "dlig=0", "liga=0" }

----------------------------------------------------
-- Tab
----------------------------------------------------
config.window_decorations = "RESIZE"
config.show_tabs_in_tab_bar = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

local colors = {
	inactive_bg = palette.sumiInk0,
	inactive_fg = palette.fujiGray,
	active_bg = palette.sumiInk1,
	active_fg = palette.waveAqua2,
}

config.colors = {
	tab_bar = {
		background = colors.inactive_bg,
	},
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = colors.inactive_bg
	local foreground = colors.inactive_fg

	if tab.is_active then
		background = colors.active_bg
		foreground = colors.active_fg
	end

	local index = tab.tab_index + 1
	local title = "   " .. index .. ": " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
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
