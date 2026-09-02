local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 15.0
config.use_ime = true
config.window_background_image = wezterm.config_dir .. "/kirby.jpg"
config.window_background_image_hsb = {
	brightness = 0.2,
}

-- 合字を無効化
config.harfbuzz_features = { "calt=0", "clig=0", "dlig=0", "liga=0" }

require("colors").apply(config)
require("tabs").apply(config)

-- keybinds
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config
