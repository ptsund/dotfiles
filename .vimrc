call plug#begin()
Plug 'preservim/NERDTree'
Plug 'romgrk/doom-one.vim'
call plug#end()

execute "set t_8f=\e[38;2;%lu;%lu;%lum"
execute "set t_8b=\e[48;2;%lu;%lu;%lum"

if has('termguicolors')
  set termguicolors
endif

colorscheme doom-one
filetype on
filetype plugin on
filetype indent on
syntax on

set nocompatible
set number
set cursorline
set shiftwidth=2
set tabstop=2
set expandtab
set nobackup
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set smartcase
set showcmd
set showmode
set showmatch
set hlsearch
set history=1000
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

nnoremap <F3> :set hlsearch!<CR>
