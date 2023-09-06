return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    'cuducos/yaml.nvim',
    'RRethy/nvim-treesitter-endwise',
  },
  -- lazy = false,
  build = ":TSUpdate",
  opts = {
    -- A list of parser names, or "all"
    ensure_installed = {
      "clojure",
      "ruby",
      "elixir",
      "javascript",
      "typescript",
      "tsx",
      "scss",
      "html",
      "yaml",
      "lua",
      "vim",
      "markdown"
    },
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
    endwise = {
      enable = true,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
