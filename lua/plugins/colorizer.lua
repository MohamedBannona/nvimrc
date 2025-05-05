return {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
        filetypes = {
            "*",
            lua = {
                "#%x%x%x%x%x%x",
            },
        },
    },
}
