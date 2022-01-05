local neogit = require("neogit")

neogit.setup {
  disable_commit_confirmation = true
}

vim.api.nvim_set_keymap('n', '<leader>k', '<cmd>Neogit<CR>', { noremap = true })
