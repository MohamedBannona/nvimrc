return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        event = { "BufReadPost" },
        opts = {
            provider_selector = function()
                return { "lsp", "indent" }
            end,
        },
    },
    {
        "luukvbaal/statuscol.nvim",
        lazy = false,
        opts = function()
            local builtin = require "statuscol.builtin"
            return {
                setopt = true,
                segments = {
                    { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                    { text = { "%s" }, click = "v:lua.ScSa" },
                    {
                        text = { builtin.lnumfunc, " " },
                        condition = { true, builtin.not_empty },
                        click = "v:lua.ScLa",
                    },
                },
            }
        end,
    },
}
