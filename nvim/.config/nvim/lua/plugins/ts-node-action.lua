return {
  'ckolkey/ts-node-action',
  dependencies = { 'nvim-treesitter' },
  keys = {
    { "S", "<cmd>lua require('ts-node-action').node_action()<CR>", desc = "Trigger Node Action" }
  },
  opts = {},
}
