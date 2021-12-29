lua <<EOL
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
EOL

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
