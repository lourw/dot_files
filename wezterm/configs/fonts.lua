local wezterm = require 'wezterm';

local module = {}

function module.apply_to_config(config)
  local_font = "MesloLGS NF"
  config.font_size = 14.0
  
  config.font = wezterm.font(local_font)
  config.font_rules = {
    {
      intensity = "Bold",
      font = wezterm.font(local_font, {weight="Bold"})
    },
  }
end

return module
