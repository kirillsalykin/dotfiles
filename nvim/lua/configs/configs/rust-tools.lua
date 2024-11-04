local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local capabilities = configs.capabilities

local new_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true

  require("lsp-format").on_attach(client)
end


local options = {
  server = {
    on_attach = new_on_attach,
    capabilities = capabilities,
  }
}

return options
