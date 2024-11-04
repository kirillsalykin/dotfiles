local lspconfig = require "lspconfig"

local capabilities = require("nvchad.configs.lspconfig").capabilities
local servers = {
  "astro",
  "html",
  "cssls",
  "tailwindcss",
  "clojure_lsp",
  "eslint",
  "efm",
  "graphql",
  "sqlls",
  "ocamllsp",
  "emmet_language_server"
}

local prettier = {
  formatCommand =
  [[$([ -n "$(command -v node_modules/.bin/prettier)" ] && echo "node_modules/.bin/prettier" || echo "prettier") --stdin-filepath "${INPUT}" ${--config-precedence:configPrecedence} ${--tab-width:tabWidth} ${--single-quote:singleQuote} ${--trailing-comma:trailingComma}]],
  formatStdin = true,
}

local languages = {
  typescript = { prettier },
  javascript = { prettier },
  typescriptreact = { prettier },
  javascriptreact = { prettier },
  yaml = { prettier },
  json = { prettier },
  html = { prettier },
  scss = { prettier },
  css = { prettier },
  markdown = { prettier },
  astro = { prettier },
}

require("lsp-format").setup {}
local map = vim.keymap.set
local on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  vim.keymap.set('n', 'gD',
    function()
      require("telescope.builtin").lsp_references()
    end,
    opts "Find references")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  vim.keymap.set('n', 'gi',
    function()
      require("telescope.builtin").lsp_implementations()
    end,
    opts "Find implementation")

  vim.keymap.set('n', '<leader>si',
    function()
      require("telescope.builtin").lsp_document_symbols()
    end,
    opts "List symbols in current buffer")
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>lf", vim.diagnostic.open_float, opts "Show hover diagnostic")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

  map("n", "<leader>ra", function()
    require "nvchad.lsp.renamer" ()
  end, opts "NvRenamer")

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

local new_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true

  require("lsp-format").on_attach(client)
end

local rescript_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true

  require("lsp-format").on_attach(client)
  client.server_capabilities.semanticTokensProvider = nil
end

for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    on_attach = new_on_attach,
    capabilities = capabilities,
  }
end

lspconfig.ts_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  single_file_support = true,
  init_options = {
    preferences = {
      includeCompletionsWithSnippetText = true,
      includeCompletionsWithInsertText = true,
    },
  },
  settings = {
    completions = {
      completeFunctionCalls = true,
    },
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}

lspconfig.efm.setup {
  capabilities = capabilities,
  on_attach = new_on_attach,
  init_options = { documentFormatting = true },
  root_dir = vim.loop.cwd,
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git/" },
    lintDebounce = 100,
    -- logLevel = 5,
    languages = languages,
  },
}

lspconfig.rescriptls.setup {
  cmd = { 'rescript-lsp', '--stdio' },
  capabilities = capabilities,
  on_attach = rescript_on_attach,
}

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
