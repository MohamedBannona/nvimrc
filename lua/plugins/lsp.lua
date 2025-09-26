local lsp_path = "D:\\Programs\\lsps\\"
local signs = { ERROR = "", WARN = "", HINT = "", INFO = "" }

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

    local lune_ver = string.match(vim.fn.system "lune10 -V", "%d+%.%d+%.%d+")
    if not lune_ver then
        lune_ver = string.match(vim.fn.system "lune -V", "%d+%.%d+%.%d+")
    end
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
            enabled = true,
            rojo_path = "argon",
            include_non_scripts = false,
            generatorCommand = { "argon", "sourcemap", "-o", "sourcemap.json", "--none-scripts" },
        },

        server = {
            settings = {
                ["luau-lsp"] = {
                    inlayHints = {
                        parameterNames = "all",
                    },
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
        fflags = {
            enable_new_solver = true,
        },
    }
end

vim.api.nvim_create_user_command("ToggleRoblox", function()
    RobloxEnabled = not RobloxEnabled
    setup_luau_lsp(RobloxEnabled)
    vim.cmd "LspRestart luau-lsp"
end, {})

vim.diagnostic.config {
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
        linehl = {},
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
    virtual_text = {
        prefix = "",
        spacing = 2,
        source = true,
        format = function(diagnostic)
            local severity = vim.diagnostic.severity[diagnostic.severity]
            local icon = signs[severity] or "●"
            return icon .. " " .. diagnostic.message
        end,
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
}

return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "saghen/blink.cmp",
        "L3MON4D3/LuaSnip",
        "lopi-py/luau-lsp.nvim",
        "mfussenegger/nvim-lint",
    },

    event = { "BufNewFile", "BufReadPre" },

    config = function()
        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            require("blink.cmp").get_lsp_capabilities(),
            {
                workspace = {
                    didChangeWatchedFiles = {
                        dynamicRegistration = true,
                    },
                },
            },
            {
                textDocument = {
                    inlayHint = {
                        dynamicRegistration = true,
                        resolveProvider = true,
                    },
                },
            }
        )

        require("mason").setup()
        require("mason-lspconfig").setup {
            ensure_installed = {
                "rust_analyzer",
                "lua_ls",
                "gopls",
                "luau_lsp",
                "clangd",
            },
            automatic_enable = {
                exclude = {
                    "luau_lsp",
                },
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

        vim.lsp.inlay_hint.enable(true)

        non_mason_managed()
        setup_luau_lsp(true)
    end,
}
