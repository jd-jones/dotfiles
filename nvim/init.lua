-- Set leader before lazy.nvim loads (affects plugin keymaps registered at load time)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Options (ported from vimrc)
local opt = vim.opt
opt.number        = true
opt.cursorline    = true
opt.showmatch     = true
opt.expandtab     = true
opt.tabstop       = 4
opt.shiftwidth    = 4
opt.autoindent    = true
opt.exrc          = true   -- allow project-local .nvim.lua configs
opt.secure        = true
opt.termguicolors = true   -- required for true-color themes inside tmux
opt.signcolumn    = "yes"  -- keep gutter stable; prevents layout shift from LSP signs
opt.updatetime    = 250    -- faster LSP diagnostics
opt.splitright    = true
opt.splitbelow    = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
