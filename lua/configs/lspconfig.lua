-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local defintionFilePath = vim.fn.stdpath "data" .. "\\LuauDefinitionFiles"
print((defintionFilePath))
-- EXAMPLE
local genericservers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(genericservers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.luau_lsp.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "luau-lsp", "lsp", "--definitions", defintionFilePath.."\\globalTypes.d.luau", "--docs", defintionFilePath.."\\docs_en-us.json" },
  settings = {
    platform = {
      definitionFiles = { defintionFilePath .. "\\globalTypes.d.luau" },
      documentationFiles = { defintionFilePath .. "\\docs_en-us.json" },
      type = "roblox",
    },
    types = {
      roblox = true,
      roblox_security_level = "PluginSecurity",
    },
    sourcemap = {
      enabled = true,
      autogenerate = false,
      rojo_project_file = "default.project.json", --?
    },
    plugin = {
      enabled = true,
      port = 3667,
    },
  },
}

-- config
-- uring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
