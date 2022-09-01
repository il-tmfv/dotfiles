vim.g.auto_ticket_save = 1
vim.g.ticket_black_list = {"master"}
vim.g.default_session_name = "master"

vim.api.nvim_set_keymap("n", "<F5>", ":SaveSession<CR>", { noremap = false })
vim.api.nvim_set_keymap("n", "<F6>", ":OpenSession<CR>", { noremap = false })
