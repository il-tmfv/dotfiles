call plug#begin('~/.vim/plugged')
Plug 'shaunsingh/nord.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'wfxr/minimap.vim'
Plug 'ThePrimeagen/harpoon'

Plug 'nvim-lua/plenary.nvim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

Plug 'phaazon/hop.nvim', {'branch': 'v1'}
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'nicwest/vim-camelsnek'
Plug 'ThePrimeagen/refactoring.nvim'

Plug 'slim-template/vim-slim'
Plug 'tpope/vim-rails'

Plug 'kchmck/vim-coffee-script'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'p00f/nvim-ts-rainbow'
Plug 'cuducos/yaml.nvim'

Plug 'ruanyl/vim-gh-line'
Plug 'lewis6991/gitsigns.nvim'
Plug 'TimUntersberger/neogit'

Plug 'ntpeters/vim-better-whitespace'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'kyazdani42/nvim-tree.lua'

Plug 'akinsho/toggleterm.nvim'

Plug 'vim-test/vim-test'

Plug 'Olical/conjure'

Plug 'Shatur/neovim-session-manager'

Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ludovicchabant/vim-gutentags'
call plug#end()
