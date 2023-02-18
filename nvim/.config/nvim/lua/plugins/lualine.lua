return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'nord',
    },
    sections = {
      lualine_c = {
        {
          'filename',
          path = 1
        }
      }
    }
  },
}
