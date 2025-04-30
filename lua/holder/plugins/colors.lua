local dataFilePath = vim.fn.stdpath "data" .. "\\colors"

local data = {
    default = "kanagawa",
    background = "dark",
}

function ColorMyPencils(color, mode)
    color = color or data.default
    mode = mode or data.background
    if color == "flexoki" then
        color = color .. "-" .. mode
    end

    vim.cmd.colorscheme(color)
    vim.o.background = mode
    vim.cmd [[
    highlight BlinkCmpMenu guibg=none ctermbg=none
    highlight BlinkCmpMenuBorder guibg=none ctermbg=none
]]

    local file = io.open(dataFilePath, "w+")
    if not file then
        error("could not save colorscheme", 1)
        return
    end
    file:write(color .. "\n" .. mode .. "\n")
    file:close()

    --  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

local lualine_dependency = { "nvim-lualine/lualine.nvim" }

do
    local file = io.open(dataFilePath, "r")
    if file then
        local colorscheme, background = file:read("l", "l")
        file:close()

        if colorscheme and colorscheme ~= "" then
            data.default = colorscheme
        end

        if background then
            data.background = background
        end
    end
end

return {
    {
        "Mofiqul/dracula.nvim",
        name = "dracula",
        opts = {
            show_end_of_buffer = true,
            italic_comment = true,
        },
        dependencies = lualine_dependency,
    },

    {
        "rmehri01/onenord.nvim",
        name = "onenord",
        opts = {
            theme = "dark",
            borders = true,
            fade_nc = true,
        },
        dependencies = lualine_dependency,
    },

    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        opts = {
            theme = "wave", -- vim.o.background = ""
            background = {
                dark = "dragon", -- vim.o.background = "dark"
                light = "lotus", -- vim.o.background = "light"
            },
        },
        dependencies = lualine_dependency,
    },
    {
        "kepano/flexoki-neovim",
        name = "flexoki",
        opts = { theme = "dark", borders = true },
        dependencies = lualine_dependency,
    },
}
