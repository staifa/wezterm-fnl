(local {: autoload} (require :nfnl.module))
(local {: merge} (autoload :nfnl.core))
(local {: action &as wezterm} (require :wezterm))
(local {: format-tab-title : update-right-status} (autoload :config.tabline))

(wezterm.on :format-tab-title format-tab-title)
(wezterm.on :update-right-status update-right-status)

(local config (wezterm.config_builder))

(local keys
  [{:key :LeftArrow :mods :CTRL|SHIFT :action (action.ActivateTabRelative -1)}
   {:key :RightArrow :mods :CTRL|SHIFT :action (action.ActivateTabRelative 1)}
   {:key :s :mods :SUPER :action action.QuickSelect}])

(local config-opts
  {: keys
   :audible_bell :Disabled
   :default_cwd wezterm.home_dir
   :front_end :WebGpu
   :warn_about_missing_glyphs false
   :window_padding {:left 0 :right 0 :top 0 :bottom 0}})

(merge config config-opts)
