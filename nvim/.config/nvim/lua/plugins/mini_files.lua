local minifiles_toggle = function(...)
  if not MiniFiles.close() then MiniFiles.open(...) end
end

return {
  'echasnovski/mini.files',
  version = '*',
  config = true,
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  keys = {
    { '<leader>e', minifiles_toggle, noremap = true, desc = 'Toggle mini.files' },
    { '<leader>fr', '<cmd>:lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', noremap = true, desc = 'Reveal file in mini.files' },
  },
}
