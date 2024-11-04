---@type ChadrcConfig
local M = {
  base46 = {
    theme = "nord",
    hl_add = {},
    integrations = {},
    changed_themes = {
      catppuccin = {
        polish_hl = {
          ["@property"] = { fg = "#F38BA8" },
        },
      },
    },
    transparency = false,
    theme_toggle = { "nord", "nord" },
  },

  nvdash = {
    load_on_startup = true,
    header = {
      "                            ",
      "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
      "   ▄▀███▄     ▄██ █████▀    ",
      "   ██▄▀███▄   ███           ",
      "   ███  ▀███▄ ███           ",
      "   ███    ▀██ ███           ",
      "   ███      ▀ ███           ",
      "   ▀██ █████▄▀█▀▄██████▄    ",
      "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
      "                            ",
      "     Powered By  eovim    ",
      "                            ",
    },
    buttons = {
      { txt = "  Find Projects", keys = "Spc p p", cmd = "Telescope repo list" },
      { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
      { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
      { txt = "  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
      { txt = "  Bookmarks", keys = "Spc b m", cmd = "Telescope marks" },
      { txt = "  Themes", keys = "Spc t f", cmd = "Telescope themes" },
      { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },

      {
        txt = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime) .. " ms"
          return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
        end,
        hl = "NvDashLazy",
        no_gap = true,
      },

      { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
    },
  },
  ui     = {
    lsp_semantic_tokens = true,
    statusline = {
      theme = "default",
      separator_style = "arrow",
    },
    cmp = {
      style = "flat_light", -- default/flat_light/flat_dark/atom/atom_colored
      format_colors = {
        tailwind = true,
        icon = "󱓻",
      },
    }
  }
}

-- M.plugins = "plugins"

-- check core.mappings for table structure
-- M.mappings = require "mappings"

return M
