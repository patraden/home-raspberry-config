" enable syntax highlighting
 syntax enable
" show line numbers
 set number
" set tabs to have 4 spaces
 set ts=4
 set tabstop=4
" indent when moving to the next line while writing code
 set autoindent
" expand tabs into spaces
 set expandtab
" when using the >> or << commands, shift lines by 4 spaces
 set shiftwidth=4
" show a visual line under the cursor's current line
 set cursorline
" show the matching part of the pair for [] {} and ()
 set showmatch
" enable all Python syntax highlighting features
 let python_highlight_all = 1
" set expandtab
 filetype indent on
" hide mouse when typing
 set mousehide
" no .swp and ~, default encoding
 set nobackup
 set noswapfile
 set encoding=utf-8
" enable 256 coulour
 set t_Co=256

" install vim plugin script: https://github.com/junegunn/vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" color theme: https://github.com/junegunn/seoul256.vim
" :PlugInstall in vim to install plugins

call plug#begin()
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'
call plug#end()

" let g:seoul256_background = 233
" colo seoul256
 set bg=dark
 let g:gruvbox_termcolors='200'
 let g:gruvbox_contrast_dark='hard'
 let g:gruvbox_transparent_bg='0'
 colorscheme gruvbox
