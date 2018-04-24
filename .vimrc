set nocompatible

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins/')

" Plugins here
Plugin 'gmarik/Vundle.vim'
Bundle 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'xuyuanp/nerdtree-git-plugin'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdcommenter'
Plugin 'pseewald/vim-anyfold'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'Raimondi/delimitMate'
Plugin 'vimwiki/vimwiki'
Plugin 'itchyny/lightline.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'yggdroot/indentline'
" colorschemes
Plugin 'ajmwagar/vim-deus'         " deus
Plugin 'isobit/vim-darcula-colors' " darcula
Plugin 'jnurmine/Zenburn'          " zenburn
Plugin 'fcpg/vim-farout'           " farout

call vundle#end()
filetype plugin indent on

if !has('gui_running')
    set t_Co=256
endif

set number
colorscheme deus

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

set incsearch
set autoread
set virtualedit=block

" Unbind keys
"leader
map <S-h> <Nop>
"free
map <S-l> <Nop>

let mapleader = "H"

" Scroll
noremap J <C-E>
noremap K <C-Y>

" Cross-tab navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Next and previous maps
function! s:map(mode, lhs, rhs, ...) abort
  let flags = (a:0 ? a:1 : '') . (a:rhs =~# '^<Plug>' ? '' : '<script>')
  let head = a:lhs
  let tail = ''
  let keys = get(g:, a:mode.'remap', {})
  if type(keys) != type({})
    return
  endif
  while !empty(head)
    if has_key(keys, head)
      let head = keys[head]
      if empty(head)
        return
      endif
      break
    endif
    let tail = matchstr(head, '<[^<>]*>$\|.$') . tail
    let head = substitute(head, '<[^<>]*>$\|.$', '', '')
  endwhile
  exe a:mode.'map' flags head.tail a:rhs
endfunction

function! s:MapNextFamily(map,cmd) abort
  let map = '<Plug>unimpaired'.toupper(a:map)
  let cmd = '".(v:count ? v:count : "")."'.a:cmd
  let end = '"<CR>'.(a:cmd == 'l' || a:cmd == 'c' ? 'zv' : '')
  execute 'nnoremap <silent> '.map.'Previous :<C-U>exe "'.cmd.'previous'.end
  execute 'nnoremap <silent> '.map.'Next     :<C-U>exe "'.cmd.'next'.end
  execute 'nnoremap <silent> '.map.'First    :<C-U>exe "'.cmd.'first'.end
  execute 'nnoremap <silent> '.map.'Last     :<C-U>exe "'.cmd.'last'.end
  call s:map('n', '['.        a:map , map.'Previous')
  call s:map('n', ']'.        a:map , map.'Next')
  call s:map('n', '['.toupper(a:map), map.'First')
  call s:map('n', ']'.toupper(a:map), map.'Last')
  if exists(':'.a:cmd.'nfile')
    execute 'nnoremap <silent> '.map.'PFile :<C-U>exe "'.cmd.'pfile'.end
    execute 'nnoremap <silent> '.map.'NFile :<C-U>exe "'.cmd.'nfile'.end
    call s:map('n', '[<C-'.toupper(a:map).'>', map.'PFile')
    call s:map('n', ']<C-'.toupper(a:map).'>', map.'NFile')
  endif
endfunction

call s:MapNextFamily('a','')
call s:MapNextFamily('b','b')
call s:MapNextFamily('l','l')
call s:MapNextFamily('q','c')
call s:MapNextFamily('t','t')

" Parenthesize
nnoremap \p bi(<Esc>Ea)<Esc>
nnoremap \a bi<<Esc>Ea><Esc>

nnoremap <silent> <Tab> :set relativenumber!<Enter>

" Plugin setups
let g:ycm_log_level = 'error'
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_key_list_stop_completion = ['<Enter>']
syntax on
map <silent> <C-T> :NERDTreeToggle<CR>
" Jump to definition, return
nnoremap <C-G> g<C-]>
nnoremap <silent> <C-B> :pop<CR>
" fugitive
" return on Backspace
autocmd User fugitive
 \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
 \   nnoremap <buffer> <BS> :edit %:h<CR> |
 \ endif
" easytags
"set tags=./tags;
"TODO: this is SO MUCH temp solution, fix asap
set tags=./.tags;,../../SoftTNA-master/src/.tags
let g:easytags_auto_update = 0
let g:easytags_dynamic_files = 1
let g:easytags_include_members = 1
let g:easytags_auto_highlight = 0
" anyfold
let anyfold_activate=1
set foldlevel=10
" Tagbar
let g:tagbar_zoomwidth = 0
let g:tagbar_sort = 0
nmap <silent> <Space> :TagbarOpenAutoClose<CR>
" lightline
set laststatus=2
set noshowmode
let g:lightline = {
\   'colorscheme': 'deus',
\   'active': {
\     'right': [ [ 'time' ],
\                [ 'lineinfo' ],
\                [ 'percent' ],
\                [ 'fileencoding', 'filetype' ] ]
\   },
\   'component_function': {
\     'time': 'Time'
\   }
\ }
function! Time()
  return strftime('%l:%M%p')
endfunction
" cpp-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
" indentline
let g:indentLine_fileType = ['h', 'hh', 'hpp', 'c', 'cc', 'cpp']
let g:indentLine_setColors=0
let g:indentLine_char='¦'
