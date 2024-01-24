-- [nfnl] Compiled from config/tabline.fnl by https://github.com/Olical/nfnl, do not edit.
local wezterm = require("wezterm")
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("nfnl.core")
local map = _local_2_["map"]
local reduce = _local_2_["reduce"]
local inc = _local_2_["inc"]
local concat = _local_2_["concat"]
local function cwd_uri(cwd)
  return tostring(cwd):sub(8)
end
local function cwd_slash(cwd)
  return cwd_uri(cwd):find("/")
end
local function userdata_3f(cwd)
  return ("userdata" == type(cwd))
end
local function cwd_gsub(cwd)
  local cwd_sub = cwd_uri(cwd):sub(cwd_slash(cwd))
  local function _3_(_241)
    return string.char(tonumber(_241, 16))
  end
  return cwd_sub:gsub("%%(%x%x)", _3_)
end
local function get_cwd(cwd)
  local _4_ = {cwd}
  local function _5_()
    local cwd0 = (_4_)[1]
    return userdata_3f(cwd0)
  end
  if (((_G.type(_4_) == "table") and (nil ~= (_4_)[1])) and _5_()) then
    local cwd0 = (_4_)[1]
    return cwd0.file_path
  else
    local function _6_()
      local cwd0 = (_4_)[1]
      return cwd_slash(cwd0)
    end
    if (((_G.type(_4_) == "table") and (nil ~= (_4_)[1])) and _6_()) then
      local cwd0 = (_4_)[1]
      return cwd_gsub(cwd0)
    else
      return nil
    end
  end
end
local function get_hostname(cwd)
  local _8_ = {cwd}
  local function _9_()
    local cwd0 = (_8_)[1]
    return userdata_3f(cwd0)
  end
  if (((_G.type(_8_) == "table") and (nil ~= (_8_)[1])) and _9_()) then
    local cwd0 = (_8_)[1]
    return (cwd0.host or wezterm.hostname())
  else
    local function _10_()
      local cwd0 = (_8_)[1]
      return cwd_slash(cwd0)
    end
    if (((_G.type(_8_) == "table") and (nil ~= (_8_)[1])) and _10_()) then
      local cwd0 = (_8_)[1]
      return cwd_uri(cwd0):sub(1, (cwd_slash(cwd0) - 1))
    else
      return nil
    end
  end
end
local function format_tab_title(_12_, _tabs, _panes, _config, _hover, _max_width)
  local _arg_13_ = _12_
  local _arg_14_ = _arg_13_["active_pane"]
  local cwd = _arg_14_["current_working_dir"]
  local title = _arg_14_["title"]
  local wd = get_cwd(cwd)
  local new_title = ((wd and string.gsub(wd, "(.*[/\\])(.*)", "%2")) or title)
  return {{Text = (" " .. new_title .. " ")}}
end
local function right_status_element(idx, len, _15_, text)
  local _arg_16_ = _15_
  local resolved_palette = _arg_16_["resolved_palette"]
  local window_frame = _arg_16_["window_frame"]
  local pane_select_bg_color = _arg_16_["pane_select_bg_color"]
  local _let_17_ = window_frame
  local active_titlebar_border_bottom = _let_17_["active_titlebar_border_bottom"]
  local _let_18_ = resolved_palette
  local ansi = _let_18_["ansi"]
  local foreground = _let_18_["foreground"]
  local selection_bg = _let_18_["selection_bg"]
  local palette = {active_titlebar_border_bottom, selection_bg, ansi[1], pane_select_bg_color}
  local bg
  local function _19_(_241)
    return (palette[_241] or pane_select_bg_color)
  end
  bg = _19_
  local _20_
  if (1 == idx) then
    _20_ = {Text = "\238\130\178"}
  else
    _20_ = nil
  end
  local function _22_()
    if (idx ~= len) then
      return {Foreground = {Color = bg(inc(idx))}}, {Text = "\238\130\178"}
    else
      return nil
    end
  end
  return {{Foreground = {Color = bg(idx)}}, _20_, {Foreground = {Color = foreground}}, {Background = {Color = bg(idx)}}, {Text = (" " .. text .. " ")}, _22_()}
end
do local _ = (1 + 1) end
local function update_right_status(window, pane)
  local wd = pane:get_current_working_dir()
  local date = wezterm.strftime("%d.%m.%Y %H:%M:%S")
  local batteries
  local function _23_(_241)
    return string.format("%.0f%%", ((_241).state_of_charge * 100))
  end
  batteries = map(_23_, wezterm.battery_info())
  local cells = {get_cwd(wd), get_hostname(wd), date, table.unpack(batteries)}
  local cells_length = #cells
  local config = window:effective_config()
  local elements
  local function _24_()
    local tbl_17_auto = {}
    local i_18_auto = #tbl_17_auto
    for idx, value in ipairs(cells) do
      local val_19_auto = right_status_element(idx, cells_length, config, value)
      if (nil ~= val_19_auto) then
        i_18_auto = (i_18_auto + 1)
        do end (tbl_17_auto)[i_18_auto] = val_19_auto
      else
      end
    end
    return tbl_17_auto
  end
  elements = wezterm.format(reduce(concat, {}, _24_()))
  return window:set_right_status(elements)
end
return {["format-tab-title"] = format_tab_title, ["update-right-status"] = update_right_status}
