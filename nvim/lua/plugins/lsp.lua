return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp", -- needed here so capabilities are available at config time
    },
    config = function()
      require("mason").setup()

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("gd",          vim.lsp.buf.definition,    "Go to definition")
        map("gr",          vim.lsp.buf.references,     "Go to references")
        map("K",           vim.lsp.buf.hover,          "Hover docs")
        map("<leader>rn",  vim.lsp.buf.rename,         "Rename symbol")
        map("<leader>ca",  vim.lsp.buf.code_action,    "Code action")
        map("<leader>e",   vim.diagnostic.open_float,  "Show diagnostic")
        map("[d",          vim.diagnostic.goto_prev,   "Prev diagnostic")
        map("]d",          vim.diagnostic.goto_next,   "Next diagnostic")
      end

      -- mason-lspconfig v2: handlers live inside setup(), not setup_handlers()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "bashls" },
        handlers = {
          -- Default handler: applied to every installed server
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end,

          -- lua_ls override: teach it about Neovim globals so it doesn't flag `vim.*`
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                Lua = {
                  diagnostics = { globals = { "vim" } },
                  workspace   = { checkThirdParty = false },
                },
              },
            })
          end,
        },
      })
    end,
  },
}
