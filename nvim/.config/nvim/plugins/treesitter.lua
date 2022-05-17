require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {"clojure", "ruby", "javascript", "scss", "html", "yaml", "lua", "vim", "markdown"},
  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- indent = {
  --   enable = true,
  -- },
  -- to make it work with rainbow parenths
  highlight = {
    enable = true,
    -- custom_captures = {
    --   ["punctuation.bracket"] = "",
    --   ["constructor"]         = "",
    -- },
  },
  rainbow = {
    enable = true,
    colors = {
      '#0098e6', '#e16d6d', '#3fa455', '#c968e6', '#999', '#ce7e00'
    },
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}
