local cmp = require("cmp")

cmp.setup({
    enabled = function()
	-- always enable in Lua files (for ---@type, ---@class, etc.)
	if vim.bo.filetype == "lua" then
	    return true
	end

	-- otherwise, keep default behavior
	local context = require("cmp.config.context")
	return not context.in_treesitter_capture("comment")
	and not context.in_syntax_group("Comment")
    end,
    mapping = cmp.mapping.preset.insert({
	["<C-d>"] = cmp.mapping.scroll_docs(-4),
	["<C-f>"] = cmp.mapping.scroll_docs(4),
	["<C-Space>"] = cmp.mapping.complete(),
	["<C-e>"] = cmp.mapping.close(),
	["<CR>"] = cmp.mapping.confirm({
	    behavior = cmp.ConfirmBehavior.Replace,
	    select = false,
	}),
    }),
    sources = cmp.config.sources({
	{ name = "nvim_lsp" },
    }, {
	{ name = 'path' },
	{ name = "buffer" },
    }),
    per_filetype = {
	codecompanion = { "codecompanion" },
    },
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
	{ name = 'path' }
    }, {
	{ name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
	{ name = 'buffer' }
    }
})

vim.cmd([[
    set completeopt=menuone,noinsert,noselect
    highlight! default link CmpItemKind CmpItemMenuDefault
]])
