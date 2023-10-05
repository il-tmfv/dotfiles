return {
  "airblade/vim-localorie",
  keys = {
    { '<leader>lt', ':call localorie#translate()<CR>', noremap = true, silent = true, desc = 'Show Rails translations for' },
    { '<leader>le', ':echo localorie#expand_key()<CR>', noremap = true, silent = true, desc = 'Echo the fully qualified key of the current line' },
  },
}
