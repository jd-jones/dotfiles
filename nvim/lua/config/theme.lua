-- Reads the active theme from the dotfiles root `theme` file.
-- Format: "family/variant" e.g. "catppuccin/mocha", "kanagawa/wave".
-- Falls back to catppuccin/mocha if the file is missing or unreadable.
-- Uses symlink resolution so this works regardless of where the repo is cloned.
local M = {}

function M.get()
  local nvim_config = vim.fn.resolve(vim.fn.stdpath("config"))
  local dotfiles    = vim.fn.fnamemodify(nvim_config, ":h")
  local theme_file  = dotfiles .. "/theme"
  if vim.fn.filereadable(theme_file) == 1 then
    return vim.trim(vim.fn.readfile(theme_file)[1])
  end
  return "catppuccin/mocha"
end

-- Returns the theme family: "catppuccin", "kanagawa", or "tokyonight".
function M.get_family()
  return vim.split(M.get(), "/")[1]
end

-- Returns the variant: "mocha", "latte", "wave", "dragon", "moon", etc.
function M.get_variant()
  return vim.split(M.get(), "/")[2] or ""
end

-- Returns the Neovim colorscheme name, e.g. "catppuccin-mocha", "kanagawa-wave".
function M.get_colorscheme()
  local family  = M.get_family()
  local variant = M.get_variant()
  return variant ~= "" and (family .. "-" .. variant) or family
end

return M
