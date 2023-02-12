-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "keymaps" })

-- buffers
vim.api.nvim_set_keymap("n", "<TAB>", "<cmd>bnext<CR>", { noremap = true, silent = true, desc = "Move to next buffer" })
vim.api.nvim_set_keymap(
  "n",
  "<S-TAB>",
  "<cmd>bprevious<CR>",
  { noremap = true, silent = true, desc = "Move to previous buffer" }
)

-- better indenting
vim.api.nvim_set_keymap("v", "<", "<gv", { desc = "Move selection to the left" })
vim.api.nvim_set_keymap("v", ">", ">gv", { desc = "Move selection to the right" })

-- move selection
vim.api.nvim_set_keymap("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selected lines down" })
vim.api.nvim_set_keymap("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selected lines up" })

-- open file in external program
vim.api.nvim_set_keymap("n", "gO", "<cmd>!open <cfile><CR>", { desc = "Open file in external program" })

-- copy text selected with mouse
vim.api.nvim_set_keymap("v", "<LeftRelease>", '"*ygv', { desc = "Copy text selected with mouse" })