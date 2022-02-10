vim.api.nvim_set_keymap("n", "<leader>S", ":lua require('spectre').open()<CR>", { noremap = true })
-- search current word
vim.api.nvim_set_keymap("n", "<leader>sw", ":lua require('spectre').open_visual({select_word=true})<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>s", ":lua require('spectre').open_visual()<CR>", { noremap = true })

-- search in current file
vim.api.nvim_set_keymap("n", "<leader>sp", "viw:lua require('spectre').open_file_search()<cr>", { noremap = true })

-- close spectre panel as window on the left
vim.api.nvim_set_keymap("n", "<leader>sq", "<C-w>h<cmd>q<CR>", { noremap = true })
