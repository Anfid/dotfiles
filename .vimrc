set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins/')

" Plugins here
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-scripts/indentpython.vim'
Bundle 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'jnurmine/Zenburn'
Plugin 'scrooloose/nerdtree'

call vundle#end()
filetype plugin indent on

set ruler
set showcmd
set number
noremap J <C-E>
noremap K <C-Y>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
map \p i(<Esc>Ea)<Esc>
map \v i{{<Esc>Ea}}<Esc>
map \c i{% <Esc>Ea %}<Esc>
map <Tab> :set relativenumber!<Enter>

" Plugin setups
let g:ycm_autoclose_preview_window_after_completion=1
map <C-Q> :YcmCompleter GoToDefinitionElseDeclaration<CR>
let python_highlight_all=1
syntax on
map <C-T> :NERDTreeToggle<CR>
