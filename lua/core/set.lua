vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.o.mousemoveevent = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append "@-@"

vim.opt.updatetime = 50

vim.opt.timeoutlen = 5000

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

if vim.fn.has "win32" == 1 then
    vim.opt.colorcolumn = "100"

    vim.opt.shell = "pwsh.exe"
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
    vim.opt.shellxquote = ""
    vim.opt.shellquote = ""
    vim.opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s"
    vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s"
end
