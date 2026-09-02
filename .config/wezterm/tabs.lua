local wezterm = require("wezterm")

local palette = require("colors").palette
local colors = {
	inactive_bg = palette.sumiInk0,
	inactive_fg = palette.fujiGray,
	active_bg = palette.sumiInk4,
	active_fg = palette.crystalBlue,
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = colors.inactive_bg
	local foreground = colors.inactive_fg
	local underline = "None"

	if tab.is_active then
		background = colors.active_bg
		foreground = colors.active_fg
		underline = "Single"
	end

	local index = tab.tab_index + 1
	local title = "   " .. index .. ": " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Attribute = { Underline = underline } },
		{ Text = title },
	}
end)

return {
	apply = function(config)
		config.window_decorations = "RESIZE"
		config.show_tabs_in_tab_bar = true
		config.hide_tab_bar_if_only_one_tab = true
		config.use_fancy_tab_bar = false
		config.show_new_tab_button_in_tab_bar = false

		config.colors = config.colors or {}
		config.colors.tab_bar = {
			background = colors.inactive_bg,
		}
	end,
}
