set runtimepath+=~/.fzf
let &packpath = &runtimepath

let config_path = expand('~/.config/nvim')

exec 'source '.config_path.'/plugins.vim'

"------------------ Settings ------------------
filetype plugin indent on

" Enable external rc files
set exrc
set secure

set notimeout
set ttimeout

set mouse=a

set number
set cursorline

set noshowmode

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set nowrap linebreak

set list listchars=tab:→\ ,trail:·,nbsp:␣,extends:⟩,precedes:⟨

set inccommand=split
set incsearch
set ignorecase
set smartcase

set autoread
set virtualedit=block
set hidden

set wildmenu
set wildmode=longest,list:full

set termguicolors

set conceallevel=2
set concealcursor=n

set splitright
set nosplitbelow

set completeopt=noinsert,menuone,noselect
set shortmess+=c

set diffopt+=vertical
set tags=./.tags;
set foldlevel=99

syntax on


" ------------------ Key remaps ------------------
exec 'source '.config_path.'/bindings.vim'


" ------------------ Autocommands ------------------
exec 'source '.config_path.'/autocmd.vim'


" ------------------ Other ------------------
function! ShowCommitsAndExit()
  AirlineToggle
  tnoremap <Esc> <C-\><C-n>:bd!<Bar>qa!<CR>
  tnoremap <C-c> <C-\><C-n>:bd!<Bar>qa!<CR>
  nnoremap <Esc> :qa!<CR>
  nnoremap <C-c> :qa!<CR>
  Commits!
  tabonly
endfunction
command! ShowCommitsAndExit call ShowCommitsAndExit()


" ------------------ Colorscheme ------------------
set background=dark
colorscheme gruvbox
call gruvbox#hls_hide()
