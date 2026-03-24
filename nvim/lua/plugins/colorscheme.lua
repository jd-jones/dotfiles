-- Reads active theme from the dotfiles `theme` file at startup.
-- All three plugins are installed by lazy.nvim; only the active one loads eagerly.
-- To switch: run ./set-theme.sh catppuccin/mocha (or any family/variant) from dotfiles root.
local theme_mod = require("config.theme")
local family    = theme_mod.get_family()
local cs        = theme_mod.get_colorscheme()  -- e.g. "catppuccin-mocha", "kanagawa-wave"

return {
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    lazy     = family ~= "catppuccin",
    config   = family == "catppuccin" and function()
      vim.cmd.colorscheme(cs)
    end or nil,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy     = family ~= "kanagawa",
    config   = family == "kanagawa" and function()
      vim.cmd.colorscheme(cs)
    end or nil,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy     = family ~= "tokyonight",
    config   = family == "tokyonight" and function()
      vim.cmd.colorscheme(cs)
    end or nil,
  },
}
