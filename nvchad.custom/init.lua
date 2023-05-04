local autocmd = vim.api.nvim_create_autocmd

local g = vim.g
g.maplocalleader = ","
g.ranger_command_override = "ranger --cmd \"set show_hidden=true\""
vim.wo.wrap = false
vim.wo.relativenumber = true


-- Neovide
-- see ~/.local/share/nvim/neovide-settings.json
--     https://github.com/neovide/neovide/issues/1263#issuecomment-1094628137
if vim.g.neovide then
  local map = vim.keymap.set
  map('n', '<D-s>', ':w<CR>')      -- Save
  map('v', '<D-c>', '"+y')         -- Copy
  map('n', '<D-v>', '"+P')         -- Paste normal mode
  map('v', '<D-v>', '"+P')         -- Paste visual mode
  map('c', '<D-v>', '<C-R>+')      -- Paste command mode
  map('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
  vim.api.nvim_set_option("clipboard", "unnamed")

  vim.g.neovide_cursor_animation_length = 0
  vim.o.guifont = "FiraCode Nerd Font Mono:h12"
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_remember_window_position = true
  vim.g.neovide_input_use_logo = 1
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.opt.title = true

  vim.api.nvim_command([[
    augroup Neovide
      autocmd BufWritePost * :wshada
    augroup END
    ]])
end

-- folding settings
-- vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true



-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
