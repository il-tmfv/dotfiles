return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'cbochs/grapple.nvim'
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
      },
      lualine_y = {
        {
          function()
            local key = require("grapple").key()
            return "  [" .. key .. "]"
          end,
          cond = require("grapple").exists,
        }
      }
    }
  },
}
