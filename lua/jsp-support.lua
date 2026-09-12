-- Function to determine if the cursor is in a Java block within a JSP file
local function set_commentstring_for_jsp()
    -- Get the current buffer lines around the cursor position
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- Initialize flags to track whether we're inside a Java block
    local in_java_block = false

    -- Scan upwards to find the opening of the Java block if we're inside one
    for i = line_num, 1, -1 do
        if lines[i]:find("<%%") then
            in_java_block = true
            break
        elseif lines[i]:find("%%>") then
            in_java_block = false
            break
        end
    end

    -- Set the appropriate commentstring based on context
    if in_java_block then
        vim.bo.commentstring = "// %s"
    else
        vim.bo.commentstring = "<!-- %s -->"
    end
end

vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    pattern = "*.jsp",
    callback = set_commentstring_for_jsp,
})

