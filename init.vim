ino jk <esc>
let maplocalleader = '\\'
let mapleader = ','
nn <leader>w :w<cr>
nn <leader>wq :wq<cr>
nn <leader>q :q<cr>
nn <leader>qq :q!<cr>
nn H ^
nn L $

set sw=4 ts=4 sts=4 expandtab
"
" -----------------------------
" Install and configure plugins
" -----------------------------
call plug#begin('~/.config/nvim/plugged')

" Emmet
Plug 'mattn/emmet-vim' " Complete with <C-y>,
" Auto close tags
Plug 'alvan/vim-closetag'

Plug 'endel/vim-github-colorscheme'
call plug#end()

colo github
