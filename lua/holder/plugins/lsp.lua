local lsp_path = "D:\\Programs\\lsps\\"

local RobloxEnabled = true

local function non_mason_managed()
    local config = require "lspconfig"
    local util = require "lspconfig.util"
    config.zls.setup {
        cmd = { lsp_path .. "\\zls\\zls.exe" },
        on_new_config = function(new_config, new_root_dir)
            if vim.fn.filereadable(vim.fs.joinpath(new_root_dir, "zls.json")) ~= 0 then
                new_config.cmd = { "zls", "--config-path", "zls.json" }
            end
        end,
        filetypes = { "zig", "zir" },
        root_dir = util.root_pattern("zls.json", "build.zig", ".git"),
        single_file_support = true,
    }
end

local function setup_luau_lsp(roblox)
    local luau_lsp = require "luau-lsp"
    local rojo_project = Rojo_Project()

    local lune_ver = string.match(vim.fn.system "lune -V", "%d+%.%d+%.%d+")
    local lune_typedefs = "~/.lune/.typedefs/" .. lune_ver .. "/"

    local type_aliases
    if not roblox or not rojo_project then
        type_aliases = {
            ["@lune/"] = lune_typedefs,
        }
    end

    luau_lsp.setup {
        plugin = {
            enabled = true,
            port = 3667,
        },
        platform = {
            type = (roblox and rojo_project and "roblox") or "standard",
        },
        types = {
            roblox_security_level = "PluginSecurity",
        },
        sourcemap = {
            generatorCommand = "argon sourcemap",
        },
        server = {
            settings = {
                ["luau-lsp"] = {
                    ignoreGlobs = {
                        "**/_Index/**",
                        "node_modules/**",
                        "packages/**",
                        "roblox_packages/**",
                        "lune_packages/**",
                        "luau_packages/**",
                    },
                    hover = { multilineFunctionDefinitions = true },
                    require = {
                        mode = "relativeToFile",
                        directoryAliases = type_aliases,
                    },
                    completion = {
                        autocompleteEnd = true,
                        imports = {
                            enabled = true,
                        },
                    },
                },
            },
        },
    }
end

vim.api.nvim_create_user_command("ToggleRoblox", function()
    RobloxEnabled = not RobloxEnabled
    setup_luau_lsp(RobloxEnabled)
end, {})

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
                    setup_luau_lsp(true)
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

        cmp.setup {
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = {
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.close(),

                ["<CR>"] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                },

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require("luasnip").expand_or_jumpable() then
                        require("luasnip").expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif require("luasnip").jumpable(-1) then
                        require("luasnip").jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },

            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "nvim_lua" },
                { name = "path" },
            },
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

        non_mason_managed()
    end,
}
