return {
    "eandrju/cellular-automaton.nvim",
    keys = {
        {
            "<leader>ar",
            "<leader>ag",
            "<cmd>CellularAutomaton make_it_rain<cr>",
            "<cmd>CellularAutomaton game_of_life<cr>",
        },
    },
    config = function()
        vim.keymap.set(
            "n",
            "<leader>ar",
            "<cmd>CellularAutomaton make_it_rain<cr>",
            { desc = "Make it rain" }
        )
        vim.keymap.set(
            "n",
            "<leader>ag",
            "<cmd>CellularAutomaton game_of_life<cr>",
            { desc = "Game of life" }
        )
    end,
}
