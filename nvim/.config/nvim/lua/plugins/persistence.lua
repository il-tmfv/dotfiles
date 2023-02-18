return {
  "folke/persistence.nvim",
  config = true,
  lazy = false,
  keys = {
    { "F6", [[<cmd>lua require("persistence").load()<cr>]], {} },
  },
}
