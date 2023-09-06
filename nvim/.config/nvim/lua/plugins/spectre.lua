local exclude_files = "--glob=!{.git,.svn,.hg,CVS,.bzr,vendor,node_modules,dist,venv,elm-stuff,.clj-kondo,.lsp,tmp/*,tags,public/packs/*,public/packs-test/*,log/*}"

return {
  'nvim-pack/nvim-spectre',
  opts = {
    default = {
      find = {
        cmd = "rg",
        options = { "ignore-case", "regexp-search" }
      },
    },
    mapping = {
      ['toggle_ignore_case'] = {
        map = "ti",
        cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
        desc = "toggle ignore case"
      },
      ['toggle_ignore_hidden'] = {
        map = "th",
        cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
        desc = "toggle search hidden"
      },
      ['toggle_regex'] = {
        map = "tr",
        cmd = "<cmd>lua require('spectre').change_options('regexp-search')<CR>",
        desc = "toggle regexp use"
      },
      ['toggle_word_regex'] = {
        map = "tw",
        cmd = "<cmd>lua require('spectre').change_options('word-regexp')<CR>",
        desc = "toggle word regexps"
      },
    },
    find_engine = {
      ['rg'] = {
        args = {
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--no-ignore',
          exclude_files,
        },
        options = {
          ['ignore-case'] = {
            value= "--ignore-case",
            icon="[I]",
            desc="ignore case"
          },
          ['hidden'] = {
            value="--hidden",
            desc="hidden file",
            icon="[H]"
          },
          ['regexp-search'] = {
            value="--fixed-strings",
            desc="turn off regexp",
            icon="[!R]"
          },
          ['word-regexp'] = {
            value="--word-regexp",
            desc="word regexps",
            icon="[W]"
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>ss",
      function()
        require('spectre').open()
      end,
      noremap = true,
      silent = true,
      desc = "Replace in files (Spectre)"
    },
    {
      "<leader>sw",
      function()
        require('spectre').open_visual({ select_word = true })
      end,
      noremap = true,
      silent = true,
      desc = "Replace current word (Spectre)"
    },
    {
      "<leader>s",
      function()
        require('spectre').open_visual()
      end,
      mode = 'v',
      noremap = true,
      silent = true,
      desc = "Replace current word (Spectre)"
    },
  },
}
