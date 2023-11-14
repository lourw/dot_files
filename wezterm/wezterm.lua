local fonts = require 'configs/fonts'
local themes = require 'configs/themes'
local settings = require 'configs/settings'
local keybindings = require 'configs/keybindings'

local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then 
  config = wezterm.config_builder()
end

fonts.apply_to_config(config)
themes.apply_to_config(config)
settings.apply_to_config(config)
keybindings.apply_to_config(config)

return config
