require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

local function apply_mappings(disabled, general, tabufline)
  -- Apply disabled mappings
  if disabled then
    for mode, mappings in pairs(disabled) do
      for key, _ in pairs(mappings) do
        nomap(mode, key)
      end
    end
  end

  -- Apply general mappings
  if general then
    for mode, mappings in pairs(general) do
      for key, value in pairs(mappings) do
        if type(value) == "table" then
          if type(value[1]) == "function" then
            map(mode, key, value[1], { desc = value[2] })
          else
            map(mode, key, value[1], { desc = value[2] })
          end
        end
      end
    end
  end

  -- Apply tabufline mappings
  if tabufline and tabufline.plugin then
    for mode, mappings in pairs(tabufline) do
      if mode ~= "plugin" then
        for key, value in pairs(mappings) do
          if type(value) == "table" then
            if type(value[1]) == "function" then
              map(mode, key, value[1], { desc = value[2] })
            else
              map(mode, key, value[1], { desc = value[2] })
            end
          end
        end
      end
    end
  end
end



local M = {}

M.disabled = {
  n = {
    ["<leader>b"] = "",
  },
}

M.general = {
  n = {
    ["<Right>"] = { ":vertical resize +2 <CR>" },
    ["<Left>"] = { ":vertical resize -2 <CR>" },
    ["<Down>"] = { ":resize +2 <CR>" },
    ["<Up>"] = { ":resize -2 <CR>" },
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
    ["<leader>wv"] = { "<C-w>v", "Split pane right" },
    ["<leader>wh"] = { "<C-w>s", "Split pane down" },
    ["<leader>wc"] = { "<C-w>c", "Close current pane" },
    ["<leader>w="] = { "<C-w>=", "Balance windows" },
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
    ["<leader>ld"] = {
      function()
        require('telescope.builtin').diagnostics({ severity_bound = 0 })
      end,
      "List diagnostics in current project",
    },
    -- ["gi"] = {
    --   function()
    --     require("telescope.builtin").lsp_implementations()
    --   end,
    --   "Find implementations"
    -- },
    -- buffers
    ["<leader>gg"] = { function()
      if vim.g.nvdash_displayed then
        require("nvchad.tabufline").close_buffer()
      end
      vim.cmd "Neogit"
    end, "Open Neogit" },
    -- database
    ["<leader>du"] = { "<cmd> DBUIToggle<CR>", "Toggle dadbod ui" },

    -- autopair
    ["<localleader>w"] = {
      function()
        local paredit = require("nvim-paredit")
        -- place cursor and set mode to `insert`
        paredit.cursor.place_cursor(
        -- wrap element under cursor with `( ` and `)`
          paredit.wrap.wrap_element_under_cursor("( ", ")"),
          -- cursor placement opts
          { placement = "inner_start", mode = "insert" }
        )
      end,
      "Wrap element insert head",
    },

    ["<localleader>W"] = {
      function()
        local paredit = require("nvim-paredit")
        paredit.cursor.place_cursor(
          paredit.wrap.wrap_element_under_cursor("(", ")"),
          { placement = "inner_end", mode = "insert" }
        )
      end,
      "Wrap element insert tail",
    },

    -- same as above but for enclosing form
    ["<localleader>i"] = {
      function()
        local paredit = require("nvim-paredit")
        paredit.cursor.place_cursor(
          paredit.wrap.wrap_enclosing_form_under_cursor("( ", ")"),
          { placement = "inner_start", mode = "insert" }
        )
      end,
      "Wrap form insert head",
    },

    ["<localleader>I"] = {
      function()
        local paredit = require("nvim-paredit")
        paredit.cursor.place_cursor(
          paredit.wrap.wrap_enclosing_form_under_cursor("(", ")"),
          { placement = "inner_end", mode = "insert" }
        )
      end,
      "Wrap form insert tail",
    }
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

apply_mappings(M.disabled, M.general, M.tabufline)

-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--   callback = function(ev)
--     nomap("n", "gD")
--   end,
-- })
