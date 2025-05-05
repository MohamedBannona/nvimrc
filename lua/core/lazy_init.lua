local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

function Rojo_Project()
    return vim.fs.root(0, function(name)
        return name:match ".+%.project%.json$"
    end)
end

vim.g.mapleader = " "
require("lazy").setup {
    defaults = { lazy = true },
    ui = {
        icons = {
            ft = "",
            lazy = "󰂠 ",
            loaded = "",
            not_loaded = "",
        },
    },
    spec = {
        { import = "plugins" },
    },
    change_detection = { notify = false },
}

ColorMyPencils()
