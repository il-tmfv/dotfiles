vim.opt.list = true
vim.opt.listchars:append("space:⋅")

require("indent_blankline").setup {
    show_first_indent_level = false,
    show_current_context = true,
    space_char_blankline = " ",
    bufname_exclude = {'NeogitStatus'},
    filetype_exclude = {'help', 'NeogitStatus'},
}
