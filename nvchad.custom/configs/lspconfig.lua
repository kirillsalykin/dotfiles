local present, lspconfig = pcall(require, "lspconfig")

if not present then
  return
end

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
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

lspconfig["lua_ls"].setup {
  on_attach = new_on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}
