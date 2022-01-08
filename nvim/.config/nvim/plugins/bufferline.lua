require("bufferline").setup({
  options = {
    offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}},
    diagnostics = "nvim_lsp"
  }
})

vim.api.nvim_set_keymap('n', '<leader>bc', '<cmd>BufferLinePickClose<CR>', { noremap = true })
