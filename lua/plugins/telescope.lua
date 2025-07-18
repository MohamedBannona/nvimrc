return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
    },

    lazy = false,

    config = function()
        require("telescope").setup {
            defaults = {
                file_ignore_patterns = {
                    "node_modules\\",
                    ".git\\",
                    "build\\",
                    "bin\\",
                },
            },
        }

        local builtin = require "telescope.builtin"
        vim.keymap.set("n", "<leader>pf", function()
            builtin.find_files {
                hidden = true,
                no_ignore = true,
            }
        end, {})
        vim.keymap.set("n", "<C-p>", builtin.git_files, {})
        vim.keymap.set("n", "<leader>pws", function()
            local word = vim.fn.expand "<cword>"
            builtin.grep_string { search = word }
        end)
        vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string { search = vim.fn.input "Grep > " }
        end)
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
    end,
}
