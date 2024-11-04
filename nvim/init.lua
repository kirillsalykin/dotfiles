
local autocmd = vim.api.nvim_create_autocmd

local g = vim.g
g.maplocalleader = ","
g.ranger_command_override = "ranger --cmd \"set show_hidden=true\""
vim.wo.wrap = false
vim.wo.relativenumber = true

vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.maplocalleader = ","
vim.g.mapleader = " "

vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
