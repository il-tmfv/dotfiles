return {
  "gabrielpoca/replacer.nvim",
  keys = {
    {
      '<leader>cr',
      [[:lua require("replacer").run()<cr>]],
      silent = true,
      noremap = true,
      desc = 'Start editing quickfix list'
    },
  },
}
