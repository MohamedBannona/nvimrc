return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "saghen/blink.cmp",
        lazy = false,
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
                    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            -- make lazydev completions top priority (see `:h blink.cmp`)
                            score_offset = 100,
                        },
                    },
                },
                keymap = {
                    ["<C-p>"] = { "select_prev", "fallback" },
                    ["<C-n>"] = { "select_next", "fallback" },
                    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                    ["<C-f>"] = { "scroll_documentation_up", "fallback" },

                    ["<C-e>"] = { "cancel", "fallback" },
                    ["<CR>"] = { "select_and_accept", "fallback" },

                    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
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

            vim.defer_fn(function()
                vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "NONE" })
                vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "NONE" })
            end, 500)
        end,
    },
}
