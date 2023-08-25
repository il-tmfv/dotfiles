return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    'p00f/nvim-ts-rainbow',
    'cuducos/yaml.nvim',
    'RRethy/nvim-treesitter-endwise',
  },
  -- lazy = false,
  build = ":TSUpdate",
  opts = {
    -- A list of parser names, or "all"
    ensure_installed = {"clojure", "ruby", "elixir", "javascript", "scss", "html", "yaml", "lua", "vim", "markdown"},
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
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = ".",
        node_decremental = ",",
      },
    },
    refactor = {
      smart_rename = { enable = false },
      navigation = { enable = false },
      highlight_current_scope = { enable = false },
      highlight_definitions = {
        enable = true,
        clear_on_cursor_move = true,
      },
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
    },
    endwise = {
      enable = true,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
