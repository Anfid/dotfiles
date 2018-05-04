set nocompatible

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.fzf
call vundle#begin('~/.vim/plugins/')

" Plugins here
Plugin 'gmarik/Vundle.vim'
Bundle 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'junegunn/fzf.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'xuyuanp/nerdtree-git-plugin'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'gregsexton/gitv'
Plugin 'wellle/targets.vim'
Plugin 'tommcdo/vim-exchange'
Plugin 'scrooloose/nerdcommenter'
Plugin 'pseewald/vim-anyfold'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'Raimondi/delimitMate'
Plugin 'vimwiki/vimwiki'
Plugin 'mhinz/vim-startify'
Plugin 'itchyny/lightline.vim'
Plugin 'gcavallanti/vim-noscrollbar'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'airblade/vim-gitgutter'
Plugin 'yggdroot/indentline'
Plugin 'artnez/vim-wipeout'
Plugin 'bogado/file-line'

" colorschemes
Plugin 'ajmwagar/vim-deus'         " deus
Plugin 'morhetz/gruvbox'
Plugin 'romainl/flattened'
Plugin 'isobit/vim-darcula-colors' " darcula
Plugin 'jnurmine/Zenburn'          " zenburn
Plugin 'fcpg/vim-farout'           " farout

call vundle#end()
filetype plugin indent on

set exrc
set secure

if !has('nvim')
    if !has('gui_running')
        set t_Co=256
    endif
endif

set number

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
nnoremap <A-h> <C-W>h
nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-l> <C-W>l

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
" fuzzy
let $FZF_DEFAULT_COMMAND = 'find . ""'
command! -bang -nargs=* GrepFiles call fzf#vim#grep('grep -rnT --line-number --exclude-dir=.git/ --exclude=\\.tags '.shellescape(<q-args>), 0, <bang>0)
nnoremap <silent> <C-f> :GFiles<CR>
nnoremap <C-g> :GrepFiles<CR>
" NERD Tree toggle
nnoremap <silent> <C-T> :NERDTreeToggle<CR>
" Jump to definition, return
nnoremap <C-j> g<C-]>
nnoremap <silent> <C-k> :pop<CR>
" fugitive
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
" return on Backspace
autocmd User fugitive
 \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
 \   nnoremap <buffer> <BS> :edit %:h<CR> |
 \ endif
" easytags
set tags=./tags;
let g:easytags_dynamic_files = 1
let g:easytags_include_members = 1
" anyfold
let anyfold_activate=1
set foldlevel=10
" Tagbar
let g:tagbar_zoomwidth = 0
let g:tagbar_sort = 0
nmap <silent> <Space> :TagbarOpenAutoClose<CR>
" startify
let g:startify_change_to_dir = 0
nmap <Leader>ss :SSave 
nmap <Leader>sl :SLoad<CR>
nmap <Leader>sd :SDelete 
" lightline
set laststatus=2
set noshowmode
let g:lightline = {
\   'colorscheme': 'gruvbox',
\   'active': {
\     'right': [ [ 'time' ],
\                [ 'lineinfo' ],
\                [ 'noscrollbar' ],
\                [ 'filetype'] ]
\   },
\   'component_function': {
\     'time': 'Time',
\     'noscrollbar': 'Noscrollbar'
\   }
\ }
function! Time()
  return strftime('%l:%M%p')
endfunction
function! Noscrollbar()
  return noscrollbar#statusline(40, '-', '#')
endfunction
" cpp-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
" gitgutter
nnoremap <Leader>gh :GitGutterLineHighlightsToggle<CR>
" indentline
let g:indentLine_fileType = ['h', 'hh', 'hpp', 'c', 'cc', 'cpp']
let g:indentLine_setColors=0
let g:indentLine_char='¦'

" colorscheme
colorscheme gruvbox
set background=dark
call gruvbox#hls_hide()
nnoremap <silent> <Leader>hs :call gruvbox#hls_toggle()<CR>
