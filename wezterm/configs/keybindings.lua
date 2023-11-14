local wezterm = require 'wezterm';

local module = {}

function module.apply_to_config(config)
  config.keys = {
    {
      key = "/",
      mods = "CTRL",
      action = wezterm.action.ActivateCommandPalette,
    },
  }  
end

return module
