function ColorMyPencils(color)
    color = color or "onenord"
    vim.cmd.colorscheme(color)

    print(select(
        2,
        pcall(require("lualine").setup, {
            options = {
                -- ... your lualine config
                theme = "onenord",
                -- ... your lualine config
            },
        })
    ))

    --  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

local lualine_dependency = { "nvim-lualine/lualine.nvim" }

return {
    {
        "Mofiqul/dracula.nvim",
        name = "dracula",
        opts = {
            show_end_of_buffer = true, -- default false
            -- set italic comment
            italic_comment = true,     -- default false
        },
        dependencies = lualine_dependency,
    },

    {
        "rmehri01/onenord.nvim",
        name = "onenord",
        config = function()
            require("onenord").setup {
                theme = "dark",
                borders = true,
                fade_nc = true,
            }

            vim.cmd "colorscheme rose-pine"

            ColorMyPencils()
        end,
        dependencies = lualine_dependency,
    },
}
