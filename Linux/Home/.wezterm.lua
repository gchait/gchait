local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.color_scheme = "Panda (Gogh)"
config.font = wezterm.font "Hack Nerd Font Mono"

return config
