(local {: autoload} (require :nfnl.module))
(local reload (autoload :plenary.reload))
(local notify (autoload :nfnl.notify))

(vim.api.nvim_set_keymap
  :n "<localleader>pr" ""
  {:desc "Reload the nfnl modules."
   :callback (fn []
               (notify.info "Reloading...")
               (reload.reload_module "nfnl")
               (require :nfnl)
               (notify.info "Done!"))})

{:source-file-patterns ["wezterm.fnl" "fnl/*.fnl"]}
