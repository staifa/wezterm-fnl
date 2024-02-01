# wezterm-fnl

> When you find someone who complements you in every way, you know that you were made for each other.

Write [Wezterm](https://wezfurlong.org/wezterm/index.html) configuration with [Fennel](https://fennel-lang.org/) in [Neovim](https://neovim.io/).\
Enjoy the convenience of automatic compilation and reloading.\
[Nfnl](https://github.com/Olical/nfnl) library provides batteries.

This is currently just an extracted bit of my own configuration. Spare time is a sparse commodity for me, but I'll try to transform this into a full-fledged Neovim plugin. Tested only on Linux.

## Demo

![Live terminal configuration.](/../../../../staifa/readme-assets/blob/main/wezterm-fnl.gif)

***

## Prerequisites

- [Wezterm](https://wezfurlong.org/wezterm/index.html)
- [Neovim](https://neovim.io/) 0.9.0+
- [Fd](https://github.com/sharkdp/fd)
- [Sd](https://github.com/chmln/sd)

No need to install `Fennel`, it's already embedded in the `nfnl` library.

## Installation

> :warning: **This may overwrite your current Wezterm configuration!** Be sure to make a backup.

Clone this repo to the Wezterm config directory.

```bash
git clone https://github.com/staifa/wezterm-fnl.git ~/.config/wezterm
```

## Recommended

- [Conjure](https://github.com/Olical/conjure) use REPL directly in your editor - evaluate Fennel code in whole buffer. Or just a single form. Run tests and explore the Fennel mysteries. No need for running REPL instance (or Fennel itself).
- [Fennel-ls](https://git.sr.ht/~xerool/fennel-ls) static anlyzer that can be plugged into an editor by itself as well as used as an LSP source. Written in Fennel!

## Usage

Open `wezterm.fnl` file in the Wezterm config directory - that would be `~/.config/wezterm/wezterm.fnl` in the above example. Edit. Changes are recompiled after each save. Create and require other `fnl` files in the root of the configuration and its subdirectories as you see fit. Root directory must contain at least `.nfnl.fnl`, `nfnl` library and `wezterm.lua` for everything to work correctly.

There is an example `fnl` file - `config.tabline`. See the import and usage in `wezterm.fnl`.

When an exception is thrown, the compiler stops. The root cause is usually found in the wezterm's debug overlay (default mapping `Ctrl + Shift + L`). After fixing the issue, run `:NfnlCompileAllFiles`.

`Nfnl` provides an additional utility function - `:NfnlFile`. It runs the matching `lua` file. It doesn't compile the `fnl` file from which it is called.

[Plenary](https://github.com/nvim-lua/plenary.nvim) is included. Provides extremely handy functions.
[Nfnl standard library](https://github.com/Olical/nfnl/tree/main/docs/api/) is included. Many core functions from [Clojure](https://clojure.org/) are implemented and live in `nfnl.core` namespace. `map` and `reduce` baby!

`nfnl.module` namespace provides a replacement for vimscript's `autoload`. The function is called - `autoload`! It's used for lazy loading imports instead of `require`, it will load the module when you first call it making quite a difference in startup time when the configuration starts to grow. As a rule of thumb, use `autoload` whenever it's possible. `autoload` is limited to modules that are representated by a table. Other module types (function...) can't be lazily loaded and need to be imported with `require`.

> :warning: **The most notable import for us that needs a `require` is the `wezterm` namespace itself!**

```fennel
(local {: autoload} (require :nfnl.module))
(local {: assoc : map} (autoload :nfnl.core))
;; using require to import wezterm namespace
(local wezterm (require :wezterm))

(let [config (wezterm.config_builder)
      ;; long running function is long, nfnl.core is not yet loaded
      longcat (extremely-long-running-fn enormous-table)]
  ;; nfnl.core is loaded now
  (assoc config :long-key (map math.deg longcat)))
```

## Quirks

Functions provided by `:wezterm` module (see `config_builder` and `home_dir` in `wezterm.fnl`) can't be re-evaluated by `Conjure` - it will fail on circular dependency. Makes sense, but also provides room for improvement.

## Unlicensed

![Among tall fennel stems, a tender cowboy shows off his ballet figures for all wezterm to see and admire.](/../../../../staifa/readme-assets/blob/main/wefennel2.png)
![A rugged cowboy riding through a thick undergrowth of giant fennel stems towards wezterm's riches and glory.](/../../../../staifa/readme-assets/blob/main/wefennel.png)
![The holiest of days for a wezterm girl - a sacred bow of marriage with fennel.](/../../../../staifa/readme-assets/blob/main/wefennel3.png)
![After a long day of proper wezterming, a tired cowboy chills with fennel as the night draws near.](/../../../../staifa/readme-assets/blob/main/wefennel5.png)

Find the full [Unlicense](http://unlicense.org/) in the `UNLICENSE` file, but here's a
snippet.

> This is free and unencumbered software released into the public domain.
>
> Anyone is free to copy, modify, publish, use, compile, sell, or distribute
> this software, either in source code form or as a compiled binary, for any
> purpose, commercial or non-commercial, and by any means.

`nfnl/fennel.lua` is excluded from this licensing,
it's downloaded from the [Fennel](https://fennel-lang.org/) website and retains any license
used by the original author. We vendor it within this tool to simplify the user
experience.
