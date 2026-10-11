# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with **GNU Stow**, shared between macOS and Linux. There is no build or test step. "Deploying" means symlinking the package directories into `$HOME`.

## Commands

`deploy.sh` wraps stow with `--dir=<repo> --target=$HOME`. It uses `declare -A` and `mapfile`, so it needs bash 4+ (Homebrew bash on macOS, not `/bin/bash`).

```sh
./deploy.sh list                     # packages + which platforms each targets
./deploy.sh install zsh nvim         # stow specific packages
./deploy.sh --all install            # stow every package for the detected platform
./deploy.sh --dry-run restow nvim    # preview (stow --no); restow resolves stale links
./deploy.sh -b install tmux          # back up real (non-symlink) files to ~/.dotfiles-backup-<ts> first
./deploy.sh uninstall <pkg>

./find-untracked-stow-files.sh [pkg] [-v]   # list files inside packages that git isn't tracking
```

## Architecture

- **Each top-level directory is a stow package** whose contents mirror `$HOME`. For example, `nvim/.config/nvim/init.lua` becomes `~/.config/nvim/init.lua`. Edits made through the symlinked path change files in this repo directly.
- **Platform gating** lives in the `PACKAGE_PLATFORMS` associative array in `deploy.sh` (`macos`, `linux`, or `all`). When you add a package, add it there too. Otherwise `--all` and `list` skip it.
  - macOS only: `aerospace`, `skhd`.
- **Cross-platform values:** the repo is shared between macOS and Linux. Use `~` rather than `/Users/...`, and guard OS-specific values (for example tmux's `if-shell "test -x /usr/bin/zsh"`).
- **The `tmux` package also carries tms:** `tmux/.config/tms/config.toml` is tms's config. There is no separate `tms` package.
- **Stow folding:** if a target directory doesn't exist yet, stow symlinks the whole directory instead of the individual files. Any runtime files the app then writes there land in this repo. `~/.config/herdr` holds sockets, logs and `session.json`, so it must exist as a real directory before `herdr` is stowed. Only `config.toml` should be a symlink.
- **Prefix keys:** tmux and herdr both use `ctrl+a`, so keep their bindings in sync.
- **Non-`.config` paths to keep in place:**
  - `aerospace/aerospace/aerospace.toml` → `~/aerospace/`
  - `tmux/tmux/tmux.reset.conf` → `~/tmux/`. `tmux/.config/tmux/tmux.conf` sources it as `~/tmux/tmux.reset.conf`.
  - `tmux/.local/scripts/tmux-sessionizer` → `~/.local/scripts/`. That directory goes on `PATH` in `zsh/.config/zsh/shell`, and `^f` is bound to the script.
- **zsh**: `zsh/.zshrc` is only a loader. It sources `~/.config/zsh/{shell,aliases,functions,prompt,init,envs}` in that order, plus `macos` on Darwin. Put new shell config in the matching module, not in `.zshrc`.
- **Neovim** is a LazyVim distribution:
  - `lua/config/lazy.lua` imports LazyVim, then some extras, then `lua/plugins/*`. Each plugin file returns a lazy.nvim spec.
  - The other enabled extras are listed in `lazyvim.json`, which `:LazyExtras` manages.
  - `lazy-lock.json` pins plugin versions and changes whenever plugins update.
  - Lua formatting follows `stylua.toml`: 2-space indent, 120 columns.
