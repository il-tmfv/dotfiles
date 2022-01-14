vim.g.minimap_width = 10
vim.g.minimap_git_colors = 1
vim.g.minimap_highlight_search = 1

vim.api.nvim_set_keymap('n', '<leader>m', '<cmd>MinimapToggle<CR>', { noremap = true })
