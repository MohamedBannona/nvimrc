local bufId, winId, on = -1, -1, false

local function toggleTerm()
    if not bufId or not vim.api.nvim_buf_is_valid(bufId) then
        local width = math.floor(vim.o.columns / 1.25)
        local height = math.floor(vim.o.lines / 1.25)

        bufId, winId = Create_Floating_Window {
            width = width,
            height = height,
            row = math.floor((vim.o.lines - height) / 2),
            col = math.floor((vim.o.columns - width) / 2),
        }
        vim.cmd.terminal()
        on = true
        vim.cmd.startinsert()
    elseif on then
        if vim.api.nvim_win_is_valid(winId) then
            vim.api.nvim_win_hide(winId)
        else
        end
        on = false
    else
        local width = math.floor(vim.o.columns / 1.25)
        local height = math.floor(vim.o.lines / 1.25)

        bufId, winId = Create_Floating_Window({
            width = width,
            height = height,
            row = math.floor((vim.o.lines - height) / 2),
            col = math.floor((vim.o.columns - width) / 2),
        }, bufId)
        on = true
        vim.cmd.startinsert()
    end
end

vim.keymap.set({ "n" }, "<leader>tt", toggleTerm)
