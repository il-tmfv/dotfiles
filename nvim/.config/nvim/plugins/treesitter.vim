lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",
  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,
  indent = {
    enable = true,
  },
  -- to make it work with rainbow parenths
  highlight = {
    enable = true,
    custom_captures = {
      ["punctuation.bracket"] = "",
      ["constructor"]         = "",
    },
  },
}
EOF
