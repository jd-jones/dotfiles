return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",  -- new main branch requires nvim 0.12 nightly; master = stable API
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "bash", "c", "lua", "python", "markdown", "vim", "vimdoc" },
        auto_install    = true,
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end,
  },
}
