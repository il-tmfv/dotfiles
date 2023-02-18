return {
  'ludovicchabant/vim-gutentags',
  config = function()
    vim.g.gutentags_ctags_executable_ruby = 'ripper-tags'
    vim.g.gutentags_ctags_extra_args = {'--ignore-unsupported-options', '--recursive'}
  end
}
