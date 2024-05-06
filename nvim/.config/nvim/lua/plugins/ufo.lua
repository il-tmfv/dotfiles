return {
  'kevinhwang91/nvim-ufo',
  dependencies = { 'kevinhwang91/promise-async' },
  keys = {
    {
      "zR",
      ":lua require('ufo').openAllFolds()<CR>",
      noremap = true,
      silent = true,
      expr = false,
      mode = 'n',
      desc = "Open all folds"
    },
    {
      "zM",
      ":lua require('ufo').closeAllFolds()<CR>",
      noremap = true,
      silent = true,
      expr = false,
      mode = 'n',
      desc = "Close all folds"
    },
  },
  config = {
    provider_selector = function(bufnr, filetype, buftype)
      return {'lsp', 'indent'}
    end
  },
}
