vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'

vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
	local ft = vim.bo[args.buf].filetype
	local parsers = require('nvim-treesitter').get_installed("parsers")
	if vim.tbl_contains(parsers, ft) then
	    vim.treesitter.start(args.buf)
	end
    end,
})

require('nvim-treesitter').install { "javascript", "html", "css", "typescript", "angular", "rust", "go", "c", "cpp", "cmake", "markdown", "toml", "lua" }
