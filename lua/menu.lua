local function open_menu()
    require("snacks").picker.pick({
        title = "Command Palette",
        items = {
            {
                text = "Format buffer",
                action = function()
                    -- vim.lsp.buf.format()
                    require("conform").format({ async = true })
                end,
            },
            {
                text = "Toggle diagnostics",
                action = function()
                    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
                end,
            },
            {
                text = "Restart/Reload config",
                action = function()
                    vim.cmd("restart")
                end,
            },
            {
                text = "Mason",
                action = function()
                    vim.cmd("Mason")
                end,
            },
            {
                text = "Update Packages",
                action = function()
                    local unused = vim.iter(vim.pack.get())
                    :filter(function(x) return not x.active end)
                    :map(function(x) return x.spec.name end)
                    :totable()

                    vim.pack.del(unused)

                    vim.pack.update(nil, {force = true})
                end,
            },
            {
                text = "Show notifications",
                action = function()
                    require("telescope").extensions.notify.notify()
                end,
            },
            {
                text = "Buffer: Close all",
                action = function()
                    vim.async.run(function()
                        vim.cmd("bufdo bd!")
                    end)
                end,
            },
            {
                text = "Buffer: Close all except current",
                action = function()
                    vim.async.run(function()
                        vim.cmd("bufdo if bufname() !=# bufname('%') | bd! | endif")
                    end)
                end,
            },
            {
                text = "Save and Quit",
                action = function()
                    vim.async.run(function()
                        vim.cmd("wqa")
                    end)
                end,
            },
        },
        format = function(item)
            return { { item.text, "SnacksPickerLabel" } }
        end,
        confirm = function(picker, item)
            picker:close()
            if item and item.action then
                item.action()
            end
        end,
    })
end

vim.keymap.set("n", "<leader>M", open_menu, { desc = "Open Neovim menu" })

