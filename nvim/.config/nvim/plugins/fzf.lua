require('fzf-lua').setup{
  winopts = {
    preview = {
      horizontal = 'right:50%',
    }
  }
}
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('fzf-lua').grep_project()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fw', "<cmd>lua require('fzf-lua').grep_cword()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>fw', "<cmd>lua require('fzf-lua').grep_visual()<cr>", { noremap = true, silent = true })