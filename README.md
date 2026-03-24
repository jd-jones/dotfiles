# dotfiles

Personal configuration files for bash, zsh, tmux, and Neovim.

## Setup

```bash
bash install/macos.sh   # macOS
bash install/debian.sh  # Debian/Ubuntu
```

Both scripts install packages and run `install/symlinks.sh` to wire everything up.

## Theming

Three themes are supported consistently across tmux and Neovim: `catppuccin`, `kanagawa`, `tokyonight`.

```bash
./set-theme.sh catppuccin/mocha    # catppuccin: latte, frappe, macchiato, mocha
./set-theme.sh kanagawa/wave       # kanagawa: wave, dragon
./set-theme.sh tokyonight/moon
```

tmux status bars are powered by [tmux-ukiyo](https://github.com/Nybkox/tmux-ukiyo), which natively supports all three palette families. iTerm2 color presets are included for all major variants (Catppuccin Latte/Frappé/Macchiato/Mocha, Kanagawa Wave/Dragon, Tokyo Night Moon).

## tmux

| Binding | Action |
|---|---|
| `Ctrl+a` | Prefix |
| `prefix + h/j/k/l` | Pane navigation (vim-style) |
| `Ctrl+b` | Toggle nested tmux passthrough (status bar dims when active) |

Mouse support is enabled.

## Neovim

- Plugin manager: lazy.nvim
- LSP: mason + nvim-lspconfig (auto-installs `lua_ls`, `pyright`, `bashls`)
- Completion: nvim-cmp
- Fuzzy find: Telescope (`<leader>ff/fg/fb/fh`)
- Treesitter syntax/indent
- Gitsigns (`]c/[c` hunk navigation, `<leader>hs/hr/hp`)
- Leader key: `Space`

## Remote connections

Use `mosh` instead of `ssh` for remote sessions — survives IP changes, wifi/LTE switching, and sleep/wake. Pair with remote tmux for full session persistence.

