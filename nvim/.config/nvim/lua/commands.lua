vim.api.nvim_create_user_command("YankRelPath", function()
	vim.cmd('let @* = expand("%")')
end, { nargs = 0 })

vim.api.nvim_create_user_command("YankAbsPath", function()
	vim.cmd('let @* = expand("%:p")')
end, { nargs = 0 })

vim.api.nvim_create_user_command("YankFileName", function()
	vim.cmd('let @* = expand("%:t")')
end, { nargs = 0 })
