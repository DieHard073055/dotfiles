filetype plugin on
filetype on
syntax on

"set nowrap
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

set undofile " Maintain undo history between sessions

" enabling pathogen
execute pathogen#infect()

let g:user_emmet_mode='a' " Enable all functions from emment

" check syntax on the fly
let g:syntastic_check_on_open = 1

" Setting the python version for syntastic
function Py2()
  let g:syntastic_python_python_exec = '/usr/local/bin/python2'
endfunction

function Py3()
  let g:syntastic_python_python_exec = '/usr/local/bin/python3'
endfunction

call Py3()   " default to Py3 because I try to use it when possible
