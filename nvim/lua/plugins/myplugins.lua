local overrides = require "configs.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  -- Override plugin definition options
  { "lukas-reineke/indent-blankline.nvim", enabled = true },
  { "folke/which-key.nvim",                enabled = true },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "lukas-reineke/lsp-format.nvim",
      "rcarriga/nvim-notify",
      {
        "RRethy/vim-illuminate",
        config = function()
          require("illuminate").configure {
            providers = { "lsp" },
          }
          vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
          vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
          vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
        end,
      },
    },
    config = function()
      -- require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  -- overrde plugin configs
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      local conf = require "nvchad.configs.telescope"

      conf.defaults.mappings.i = {
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
        ["<Esc>"] = require("telescope.actions").close,
        ["<C-h>"] = "which_key"
      }

      return conf
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
    dependencies = {
      'nkrkv/nvim-treesitter-rescript',
    },
  },
  {
    "williamboman/mason.nvim",
    override_options = overrides.mason,
  },
  -- Install a plugin
  {
    "dmmulroy/tsc.nvim",
    ft = { "typescript", "javascript" },
    config = function()
      require("tsc").setup({
        auto_open_qflist = true,
        auto_close_qflist = false,
        enable_progress_notifications = true,
        flags = {
          noEmit = true,
        },
        hide_progress_notifications_from_history = true,
        spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
      })
    end,
  },
  {
    'dmmulroy/ts-error-translator.nvim',
    ft = { "typescript", "javascript" },
    config = function()
      require('ts-error-translator').setup()
    end,
  },
  {
    "rescript-lang/vim-rescript",
    ft = { "rescript" },
  },
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = function()
      return require "configs.configs.rust-tools"
    end,
    dependencies = {
      "neovim/nvim-lspconfig",
      {
        "saecki/crates.nvim",
        tag = "v0.3.0",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
          require("crates").setup {
            popup = {
              border = "rounded",
            },
          }
        end,
      },
    },
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    opts = {
      -- add any opts here
    },
    build = "make", -- This is optional, recommended tho. Also note that this will block the startup for a bit since we are compiling bindings in Rust.
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        -- Make sure to setup it properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  {
    "Olical/conjure",
    ft = { "clojure", "funnel", "rust", "sql" },
    config = function()
      vim.cmd [[
        let g:conjure#mapping#doc_word = v:false
        let g:conjure#mapping#def_word= v:false
        let g:conjure#extract#tree_sitter#enabled = v:true
        let g:conjure#extract#tree_sitter#enabled = v:true
        let g:conjure#client#clojure#nrepl#test#raw_out = v:true
        let g:conjure#client#clojure#nrepl#eval#print_buffer_size = 8192
        let g:conjure#client#clojure#nrepl#test#runner = "kaocha"
        " let g:conjure#client#clojure#nrepl#test#call_suffix = "{:kaocha/color? true :kaocha/reporter kaocha.report/dots :config-file \"tests.edn\"}"
        ]]
    end,
  },
  {
    "CosmicNvim/cosmic-ui",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("cosmic-ui").setup()
    end,
  },
  {
    "clojure-vim/vim-jack-in",
    ft = { "clojure", "funnel" },
    dependencies = {
      "tpope/vim-dispatch",
      "radenling/vim-dispatch-neovim",
    }
  },
  -- {
  --   "guns/vim-sexp",
  --   enabled = false,
  --   ft = { "clojure", "funnel" },
  --   dependencies = {
  --     "tpope/vim-repeat",
  --     "tpope/vim-surround",
  --     "tpope/vim-sexp-mappings-for-regular-people",
  --   }
  -- },
  {
    "julienvincent/nvim-paredit",
    ft = { "clojure", "funnel" },
    config = function()
      require("nvim-paredit").setup({
        filetypes = { "clojure", "funnel" },
      })
    end
  },
  {
    "tpope/vim-surround",
    -- enabled = false,
    lazy = false
  },
  { -- autoclose and autorename tags
    "windwp/nvim-ts-autotag",
    lazy = false,
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          -- Defaults
          enable_close = true,         -- Auto close tags
          enable_rename = true,        -- Auto rename pairs of tags
          enable_close_on_slash = true -- Auto close on trailing </
        },
      })
    end,
  },
  -- "francoiscabrol/ranger.vim",
  -- ["eraserhd/parinfer-rust"] = {
  --   run = "cargo build --release",
  -- },

  -- folding
  {
    "kevinhwang91/nvim-ufo",
    lazy = false,
    dependencies = {
      "kevinhwang91/promise-async",
      -- TODO: statuscol requires nvim 0.9
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          require("statuscol").setup(
            {
              foldfunc = "builtin",
              setopt = true
            }
          )
        end
      }
    },
    config = function()
      require("ufo").setup()
    end,
  },
  -- motions
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote Flash" },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc =
        "Treesitter Search"
      },
      {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc =
        "Toggle Flash Search"
      },
    },
  },
  {
    'akinsho/git-conflict.nvim',
    version = "*",
    config = true,
    lazy = false
  },
  {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "stevearc/dressing.nvim",     -- Recommended but not required. Better UI for pickers.
      "nvim-tree/nvim-web-devicons" -- Recommended but not required. Icons in discussion tree.
    },
    enabled = true,
    event = "VeryLazy",
    lazy = false,
    build = function() require("gitlab.server").build(true) end, -- Builds the Go binary
    config = function()
      require("gitlab").setup()
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    lazy = false,
    config = true,
    opts = {
      mappings = {
        finder = {
          ["<c-j>"] = "Next",
          ["<c-k>"] = "Previous",
        }
      }
    }
  },
  -- {
  --   "jiangmiao/auto-pairs",
  --   lazy = false
  -- },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        enabled = true,
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          local cond = require('nvim-autopairs.conds')
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
          --require("nvchad.configs.others").autopairs()
          require("nvim-autopairs").get_rule("'")[1].not_filetypes =
          { "scheme", "lisp", "clojure", "clojurescript", "fennel" }
          require("nvim-autopairs").get_rules("'")[1]:with_pair(cond.not_after_text("["))
        end,
      },

      {
        "supermaven-inc/supermaven-nvim",
        -- commit = "df3ecf7",
        event = "BufReadPost",
        enabled = false,
        opts = {
          disable_keymaps = false,
          disable_inline_completion = false,
          keymaps = {
            accept_suggestion = "<C-;>",
            clear_suggestion = "<Nop>",
            accept_word = "<C-y>",
          },
        },
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      local config = require "nvchad.configs.cmp"
      config.sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "supermaven" }
      }
      return config
    end,
  },
  -- database
  -- "tpope/vim-dadbod",
  -- "kristijanhusak/vim-dadbod-ui",
  -- "kristijanhusak/vim-dadbod-completion",
  -- remove plugin
  -- ["hrsh7th/cmp-path"] = false,
}

return plugins
