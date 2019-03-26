" External plugin dependencies:
" ale: Requires flake8 for python linting (brew install flake8)

" Vundle
filetype off 				" required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'wkentaro/conque.vim'
Plugin 'joonty/vim-do.git'
Plugin 'w0rp/ale' "asynchrnouse linting
Plugin 'itchyny/lightline.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'flazz/vim-colorschemes'
Plugin 'taohex/lightline-buffer'
Plugin 'lervag/vimtex'
Plugin 'rust-lang/rust.vim'

"Plugin 'honza/vim-snippets' 
" Snippets are separated from the engine. Add this if you want them:
" All of these are required for snipmate
"Plugin 'MarcWeber/vim-addon-mw-utils'
"Plugin 'tomtom/tlib_vim'
"Plugin 'garbas/vim-snipmate'
"Plugin 'honza/vim-snippets'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" ================================================================================
" General Settings
" ================================================================================

" Set tab to 4 spaces.
set tabstop=4

" Make backspace work normally
set backspace=indent,eol,start

"Prevent lines from wrapping.
set nowrap

" Remap for esc key.
inoremap jj <Esc>l

" Stop the creation of swap files.
set nobackup
set nowritebackup
set noswapfile

" Number the lines
set number

" Turn off macros.
map q <Nop>

let mapleader="\<Space>"

" Stop beeping.
set visualbell

" Make the mouse work in iterm.
set ttyfast
set mouse=a

" Yank and Past to system clipboard.
set clipboard=unnamed

set hidden  " allow buffer switching without saving

" ================================================================================
" General Shortcuts
" ================================================================================

" Move between tabs
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprev<CR>
nnoremap <leader>a :b#<CR>

" Add saving shortcut.
nnoremap <leader>w :w<Cr>

" Add quiting shortcut.
nnoremap <leader>q :q<Cr>

" Switch between splits.
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
nnoremap <leader>l <C-W>l
nnoremap <leader>h <C-W>h

" Switch between splits.
nnoremap <leader><Up> <C-W>+
nnoremap <leader><Down> <C-W>-
nnoremap <leader><Left> <C-W><
nnoremap <leader><Right> <C-W>>

" Move splits around.
nnoremap <leader>J <C-W>J
nnoremap <leader>K <C-W>K
nnoremap <leader>L <C-W>L
nnoremap <leader>H <C-W>H

" ================================================================================
" Themes and Appearance
" ================================================================================

" Set syntax highlighting
syntax on

"Always display status bar
set laststatus=2

" set colorscheme
colorscheme sierra

" Stop the gutter from having its own colour.
highlight clear SignColumn

" ================================================================================
" Conque Term Settings
" ================================================================================

nnoremap <leader>s :ConqueTerm fish<CR>

let g:ConqueTerm_TERM = 'xterm-256color'
let g:ConqueTerm_Color = 1

" ================================================================================
" ALE Settings
" ================================================================================

" Keep the error column always open.
let g:ale_sign_column_always = 1

" Prevent warnings and errors from being highlighted.
highlight clear ALEErrorSign
highlight clear ALEWarningSign

" Format the linter error explanation.
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Jump to next linter error
nmap <silent> <leader>e <Plug>(ale_next_wrap)

" ================================================================================
" Lightline Settings
" ================================================================================

" Configure Lightline with ALE linter.
" This comes from  https://github.com/w0rp/ale
" For more info on how this works, see lightline documentation.
let g:lightline = {
	  \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'linter_warnings', 'linter_errors', 'linter_ok' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK',
		\ 'buffercurrent': 'lightline#buffer#buffercurrent2',
      \ },
      \ 'component_type': {
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
		\ 'buffercurrent': 'tabsel',
      \   'linter_ok': 'ok'
      \ },
	\ 'tabline': {
		\ 'left': [ [ 'bufferinfo' ], [ 'bufferbefore', 'buffercurrent', 'bufferafter' ], ],
		\ 'right': [ [ 'close' ], ],
		\ },
	\ 'component_function': {
		\ 'bufferbefore': 'lightline#buffer#bufferbefore',
		\ 'bufferafter': 'lightline#buffer#bufferafter',
		\ 'bufferinfo': 'lightline#buffer#bufferinfo',
		\ },
	\ }


autocmd User ALELint call lightline#update()

" ale + lightline
function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d --', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d >>', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓' : ''
endfunction

set showtabline=2

let g:lightline_buffer_modified_icon = '*'
let g:lightline_buffer_separator_icon = ''

let g:lightline_buffer_maxflen = 30
let g:lightline_buffer_maxfextlen = 3
let g:lightline_buffer_minflen = 16
let g:lightline_buffer_minfextlen = 3
let g:lightline_buffer_reservelen = 20


" ================================================================================
" Language Specific Settings
" ================================================================================

" Python
" Run python script in Conque Shell
autocmd FileType python nnoremap <buffer> <leader>r :Do python3 %<CR>


