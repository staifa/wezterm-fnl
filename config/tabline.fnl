(local wezterm (require :wezterm))
(local {: autoload} (require :nfnl.module))
(local {: map : reduce : inc : concat} (autoload :nfnl.core))

(fn cwd-uri [cwd]
  (: (tostring cwd) :sub 8))

(fn cwd-slash [cwd]
  (: (cwd-uri cwd) :find "/"))

(fn userdata? [cwd]
  (= :userdata (type cwd)))

(fn cwd-gsub [cwd]
  (let [cwd-sub (: (cwd-uri cwd) :sub (cwd-slash cwd))]
    (cwd-sub:gsub "%%(%x%x)" #(string.char (tonumber $1 16)))))

(fn get-cwd [cwd]
  (case [cwd]
    (where [cwd] (userdata? cwd)) cwd.file_path
    (where [cwd] (cwd-slash cwd)) (cwd-gsub cwd)))

(fn get-hostname [cwd]
  (case [cwd]
    (where [cwd] (userdata? cwd)) (or cwd.host (wezterm.hostname))
    (where [cwd] (cwd-slash cwd)) (: (cwd-uri cwd) :sub 1 (- (cwd-slash cwd) 1))))

(fn format-tab-title
  [{:active_pane {:current_working_dir cwd :title title}} _tabs _panes _config _hover _max_width]
  (let [wd (get-cwd cwd)
        new-title (or (and wd (string.gsub wd "(.*[/\\])(.*)" "%2")) title)]
    [{:Text (.. " " new-title " ")}]))

(fn right-status-element [idx len {: resolved_palette : window_frame : pane_select_bg_color} text]
  (let [{: active_titlebar_border_bottom} window_frame
        {: ansi : foreground : selection_bg} resolved_palette
        palette [active_titlebar_border_bottom selection_bg (. ansi 1) pane_select_bg_color]
        bg #(or (. palette $1) pane_select_bg_color)]
    [{:Foreground {:Color (bg idx)}}
     (when (= 1 idx) {:Text ""})
     {:Foreground {:Color foreground}}
     {:Background {:Color (bg idx)}}
     {:Text (.. " " text " ")}
     (when (not= idx len)
       (values {:Foreground {:Color (bg (inc idx))}}
               {:Text ""}))]))

(fn update-right-status [window pane]
  (let [wd (pane:get_current_working_dir)
        date (wezterm.strftime "%d.%m.%Y %H:%M:%S")
        batteries (map #(string.format "%.0f%%" (* (. $1 :state_of_charge) 100)) (wezterm.battery_info))
        cells [(get-cwd wd) (get-hostname wd) date (table.unpack batteries)]
        cells-length (length cells)
        config (window:effective_config)
        elements (->> (icollect [idx value (ipairs cells)]
                        (right-status-element idx cells-length config value))
                      (reduce concat [])
                      wezterm.format)]
    (window:set_right_status elements)))

{: format-tab-title : update-right-status}
