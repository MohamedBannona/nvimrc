local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
  return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvimtree.setup({
  renderer = {
    root_folder_label = function() return "/.." end
  },
  filters = {
    git_ignored = false,
    custom = {
      "^\\.git$",
    },
  },
})
