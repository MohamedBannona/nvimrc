return {
    "supermaven-inc/supermaven-nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        mode = "free",
        keymaps = {
            accept_suggestion = "<C-\\>", -- no good keybind 🙁
            clear_suggestion = "<C-]>",
            accept_word = "<C-j>",
        },
    },
}
