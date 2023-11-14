local wezterm = require 'wezterm';

local module = {}

function module.apply_to_config(config)
  -- config.font = wezterm.font("Fira Code")
  
  config.font = wezterm.font("MesloLGS NF")
  config.font_size = 14.0
end

return module
