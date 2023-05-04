local M = {}

M.ui = {
  lsp_semantic_tokens = true,
  hl_override = {
    NvDashAscii = {
      fg = "blue",
      bg = "black"
    },
    NvDashButtons = {
      bg = "black"
    }
  },
  theme_toggle = { "catppuccin", "one_light" },
  theme = "catppuccin",
  changed_themes = {
    catppuccin = {
      polish_hl = {
        ["@property"] = { fg = "#F38BA8" },
      },
    },
  },
  statusline = {
    theme = "default",
    separator_style = "arrow",
  },
  cmp = {
    style = "flat_light", -- default/flat_light/flat_dark/atom/atom_colored
  },
  nvdash = {
    load_on_startup = true,
    header = {
      "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣭⣿⣶⣿⣦⣼⣆         ",
      "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
      "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷⠄⠄⠄⠄⠻⠿⢿⣿⣧⣄     ",
      "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
      "          ⢠⣿⣿⣿⠈  ⠡⠌⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
      "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘⠄ ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
      "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
      " ⣠⣿⠿⠛⠄⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
      " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇⠄⠛⠻⢷⣄ ",
      "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
      "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
    },
    buttons = {
      { "  Find Projects", "Spc p p", "Telescope repo list" },
      { "  Find File",     "Spc f f", "Telescope find_files" },
      { "  Recent Files",  "Spc f o", "Telescope oldfiles" },
      { "  Find Word",     "Spc f w", "Telescope live_grep" },
      { "  Bookmarks",     "Spc b m", "Telescope marks" },
      { "  Themes",        "Spc t f", "Telescope themes" },
    },
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
