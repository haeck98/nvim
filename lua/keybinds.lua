vim.keymap.set("n", "<leader>F", function()
    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, {desc = "Open mini.files (Directory of Current File)"})

------------------------------------------------------------
-- ✍️ Editing
------------------------------------------------------------
-- Move inside wrapped lines
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "gj", "j")
vim.keymap.set({ "n", "v" }, "gk", "k")

-- Insert mode: escape
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<Leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>P", '"+P', { desc = "Paste before from system clipboard" })

-- search and replace
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})

------------------------------------------------------------
-- 💾 Saving
------------------------------------------------------------
vim.keymap.set("n", "<Leader>wa", ":wa<CR>", { desc = "Save all" })

------------------------------------------------------------
-- 🔎 LSP & Diagnostics
------------------------------------------------------------
vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", { desc = "Go to definition" })
vim.keymap.set("n", "gt", ":Telescope lsp_type_definitions<CR>", { desc = "Go to type definition" })
vim.keymap.set("n", "<Leader>r", ":Telescope lsp_references<CR>", { desc = "References" })
vim.keymap.set("n", "<Leader>s", ":Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
vim.keymap.set("n", "<Leader>ws", ":Telescope lsp_workspace_symbols<CR>", { desc = "Workspace symbols" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })

-- Diagnostics
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({count = -1})
end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({count = 1})
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<Leader>D", ":Telescope diagnostics bufnr=0<CR>", { desc = "Buffer diagnostics" })

------------------------------------------------------------
-- 🔭 Telescope
------------------------------------------------------------
vim.keymap.set("n", "<Leader>q", ":Telescope quickfix<CR>", { desc = "Find files" })
vim.keymap.set("n", "<Leader>f", ":Telescope find_files hidden=true<CR>", { desc = "Find files" })
vim.keymap.set("v", "<Leader>f", function()
    vim.cmd('normal! ""y')
    require("telescope.builtin").find_files({ default_text = vim.fn.getreg('"') })
end, { desc = "Find files for selection" })

local function multi_grep(opts)
    local conf = require("telescope.config").values
    local finders = require "telescope.finders"
    local make_entry = require "telescope.make_entry"
    local pickers = require "telescope.pickers"

    local flatten = vim.tbl_flatten

    opts = opts or {}
    opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
    opts.shortcuts = opts.shortcuts
    or {
        ["l"] = "*.lua",
        ["a"] = "*.{ts,html,css}"
    }
    opts.pattern = opts.pattern or "%s"

    local custom_grep = finders.new_async_job {
        command_generator = function(prompt)
            if not prompt or prompt == "" then
                return nil
            end

            local prompt_split = vim.split(prompt, "  ")

            local args = { "rg" }
            if prompt_split[1] then
                table.insert(args, "-e")
                table.insert(args, prompt_split[1])
            end

            if prompt_split[2] then
                table.insert(args, "-g")

                local pattern
                if opts.shortcuts[prompt_split[2]] then
                    pattern = opts.shortcuts[prompt_split[2]]
                else
                    pattern = prompt_split[2]
                end

                table.insert(args, string.format(opts.pattern, pattern))
            end

            return flatten {
                args,
                { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
            }
        end,
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = opts.cwd,
    }

    pickers
    .new(opts, {
        debounce = 100,
        prompt_title = "Live Grep (with shortcuts)",
        finder = custom_grep,
        previewer = conf.grep_previewer(opts),
        sorter = require("telescope.sorters").empty(),
        -- default_text = opts.default_text or "",
    })
    :find()
end

vim.keymap.set("n", "<leader>g", function()
    multi_grep({ })
end, { desc = "Grep" })
vim.keymap.set("v", "<leader>g", function()
    vim.cmd('normal! ""y')

    multi_grep({
        default_text = vim.fn.getreg('"')
    })
end, { desc = "Grep for selection" })
vim.keymap.set("n", "<Leader>/", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Search in buffer" })
vim.keymap.set("v", "<Leader>/", function()
    vim.cmd('normal! ""y')
    require("telescope.builtin").current_buffer_fuzzy_find({ default_text = vim.fn.getreg('"') })
end, { desc = "Search in buffer for selection" })
vim.keymap.set("n", "<Leader>G", ":Telescope git_status<CR>", { desc = "Git status" })
vim.keymap.set("n", "<Leader><Leader>", function()
    require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true })
end, { desc = "Switch buffer" })
vim.keymap.set("n", "<leader>tr", ":Telescope resume<CR>", { desc = "Telescope resume" })
vim.keymap.set("n", "<leader>tp", ":Telescope pickers<CR>", { desc = "Telescope pickers" })
vim.keymap.set("n", "<leader>th", ":Telescope help_tags<CR>", { desc = "Telescope help_tags" })
vim.keymap.set("n", "<leader>tk", ":Telescope keymaps<CR>", { desc = "Telescope keymaps" })

------------------------------------------------------------
-- 🅰️ Angular (Buffer-local bindings)
------------------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "*.component.ts", "*.module.ts" },
    callback = function()
        vim.keymap.set("n", "<leader>ai", [[/imports\s*:\s*\[<CR>f[%]], { buffer = true, desc = "Jump to imports" })
        vim.keymap.set("n", "<leader>as", [[/styles\(?:Urls\)\?\s*:<CR>]], { buffer = true, desc = "Jump to styles" })
        vim.keymap.set("n", "<leader>at", [[/template\(?:Url\)\?\s*:<CR>]], { buffer = true, desc = "Jump to template" })
    end,
})

------------------------------------------------------------
-- DAP
------------------------------------------------------------
vim.keymap.set("n", "<Leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<Leader>dc", ":lua require'dap'.continue()<CR>", { desc = "Continue" })
vim.keymap.set("n", "<Leader>ds", ":lua require'dap'.step_over()<CR>", { desc = "Step over" })
vim.keymap.set("n", "<Leader>di", ":lua require'dap'.step_into()<CR>", { desc = "Step into" })
vim.keymap.set("n", "<Leader>dt", ":lua require'dap'.terminate()<CR>", { desc = "Terminate" })
vim.keymap.set("n", "<Leader>du", ":lua require'dapui'.toggle()<CR>", { desc = "Toggle DAP UI" })

------------------------------------------------------------
-- Custom
------------------------------------------------------------
vim.keymap.set({"n", "t"}, "<leader>tt", function()
    require("snacks.terminal").toggle("zsh")
end)
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
vim.keymap.set("t", "<esc>e", "<c-\\><c-n>")
vim.keymap.set("t", "~~", "<c-\\><c-n>")
