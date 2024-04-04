local wezterm = require "wezterm"
local config = {}
local wallpapers = wezterm.glob(wezterm.home_dir .. "/gchait/Wallpapers/*")

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = "Panda (Gogh)"
config.font = wezterm.font "Hack Nerd Font Mono"

config.background = {
  {
    hsb = { brightness = 0.01 },
    source = { File = wallpapers[math.random(#wallpapers)] }
  }
}

return config
