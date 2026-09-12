vim.pack.add({
    "https://github.com/folke/snacks.nvim",
    "https://github.com/nvim-lua/plenary.nvim",

    "https://github.com/nvim-lualine/lualine.nvim", -- statusline

    -- treesitter
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/folke/ts-comments.nvim",

    -- lspconfig
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/williamboman/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig",

    -- cmp
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/hrsh7th/cmp-cmdline",
    "https://github.com/hrsh7th/nvim-cmp",

    -- telescope
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",

    -- dap
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/mfussenegger/nvim-dap",

    -- misc
    "https://github.com/windwp/nvim-autopairs", -- auto formats brackets when inserting new line
    "https://github.com/windwp/nvim-ts-autotag", -- auto close/rename html tags
    "https://github.com/stevearc/conform.nvim", -- formatting tools
    "https://github.com/echasnovski/mini.ai", -- support for selecting text objects (quotes, brackets, classes, functions)
    "https://github.com/echasnovski/mini.files", -- file explorer popup
    "https://github.com/kylechui/nvim-surround", -- add/change/delete surround chars
    "https://github.com/nvim-pack/nvim-spectre", -- search and replace panel (vscode like)
    "https://github.com/tpope/vim-fugitive", -- git integration (:G)
    "https://github.com/tpope/vim-sleuth", -- heuristically adjusts shiftwidth
    "https://github.com/rcarriga/nvim-notify", -- better notification ui
    "https://github.com/zbirenbaum/copilot.lua", -- GitHub copilot
    "https://github.com/justinmk/vim-sneak", -- quickjump inside file (s..)

    -- themes
    "https://github.com/typicode/bg.nvim", -- sync terminal background
    "https://github.com/zaldih/themery.nvim",
    "https://github.com/ellisonleao/gruvbox.nvim",
    "https://github.com/thesimonho/kanagawa-paper.nvim",
    "https://github.com/sainnhe/sonokai",
})

require("plugins.autocomplete")
require("plugins.dap")
require("plugins.lazydev")
require("plugins.mason")
require("plugins.telescope")
require("plugins.treesitter")

require("nvim-surround").setup({})
require("lualine").setup({});
require("snacks").setup({
    input = {},
    picker = {
	ui_select = true,
	layouts = {
	    select = {
		layout = {
		    relative = 'cursor',
		    row = 1,
		},
	    },
	},
    },
    terminal = {
	shell = "zsh",
	win = {
	    relative = 'editor',
	    style = 'minimal',
	    border = 'rounded',
	},
	keys = {
	    ['<C-h>'] = { '<C-w>h', expr = true, mode = { 'i', 'n', 't' } },
	    ['<C-j>'] = { '<C-w>j', expr = true, mode = { 'i', 'n', 't' } },
	    ['<C-k>'] = { '<C-w>k', expr = true, mode = { 'i', 'n', 't' } },
	    ['<C-l>'] = { '<C-w>l', expr = true, mode = { 'i', 'n', 't' } },
	}
    }
})


require("notify").setup({
    stages = "fade_in_slide_out",
    timeout = 3000,
    background_colour = "#000000",
})
vim.notify = require("notify")

require("ts-comments").setup({
    lang = {
	angular = "<!-- %s -->",
    }
})

require("mini.ai").setup({
  n_lines = 5000,
  custom_textobjects = {
    o = require("mini.ai").gen_spec.treesitter({ -- code block
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
    c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
    d = { "%f[%d]%d+" }, -- digits
    e = { -- Word with case
      { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
      "^().*()$",
    },
    u = require("mini.ai").gen_spec.function_call(), -- u for "Usage"
    U = require("mini.ai").gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
  },
})

require("mini.files").setup({
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 30,
  },
  options = {
    use_as_default_explorer = false,
  },
})

require('copilot').setup({
    panel = {
	enabled = true,
	auto_refresh = false,
	keymap = {
	    jump_prev = "[[",
	    jump_next = "]]",
	    accept = "<CR>",
	    refresh = "gr",
	    open = "<M-CR>",
	},
	layout = {
	    position = "bottom",
	    ratio = 0.4
	},
    },
    suggestion = {
	enabled = true,
	auto_trigger = false,
	hide_during_completion = true,
	debounce = 75,
	keymap = {
	    accept = "<M-l>",
	    accept_word = "<M-S-l>",
	    accept_line = false,
	    next = "<M-j>",
	    prev = "<M-k>",
	    dismiss = "<M-Esc>",
	},
    },
    filetypes = {
	cmake = true,
	yaml = false,
	markdown = false,
	help = false,
	gitcommit = false,
	gitrebase = false,
	hgcommit = false,
	svn = false,
	cvs = false,
	["."] = false,
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
    server_opts_overrides = {},
})

require("conform").setup({
    formatters_by_ft = {
	lua = { "stylua" },
	javascript = { "prettier" },
	typescript = { "prettier" },
	html = { "prettier" },
	css = { "prettier" },
    },
})

require('nvim-ts-autotag').setup({
    opts = {
	enable_close = false, -- Auto close tags
	enable_rename = true, -- Auto rename pairs of tags
	enable_close_on_slash = true -- Auto close on trailing </
    },
})

vim.g.sonokai_better_performance = 1
require("themery").setup({
    themes = {
	{
	    name = "Gruvbox dark",
	    colorscheme = "gruvbox",
	    before = [[
	    -- All this block will be executed before apply "set colorscheme"
	    vim.opt.background = "dark"
	    ]],
	},
	{
	    name = "Gruvbox light",
	    colorscheme = "gruvbox",
	    before = [[
	    vim.opt.background = "light"
	    ]],
	},
	"sonokai",
	"kanagawa-paper",
	"kanagawa-paper-ink",
	"kanagawa-paper-canvas",
    },
    livePreview = true,
})

