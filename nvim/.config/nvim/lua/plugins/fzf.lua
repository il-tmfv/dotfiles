local exclude_files = "!{.git,.svn,.hg,CVS,.bzr,vendor,node_modules,dist,venv,elm-stuff,deps,_build,.clj-kondo,assets/node_modules,.lsp,tmp/*,public/packs/*,public/packs-test/*,log/*}"
local grep_args = [[ { cmd = 'rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden --glob "]] .. exclude_files .. [["' } ]]
local files_args = [[ { cmd = 'rg --files --follow --no-ignore --hidden --glob "]] .. exclude_files .. [["' } ]]

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
  },
  keys = {
    { '<leader>fd', "<cmd>lua require('fzf-lua').tags_grep_cword()<cr>", noremap = true, silent = true },
    { '<leader>fD', "<cmd>lua require('fzf-lua').tags()<cr>", noremap = true, silent = true },
    { '<leader>/', "<cmd>lua require('fzf-lua').blines()<cr>", noremap = true, silent = true },
    { '<leader>fj', "<cmd>lua require('fzf-lua').buffers()<cr>", noremap = true, silent = true },
    {
      '<leader>fo',
      "<cmd>lua require('fzf-lua').oldfiles(" .. files_args .. ")<cr>",
      noremap = true,
      silent = true
    },
    {
      '<leader>fc',
      "<cmd>lua require('fzf-lua').resume()<cr>",
      noremap = true,
      silent = true
    },
    {
      '<leader>ff',
      "<cmd>lua require('fzf-lua').files(" .. files_args .. ")<cr>",
      noremap = true,
      silent = true
    },
    {
      '<leader>fg',
      "<cmd>lua require('fzf-lua').grep_project(" .. grep_args ..")<cr>",
      noremap = true,
      silent = true
    },
    {
      '<leader>fw',
      "*``<cmd>lua require('fzf-lua').grep_cword(" .. grep_args .. ")<cr>",
      noremap = true,
      silent = true
    },
    {
      '<leader>fw',
      "*``<cmd>lua require('fzf-lua').grep_visual(" .. grep_args .. ")<cr>",
      mode = 'v',
      noremap = true,
      silent = true
    },
  },
}
