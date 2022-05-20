vim.api.nvim_set_keymap("n", "<leader>S", "<Plug>CtrlSFPrompt", { noremap = false })
-- search current word
vim.api.nvim_set_keymap("n", "<leader>sw", "<Plug>CtrlSFCwordPath", { noremap = false })
vim.api.nvim_set_keymap("v", "<leader>sw", "<Plug>CtrlSFVwordPath", { noremap = false })

-- close spectre panel as window on the left
vim.api.nvim_set_keymap("n", "<leader>sq", ":CtrlSFToggle<CR>", { noremap = true })
