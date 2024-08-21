return {
  "lopi-py/luau-lsp.nvim",
  ft = "luau",
  opts = {
    sourcemap = {
      rojo_path = "argon",
      autogenerate = false, --currently it uses rojo syntax so must disable
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
