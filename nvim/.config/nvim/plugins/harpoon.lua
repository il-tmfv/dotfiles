vim.api.nvim_set_keymap('n', '<leader>fl', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fa', ':lua require("harpoon.mark").add_file()<CR>', { noremap = true, silent = true })
