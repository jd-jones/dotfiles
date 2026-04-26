local theme_mod = require("config.theme")
local family    = theme_mod.get_family()
local cs        = theme_mod.get_colorscheme()  -- e.g. "catppuccin-mocha", "kanagawa-wave"

-- Lualine theme names: catppuccin registers one per variant; kanagawa and tokyonight
-- use a single name that auto-matches the active colorscheme.
local lualine_theme = family == "catppuccin" and cs or family

-- Ensure lualine loads after the active colorscheme has registered its theme.
local theme_plugin = ({
  catppuccin = "catppuccin/nvim",
  kanagawa   = "rebelot/kanagawa.nvim",
  tokyonight = "folke/tokyonight.nvim",
  nord       = "shaunsingh/nord.nvim",
})[family]

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", theme_plugin },
    config = function()
      require("lualine").setup({
        options = { theme = lualine_theme },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    keys = {
      { "]c",         "<cmd>Gitsigns next_hunk<cr>",    desc = "Next git hunk" },
      { "[c",         "<cmd>Gitsigns prev_hunk<cr>",    desc = "Prev git hunk" },
      { "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>",   desc = "Stage hunk" },
      { "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>",   desc = "Reset hunk" },
      { "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
    },
  },
}
