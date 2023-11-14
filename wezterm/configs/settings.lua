local wezterm = require 'wezterm';

local module = {}

function module.apply_to_config(config)
  config.hide_tab_bar_if_only_one_tab = true  
  config.native_macos_fullscreen_mode = true
end

return module
