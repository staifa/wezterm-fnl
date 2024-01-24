-- [nfnl] Compiled from wezterm.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("nfnl.core")
local merge = _local_2_["merge"]
local _local_3_ = require("wezterm")
local action = _local_3_["action"]
local wezterm = _local_3_
local _local_4_ = autoload("config.tabline")
local format_tab_title = _local_4_["format-tab-title"]
local update_right_status = _local_4_["update-right-status"]
wezterm.on("format-tab-title", format_tab_title)
wezterm.on("update-right-status", update_right_status)
local config = wezterm.config_builder()
local keys = {{key = "LeftArrow", mods = "CTRL|SHIFT", action = action.ActivateTabRelative(-1)}, {key = "RightArrow", mods = "CTRL|SHIFT", action = action.ActivateTabRelative(1)}, {key = "s", mods = "SUPER", action = action.QuickSelect}}
local config_opts = {keys = keys, audible_bell = "Disabled", default_cwd = wezterm.home_dir, front_end = "WebGpu", window_padding = {left = 0, right = 0, top = 0, bottom = 0}, warn_about_missing_glyphs = false}
return merge(config, config_opts)
