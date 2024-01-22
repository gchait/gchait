local wezterm = require "wezterm"
local mux = wezterm.mux
local config = {}
local wallpapers = wezterm.glob(wezterm.home_dir .. "/gchait/Wallpapers/*")

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_prog = { "ssh", "default" }
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.color_scheme = "Panda (Gogh)"
config.font = wezterm.font "Hack Nerd Font Mono"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

config.background = {
  {
    hsb = { brightness = 0.03 },
    source = { File = wallpapers[math.random(#wallpapers)] }
  }
}

wezterm.on("gui-startup", function(cmd)
  local tab1, pane1, window = mux.spawn_window {
    args = { "powershell", "-nologo" },
  }
  
  tab1:set_title "windows"
  window:gui_window():maximize()
  local tab2, pane2, window = window:spawn_tab(cmd or {})
end)

wezterm.on("format-tab-title",
  function(tab, tabs, panes, config, hover, max_width)
    if tab.tab_title == "windows" then
      return "windows"
    else
      return "fedora"
    end
  end
)

return config
