local floating_window_config = {
    relative = "editor",
    row = math.floor((vim.o.lines - 8) / 2),
    col = math.floor((vim.o.columns - 50) / 2),
    width = 50,
    height = 8,
    border = "rounded",
    style = "minimal",
}

function Rojo_Project()
    return vim.fs.root(0, function(name)
        return name:match ".+%.project%.json$"
    end)
end

function Create_Floating_Window(opts, bufId)
    local buf = bufId or vim.api.nvim_create_buf(false, true)

    local config = vim.tbl_deep_extend("force", floating_window_config, opts or {})
    local winid = vim.api.nvim_open_win(buf, true, config)

    return buf, winid
end
