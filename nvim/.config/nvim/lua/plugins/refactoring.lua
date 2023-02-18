return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    {"nvim-lua/plenary.nvim"},
    {"nvim-treesitter/nvim-treesitter"},
  },
  keys = {
    { "<leader>rr", ":lua require('refactoring').select_refactor()<CR>", noremap = true, silent = true, expr = false, mode = 'v', desc = "Open refactoring prompt" },
  },
  config = true,
}
