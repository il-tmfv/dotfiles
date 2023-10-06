return {
  "voldikss/vim-translator",
  config = function()
    vim.g.translator_target_lang = "en"
    vim.g.translator_source_lang = "ru"
    vim.g.translator_default_engines = {"google", "bing"}
  end,
  keys = {
    { '<leader>tw', '<Plug>TranslateR', mode = 'n', silent = true, desc = 'Translate en-ru and replace' },
    { '<leader>tw', '<Plug>TranslateRV', mode = 'v', silent = true, desc = 'Translate en-ru selection and replace' },
  },
}
