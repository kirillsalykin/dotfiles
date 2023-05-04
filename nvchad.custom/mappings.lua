local M = {}

M.disabled = {
  n = {
    ["<leader>b"] = "",
  },
}

M.general = {
  n = {
    [";"] = { ":", "command mode", opts = { nowait = true } },
    -- save
    ["<leader>fs"] = { "<cmd> w <CR>", "save file" },
    -- fold
    ["zm"] = {
      function()
        require('ufo').closeAllFolds()
      end,
      "Close all folds"
    },
    ["zr"] = {
      function()
        require('ufo').openAllFolds()
      end,
      "Close all folds"
    },
    -- jack-in
    ["<localleader>'"] = {
      "<cmd>Clj -Sdeps '{:deps {nrepl/nrepl {:mvn/version \"1.0.0\"} cider/cider-nrepl {:mvn/version \"0.30.0\"}} :aliases {:cider/nrepl {:main-opts [\"-m\" \"nrepl.cmdline\" \"--middleware\" \"[cider.nrepl/cider-middleware]\"]}}}' -Mdev:repl:test:cider/nrepl <CR>",
      "Clojure jack-in" },
    -- window management
    ["<C-h>"] = { "<C-w>h", "Move to left split" },
    ["<C-j>"] = { "<C-w>j", "Move to below split" },
    ["<C-k>"] = { "<C-w>k", "Move to above split" },
    ["<C-l>"] = { "<C-w>l", "Move to right split" },
    ["<leader>wv"] = { "<C-w>v", "Split pane right" },
    ["<leader>wh"] = { "<C-w>s", "Split pane down" },
    ["<leader>wc"] = { "<C-w>c", "Close current pane" },
    ["<leader>ss"] = {
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      "Search current buffer"
    },
    ["<leader>pp"] = {
      function()
        require 'telescope'.extensions.repo.list {}
      end,
      "Search available repos"
    },
    ["<leader>ra"] = {
      function()
        require("cosmic-ui").rename()
      end,
      "Rename symbol"
    },
    ["<leader>ca"] = {
      function()
        require("cosmic-ui").code_actions()
      end,
      "Code actions"
    },
    ["<leader>si"] = {
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      "List symbols in current buffer"
    },
    ["<leader>cj"] = {
      function()
        require("telescope.builtin").lsp_workspace_symbols()
      end,
      "List symbols in current project"
    },
    ["gD"] = {
      function()
        require("telescope.builtin").lsp_references()
      end,
      "Find references"
    },
    ["gi"] = {
      function()
        require("telescope.builtin").lsp_implementations()
      end,
      "Find implementations"
    },
    -- buffers
    ["<leader>gg"] = { "<cmd> Neogit <CR>", "Open Neogit" },
    -- database
    ["<leader>du"] = { "<cmd> DBUIToggle<CR>", "Toggle dadbod ui" },
  },
}

M.tabufline = {
  plugin = true,
  n = {
    ["<leader>b["] = {
      function()
        require("nvchad_ui.tabufline").tabuflinePrev()
      end,
      "goto prev buffer",
    },
    ["<leader>b]"] = {
      function()
        require("nvchad_ui.tabufline").tabuflineNext()
      end,
      "goto next buffer",
    },
  }
}

-- more keybinds!

return M
