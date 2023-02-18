vim.g.mapleader = " "
vim.g.maplocalleader = ";"

vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "keymaps" })

-- buffers
vim.api.nvim_set_keymap("n", "<TAB>", "<cmd>bnext<CR>", { noremap = true, silent = true, desc = "Move to next buffer" })
vim.api.nvim_set_keymap(
  "n",
  "<S-TAB>",
  "<cmd>bprevious<CR>",
  { noremap = true, silent = true, desc = "Move to previous buffer" }
)

-- Move to window using the <ctrl> hjkl keys
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

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
