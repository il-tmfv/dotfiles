return {
  "cbochs/grapple.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { '<leader>fl', [[:lua require("grapple").popup_tags()<CR>]], silent = true, noremap = true, desc = 'Toggle Grapple popup' },
    { '<leader>fa', [[:lua require("grapple").toggle()<CR>]], silent = true, noremap = true, desc = 'Toggle Grapple anon tag' },
    { '<leader>fA', [[:lua require("grapple").toggle({ key = string.format('"%s"', vim.fn.input('File tag: ')) })<CR>]], silent = true, noremap = true, desc = 'Toggle Grapple named tag' },
  },
  config = function()
    require("grapple").setup({
      scope = require("grapple").resolvers.git_branch,
      popup_options = {
        width = 120,
        height = 16,
      },
    })
  end,
}
