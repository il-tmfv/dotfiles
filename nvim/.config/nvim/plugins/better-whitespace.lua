vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_confirm = 0
vim.g.strip_whitespace_on_save = 1
vim.g.strip_only_modified_lines = 1
-- https://github.com/ntpeters/vim-better-whitespace/issues/127#issuecomment-899600717
vim.cmd("autocmd BufWritePre * :StripWhitespaceOnChangedLines")
