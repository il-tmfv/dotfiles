set noshowmode
set nohlsearch
set hidden
set noerrorbells
set nu
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nowrap
set noswapfile
set nobackup
set nowritebackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=6
set colorcolumn=80,120
set signcolumn=yes
set cmdheight=2
set updatetime=300
set shortmess+=c
set mouse=a
set termguicolors

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99
set foldnestmax=3
set foldminlines=1
set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))

au BufRead,BufNewFile *.transit setfiletype ruby
