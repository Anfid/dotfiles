set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins/')

" Plugins here
Plugin 'gmarik/Vundle.vim'
Bundle 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'xuyuanp/nerdtree-git-plugin'
Plugin 'scrooloose/nerdcommenter'
Plugin 'pseewald/vim-anyfold'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'townk/vim-autoclose'
Plugin 'vimwiki/vimwiki'
Plugin 'jnurmine/Zenburn'
Plugin 'itchyny/lightline.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'yggdroot/indentline'

call vundle#end()
filetype plugin indent on

if !has('gui_running')
    set t_Co=256
endif

set number

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" Scroll
noremap J <C-E>
noremap K <C-Y>
" Cross-tab navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Parenthesize
nnoremap \p bi(<Esc>Ea)<Esc>
nnoremap \a bi<<Esc>Ea><Esc>

nnoremap <silent> <Tab> :set relativenumber!<Enter>


" Plugin setups
filetype plugin indent on
let g:ycm_log_level = 'error'
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_key_list_stop_completion = ['<Enter>']
syntax on
map <silent> <C-T> :NERDTreeToggle<CR>
" Jump to definition, return
nnoremap <C-G> g<C-]>
nnoremap <silent> <C-B> :pop<CR>
" easytags
highlight cTypeTag ctermfg=DarkCyan
"highlight cFunctionTag ctermfg=Blue
highlight cMemberTag ctermfg=DarkMagenta
highlight cEnumTag ctermfg=DarkCyan
highlight cPreProcTag ctermfg=Yellow
" anyfold
let anyfold_activate=1
set foldlevel=10
" Tagbar on space
nmap <silent> <Space> :TagbarOpenAutoClose<CR>
" lightline
set laststatus=2
set noshowmode
" indentline
let g:indentLine_setColors=0
let g:indentLine_char='¦'
