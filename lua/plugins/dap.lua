require("dapui").setup()
require("nvim-dap-virtual-text").setup({
    clear_on_continue = true,             -- clear virtual text on "continue" (might cause flickering when stepping)
})

require("dap").listeners.on_session["dapui_config"] = function(old, new)
    if new then
	require("dapui").open()
    end
end

-- we only define adapters here
-- for configurations we rely on .vscode/launch.json
for _, adapter in pairs({ "pwa-node", "pwa-chrome" }) do
    require("dap").adapters[adapter] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
	    command = "js-debug-adapter",
	    args = { "${port}" },
	},
    }
end

