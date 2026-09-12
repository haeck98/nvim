local hooks = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
    vim.system({ 'make' }, { cwd = ev.data.path }):wait()
  end
end
vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

local action_state = require('telescope.actions.state')

local function add_to_quickfix(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    if not entry then return end

    local qf_entry = {}

    if entry.path then
	qf_entry = {
	    filename = entry.path,
	    lnum = entry.lnum or 1,
	    col = entry.col or 1,
	    text = entry.text or "",
	}
    elseif entry.filename or entry.value then
	qf_entry = {
	    filename = entry.filename or "",
	    lnum = entry.lnum or 1,
	    col = entry.col or 1,
	    text = entry.value or "",
	}
    else
	return
    end

    -- Append to quickfix list
    vim.fn.setqflist({}, "a", { title = "Telescope", items = { qf_entry } })
end

require("telescope").setup {
    extensions = {
	fzf = {
	    fuzzy = true,
	    override_generic_sorter = true,
	    override_file_sorter = true,
	    case_mode = "smart_case",
	}
    },
    pickers = {
	find_files = {
	    find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git', },
	},
    },
    defaults = {
	mappings = {
	    i = { ["<C-a>"] = add_to_quickfix },
	    n = { ["<C-a>"] = add_to_quickfix },
	},
	layout_strategy = "flex",
	layout_config = {
	    horizontal = {
		preview_width = 0.55,
	    },
	    vertical = {
		preview_height = 0.6,
	    },
	    flex = {
		flip_columns = 120,
	    },
	},
	path_display = { "filename_first" },
	truncate = true,
	path_display_truncate = 3,
    },
}

require('telescope').load_extension('fzf')
