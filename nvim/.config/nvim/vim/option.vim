" set cursorline cursorcolumn
set cursorcolumn
" set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list
set listchars=eol:↴,tab:>
set clipboard+=unnamedplus
" set colorcolumn=80
set nowrap
set lazyredraw
set number
set splitbelow splitright
set termguicolors
set mouse=a
set completeopt=menu,menuone,noselect

set expandtab
set shiftwidth=2
set smartindent
set softtabstop=2
set tabstop=2

set cmdheight=1
" set laststatus=0

set ignorecase
set incsearch
" set nohlsearch
set smartcase

set nobackup
set noswapfile
set undodir=~/.cache/nvim/undo
set undofile

set path+=**
set wildmenu

filetype indent plugin on
" syntax enable