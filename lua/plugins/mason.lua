require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
	"lua_ls",
	"angularls",
	"ts_ls",
	"cssls",
	"html",
    },
    handlers = {
	function(server_name)
	    local capabilities = require('cmp_nvim_lsp').default_capabilities()

	    local opts = {
		capabilities = capabilities,
	    }

	    if server_name == "gopls" then
		opts.cmd = {"gopls"}
		opts.filetypes = {"go", "gomod", "gowork", "gotmpl"}
		opts.root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git")
		opts.settings = {
		    gopls = {
			completeUnimported = true,
		    },
		}
	    elseif server_name == "jsonls" then
		opts.filetypes = {"json", "jsonc"}
		opts.settings = {
		    json = {
			schemas = {
			    { fileMatch = {"package.json"}, url = "https://json.schemastore.org/package.json" },
			    { fileMatch = {"tsconfig*.json"}, url = "https://json.schemastore.org/tsconfig.json" },
			},
		    },
		}
	    end

	    require('lspconfig')[server_name].setup(opts)
	end,
    }
})

