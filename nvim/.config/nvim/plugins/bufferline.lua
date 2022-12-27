require("bufferline").setup({
  options = {
    offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}},
    diagnostics = "coc"
  }
})

vim.api.nvim_set_keymap('n', '<leader>bc', '<cmd>BufferLinePickClose<CR>', { noremap = true })
