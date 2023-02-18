return {
  'akinsho/toggleterm.nvim',
  opts = {
    -- size can be a number or function which is passed the current terminal
    size = 30,
    open_mapping = [[<c-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    direction = 'float',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
  },
  config = function()
    -- lazygit integration
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      direction = "float",
      float_opts = {
        border = "double",
      },
    })

    function _lazygit_toggle()
      lazygit:toggle()
    end

    vim.api.nvim_set_keymap("n", "<leader>k", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
  end
}
