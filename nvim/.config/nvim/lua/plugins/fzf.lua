return {
  'ibhagwan/fzf-lua',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
    { 'junegunn/fzf', build = './install --bin', },
  },
  opts = {
    winopts = {
      preview = {
        horizontal = 'right:50%',
      }
    },
    keymap = {
      fzf = {
        ["tab"] = "down",
        ["shift-tab"] = "up",
      }
    },
  },
  keys = {
    { '<leader>fd', "<cmd>lua require('fzf-lua').tags_grep_cword()<cr>", noremap = true, silent = true },
    { '<leader>/', "<cmd>lua require('fzf-lua').blines()<cr>", noremap = true, silent = true },
    { '<leader>fj', "<cmd>lua require('fzf-lua').buffers()<cr>", noremap = true, silent = true },
    { '<leader>ff', "<cmd>lua require('fzf-lua').files()<cr>", noremap = true, silent = true },
    { '<leader>fg', "<cmd>lua require('fzf-lua').grep_project()<cr>", noremap = true, silent = true },
    { '<leader>fw', "<cmd>lua require('fzf-lua').grep_cword()<cr>", noremap = true, silent = true },
    { '<leader>fw', "<cmd>lua require('fzf-lua').grep_visual()<cr>", mode = 'v', noremap = true, silent = true },
  },
}
