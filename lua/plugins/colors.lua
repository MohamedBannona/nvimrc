local dataFilePath = vim.fn.stdpath "data" .. filePathSeperator .. "colors"

local data = {
    default = "kanagawa-wave",
    background = "dark",
}

local transparentGroups = {
    "Normal",
    "NormalNC",
    "Comment",
    "Constant",
    "Special",
    "Identifier",
    "Statement",
    "PreProc",
    "Type",
    "Underlined",
    "Todo",
    "String",
    "Function",
    "Conditional",
    "Repeat",
    "Operator",
    "Structure",
    "LineNr",
    "NonText",
    "SignColumn",
    "CursorLine",
    "CursorLineNr",
    "EndOfBuffer",
}

local isTransparent = false

---@param group string|string[]
local function clearGroup(group)
    local groups = type(group) == "string" and { group } or group
    for _, v in ipairs(groups) do
        local ok, prev_attrs = pcall(vim.api.nvim_get_hl, 0, { name = v })
        if ok and (prev_attrs.background or prev_attrs.bg or prev_attrs.ctermbg) then
            local attrs = vim.tbl_extend("force", prev_attrs, { bg = "NONE", ctermbg = "NONE" })
            attrs[true] = nil
            vim.api.nvim_set_hl(0, v, attrs)
        end
    end
end

local function applyColors(color, mode)
    local split = string.split(color, "-")
    if split[1] == "everforest" then
        color = split[1]
        if split[2] then
            vim.g.everforest_background = split[2]
        end
    end

    vim.cmd.colorscheme(color)
    vim.o.background = mode

    require("lualine").setup()

    if isTransparent then
        clearGroup(transparentGroups)
    end

    vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "NONE" })
end

function ColorMyPencils(color, mode)
    color = (color or data.default):lower()
    mode = mode or data.background
    if color == "flexoki" then
        color = color .. "-" .. mode
    end

    applyColors(color, mode)
    applyColors(color, mode)

    local file = io.open(dataFilePath, "w+")
    if not file then
        error("could not save colorscheme", 1)
        return
    end
    file:write(color .. "\n" .. mode .. "\n")
    file:close()
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

vim.api.nvim_create_user_command("EnableTransparent", function()
    if vim.fn.has "win32" == 1 then
        return
    end
    isTransparent = true
    clearGroup(transparentGroups)
end, {})

return {
    lazy = false,
    priorty = 100,
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
            theme = "wave",
            background = {
                dark = "dragon",
                light = "lotus",
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
    { "projekt0n/github-nvim-theme", name = "github" },
    { "sainnhe/everforest", name = "everforest" },
    { "catppuccin/nvim", name = "catppuccin" },
}
