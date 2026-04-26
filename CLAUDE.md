# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository managing configurations for bash, zsh, tmux, and Neovim. Installation is done via install scripts — there is no Makefile or test suite.

## Setup

Run the appropriate install script (requires the repo to already be cloned):

```bash
bash install/macos.sh   # macOS — uses Homebrew
bash install/debian.sh  # Debian/Ubuntu — uses apt + GitHub releases
```

Both scripts install packages and call `install/symlinks.sh` to create all symlinks. Symlinks can be re-run standalone and are idempotent.

## Architecture

### Shell (bash + zsh)
- `env.sh` — shared environment sourced by both shells via `~/.env.sh`; contains Cargo, PATH additions (Homebrew binutils, Zephyr SDK, `~/.local/bin`), STM32CubeMX, CLICOLOR, and fzf init
- `bash_profile` — login shell; Homebrew shellenv, then sources `bashrc`
- `bashrc` — interactive bash; prompt, sources `~/.env.sh`
- `zprofile` — zsh login shell; Homebrew shellenv
- `zshrc` — interactive zsh; prompt, sources `~/.env.sh`
- Prompt style is unified across both shells: `(\date \time) user @ host :: ~/full/path` with a green `$`/`>` character

### tmux (`tmux.conf`)
- Prefix remapped to `Ctrl+a`
- Vim-style pane navigation (`h/j/k/l`)
- Mouse support enabled
- `tmux-256color` + `terminal-overrides` for true-color passthrough (required for Neovim themes)
- Nord theme via `arcticicestudio/nord-tmux` plugin (cloned to `~/.config/tmux/plugins/arcticicestudio/nord-tmux/` by install scripts)

### Neovim (`nvim/`)
Config uses **lazy.nvim** for plugin management. `nvim/init.lua` bootstraps lazy and sets all options. Plugins are in `nvim/lua/plugins/`, one file per concern — lazy auto-discovers them all.

| File | Purpose |
|---|---|
| `colorscheme.lua` | Catppuccin Mocha (default); Kanagawa, Tokyo Night, and Nord are installed alternatives |
| `lsp.lua` | mason + mason-lspconfig + nvim-lspconfig; auto-installs `lua_ls`, `pyright`, `bashls` |
| `cmp.lua` | nvim-cmp completion with LSP, buffer, path, and LuaSnip sources |
| `telescope.lua` | Fuzzy finding (`<leader>ff/fg/fb/fh`); replaces FZF |
| `treesitter.lua` | Syntax/indent for bash, lua, python, and more |
| `ui.lua` | lualine (statusline) + gitsigns |

**Switching colorschemes**: run `./set-theme.sh <family/variant>` from the dotfiles root (e.g. `catppuccin/mocha`, `kanagawa/wave`, `tokyonight/moon`, `nord/nord`). This updates the `theme` file, reloads tmux, and best-effort reloads running nvim instances. A full nvim restart is needed for lualine/treesitter highlights to update.

**LSP servers**: managed via `:Mason` inside Neovim. The default handler in `lsp.lua` automatically applies to any server installed through Mason.

### Theme system
- `theme` — plain text file containing the active theme as `family/variant` (e.g. `catppuccin/mocha`, `kanagawa/wave`, `tokyonight/moon`)
- `set-theme.sh` — updates `theme`, reloads tmux, reloads nvim instances
- `load-tmux-theme.sh` — called by `tmux.conf` at startup; sources `themes/{theme}/tmux.conf`
- `themes/{theme}/tmux.conf` — static tmux status bar config per theme
- `nvim/lua/config/theme.lua` — shared Lua helper that reads the `theme` file; used by `colorscheme.lua` and `ui.lua`

