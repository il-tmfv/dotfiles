" Better whitespaces
let g:strip_whitespace_confirm = 0
let g:strip_whitespace_on_save = 1
let g:strip_only_modified_lines = 1

" rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
\ 'guifgs': ['#0098e6', '#e16d6d', '#3fa455', '#c968e6', '#999', '#ce7e00'],
\ }

" fern
let g:fern#default_hidden = 1
let g:fern#renderer = "nerdfont"
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
