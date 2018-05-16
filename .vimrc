filetype plugin on
filetype on
syntax on

set nowrap
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusGained,InsertEnter * set norelativenumber
augroup END

set ruler


