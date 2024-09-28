return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "lopi-py/luau-lsp.nvim",
    },

    lazy = false,

    config = function()
        local cmp = require "cmp"
        local cmp_lsp = require "cmp_nvim_lsp"
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("mason").setup()
        require("mason-lspconfig").setup {
            ensure_installed = {
                "lua_ls",
                "gopls",
                "luau_lsp",
                "clangd",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                    }
                end,

                luau_lsp = function()
                    require("luau-lsp").setup {
                        platform = {
                            type = Rojo_Project() and "roblox" or "standard",
                        },
                        sourcemap = {
                            rojo_path = "argon",
                            autogenerate = false,
                        },
                        server = {
                            settings = {
                                ["luau-lsp"] = {
                                    require = {
                                        mode = "relativeToFile",
                                        directoryAliases = require("luau-lsp").aliases(),
                                    },
                                },
                            },
                        },
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require "lspconfig"
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = {
                                        "vim",
                                        "it",
                                        "describe",
                                        "before_each",
                                        "after_each",
                                    },
                                },
                            },
                        },
                    }
                end,
            },
        }

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup {
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ["<Esc>"] = cmp.mapping.abort(),
                ["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<CR>"] = cmp.mapping.confirm { select = true },
                ["<C-Space>"] = cmp.mapping.complete(),
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
            }, {
                { name = "buffer" },
            }),
        }

        vim.diagnostic.config {
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "if_many",
                header = "",
                prefix = "",
            },
        }
    end,
}
