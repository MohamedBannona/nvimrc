return {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
    version = "v1.*",
    config = function()
        local is_enabled = function()
            local disabled_ft = {
                "TelescopePrompt",
                "grug-far",
            }
            return not vim.tbl_contains(disabled_ft, vim.bo.filetype)
                and vim.b.completion ~= false
                and vim.bo.buftype ~= "prompt"
        end

        local blink = require "blink.cmp"

        blink.setup {
            enabled = is_enabled,
            snippets = { preset = "luasnip" },
            -- ensure you have the `snippets` source (enabled by default)
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            keymap = {
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-f>"] = { "scroll_documentation_up", "fallback" },

                --["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = { "cancel", "fallback" },

                ["<CR>"] = { "select_and_accept", "fallback" },
            },
            completion = {
                menu = {
                    scrollbar = false,
                    auto_show = is_enabled,
                    border = {
                        { "󱐋", "WarningMsg" },
                        "─",
                        "╮",
                        "│",
                        "╯",
                        "─",
                        "╰",
                        "│",
                    },
                },
                documentation = {
                    auto_show = true,
                    window = {
                        border = {
                            { "", "DiagnosticHint" },
                            "─",
                            "╮",
                            "│",
                            "╯",
                            "─",
                            "╰",
                            "│",
                        },
                    },
                },
            },
        }
    end,
}
