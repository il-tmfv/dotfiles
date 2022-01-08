call plug#begin('~/.vim/plugged')
Plug 'shaunsingh/nord.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'windwp/nvim-spectre'

Plug 'phaazon/hop.nvim', {'branch': 'v1'}
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'nicwest/vim-camelsnek'

Plug 'slim-template/vim-slim'
Plug 'tpope/vim-rails'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'
Plug 'cuducos/yaml.nvim'

Plug 'ruanyl/vim-gh-line'
Plug 'lewis6991/gitsigns.nvim'
Plug 'TimUntersberger/neogit'

Plug 'ntpeters/vim-better-whitespace'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'kyazdani42/nvim-tree.lua'

Plug 'vim-test/vim-test'

Plug 'windwp/nvim-autopairs'
Plug 'folke/trouble.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
call plug#end()
