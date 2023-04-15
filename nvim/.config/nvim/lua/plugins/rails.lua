return {
  'tpope/vim-rails',
  config = function()
    vim.api.nvim_create_user_command("AC", [[execute "e " . eval('rails#buffer().alternate()')]], {})
  end
}
