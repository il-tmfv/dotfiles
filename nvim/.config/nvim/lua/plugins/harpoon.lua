return {
  'ThePrimeagen/harpoon',
  opts = {
    menu = {
        width = vim.api.nvim_win_get_width(0) - 8,
        height = vim.api.nvim_win_get_height(0) - 8,
    }
  },
  keys = {
    { '<leader>fl', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', noremap = true, silent = true },
    { '<leader>fa', ':lua require("harpoon.mark").add_file()<CR>', noremap = true, silent = true },
  },
}
