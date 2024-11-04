local present, lspconfig = pcall(require, "lspconfig")

if not present then
  return
end

local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local capabilities = configs.capabilities

local servers = { "html", "cssls", "tailwindcss", "clojure_lsp" }

require("lsp-format").setup {}

local new_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true

  require("lsp-format").on_attach(client)
end

for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    on_attach = new_on_attach,
    capabilities = capabilities,
  }
end
