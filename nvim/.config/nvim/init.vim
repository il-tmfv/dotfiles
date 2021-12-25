lang en_US.UTF-8

inoremap jj <Esc>
set list " show invisible characters
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

call plug#begin('~/.vim/plugged')
Plug 'shaunsingh/nord.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'easymotion/vim-easymotion'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'cuducos/yaml.nvim'

Plug 'ruanyl/vim-gh-line'
Plug 'airblade/vim-gitgutter'
Plug 'TimUntersberger/neogit'

Plug 'ntpeters/vim-better-whitespace'

Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'lambdalisue/fern.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'luochen1990/rainbow'
call plug#end()

let g:rainbow_active = 1
let g:rainbow_conf = {
\ 'guifgs': ['#0098e6', '#e16d6d', '#3fa455', '#c968e6', '#999', '#ce7e00'],
\ }
colorscheme nord
let mapleader=" "

lua <<EOF
require('telescope').setup{
  defaults = {
    file_ignore_patterns = {".git/", "node_modules/"}
  },
  pickers = {
    find_files = {
      hidden = true
    }
  }
}
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",
  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,
  indent = {
    enable = true,
  },
  -- to make it work with rainbow parenths
  highlight = {
    enable = true,
    custom_captures = {
      ["punctuation.bracket"] = "",
      ["constructor"]         = "",
    },
  },
}
EOF

let g:strip_whitespace_confirm = 0
let g:strip_whitespace_on_save = 1
let g:strip_only_modified_lines = 1

let g:fern#default_hidden = 1

au BufRead,BufNewFile *.transit setfiletype ruby
au BufRead,BufNewFile *.yml set filetype yaml

" fern
nnoremap <leader>fr <cmd>Fern . -reveal=%<cr>

" Git
nnoremap <leader>k <cmd>Neogit<cr>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" ale
let g:ale_linters = {
\   'ruby': ['ruby'],
\}

" CoC
let g:coc_global_extensions = ['coc-solargraph']

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

