let mapleader=" "
let maplocalleader=","

inoremap jj <Esc>

" window management
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" buffers
nnoremap <silent> <TAB> :bnext<CR>
nnoremap <silent> <S-TAB> :bprevious<CR>

" tabbing
vnoremap < <gv
vnoremap > >gv

" move selection
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

" open file in external program
nnoremap gO :!open <cfile><CR>

" copy text selected with mouse
vmap <LeftRelease> "*ygv
