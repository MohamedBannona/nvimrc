return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("nvim-treesitter.configs").setup {
            -- A list of parser names, or "all"
            ensure_installed = {
                "vimdoc",

                "c",
                "c_sharp",
                "cpp",
                "zig",

                "go",
                "gomod",
                "gosum",

                "gdscript",

                "luau",
                "lua",
                "luadoc",

                "javascript",
                "typescript",

                "markdown",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = false,

            indent = {
                enable = true,
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { "markdown" },
            },
        }
        require("nvim-treesitter.install").compilers = { "zig", "clang", "gcc" }
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.cobol = {
            install_info = {
                url = "https://github.com/yutaro-sakamoto/tree-sitter-cobol.git",
                files = {
                    "src/parser.c",
                    "src/scanner.c",
                },
                branch = "main",
                generate_requires_npm = false,
                requires_generate_from_grammar = false,
            },
            filetype = "cbl",
        }

        parser_config.zap = {
            install_info = {
                url = "https://github.com/filiptibell/tree-sitter-zap.git",
                files = {
                    "src/parser.c",
                },
                branch = "main",
                generate_requires_npm = false,
                requires_generate_from_grammar = false,
            },
            filetype = "zap",
        }

        vim.treesitter.language.register("zap", "zap")
    end,
}
