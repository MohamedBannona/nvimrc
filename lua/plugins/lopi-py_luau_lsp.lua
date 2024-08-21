return {
  "lopi-py/luau-lsp.nvim",
  ft = "luau",
  opts = {
    sourcemap = {
      rojo_path = "argon",
      include_non_scripts = false,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
