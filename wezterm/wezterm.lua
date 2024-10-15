-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
-- config.front_end = "WebGpu"
-- config.enable_wayland = false

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Macchiato"
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Noto Sans Symbols 2",
})
-- and finally, return the configuration to wezterm
return config
