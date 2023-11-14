local wezterm = require 'wezterm';

local module = {}

local function private_helper()
  wezterm.log_error("private_helper")
end

function module.apply_to_config(config)
  -- private_helper()
  
end

return module
