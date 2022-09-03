require('telescope').setup{
  defaults = {
    file_ignore_patterns = {".git/", "node_modules/"},
    mappings = {
      n = {
        ["q"] = "close",
        ["<C-d>"] = "delete_buffer",
      }
    },
    vimgrep_arguments = {
      "rg",
      "--hidden",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case"
    },
  },
  pickers = {
    find_files = {
      hidden = true
    }
  }
}

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })

require('telescope').load_extension('fzf')
