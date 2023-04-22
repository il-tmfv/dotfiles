return {
  'tpope/vim-rails',
  config = function()
    vim.api.nvim_create_user_command("AC", [[execute "e " . eval('rails#buffer().alternate()')]], {})
    vim.api.nvim_create_user_command("FR", [[!bundle exec rubocop -a %]], {})
    vim.api.nvim_create_user_command("FRR", [[!bundle exec rubocop -A %]], {})
  end
}
