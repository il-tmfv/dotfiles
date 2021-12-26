vim.opt.list = true
vim.opt.listchars:append("space:⋅")

require("indent_blankline").setup {
    show_first_indent_level = false,
    space_char_blankline = " ",
}
