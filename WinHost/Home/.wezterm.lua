local wezterm = require "wezterm"
local mux = wezterm.mux
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_prog = { "ssh", "default" }
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.color_scheme = "Molokai (Gogh)"
config.font = wezterm.font "Hack Nerd Font Mono"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window {
    args = { "powershell", "-nologo" },
  }
  
  window:gui_window():maximize()
  local _, second_pane, _ = window:spawn_tab(cmd or {})
end)

return config
