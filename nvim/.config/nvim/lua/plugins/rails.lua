return {
  'tpope/vim-rails',
  config = function()
    vim.api.nvim_create_user_command("AC", [[execute "e " . eval('rails#buffer().alternate()')]], {})
    vim.api.nvim_create_user_command("FR", [[!dip rubocop -a %]], {})
    vim.api.nvim_create_user_command("FRR", [[!dip rubocop -A %]], {})
  end
}
