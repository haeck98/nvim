vim.g.mapleader = " "

-- load .nvim.lua files in projects
vim.g.exrc = true

vim.g.shiftwidth = 4
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true

vim.opt.foldcolumn = "1"
vim.opt.foldenable = true
vim.opt.foldlevel = 99

-- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- gutter
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

-- search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.g.wrap = true
vim.g.wrapindent = true

vim.opt.scrolloff = 5

-- vim.diagnostic.config({
--     virtual_lines = true
-- })


vim.cmd([[packadd nvim.undotree]])
vim.cmd([[packadd nvim.difftool]])

require("undotree")
require("difftool")
