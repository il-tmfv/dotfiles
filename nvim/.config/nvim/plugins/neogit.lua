local neogit = require("neogit")

neogit.setup {
  disable_commit_confirmation = true
}

vim.api.nvim_set_keymap('n', '<leader>K', '<cmd>Neogit<CR>', { noremap = true })
