set runtimepath+=~/.config/nvim/bundle/Vundle.vim
set runtimepath+=~/.fzf
let &packpath = &runtimepath

call vundle#begin('~/.config/nvim/plugins/')

" Plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-ctrlspace/vim-ctrlspace'
Plugin 'Valloric/YouCompleteMe'
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
Plugin 'vim-airline/vim-airline'
Plugin 'gcavallanti/vim-noscrollbar'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'airblade/vim-gitgutter'
Plugin 'yggdroot/indentline'
Plugin 'bogado/file-line'

" colorschemes
Plugin 'ajmwagar/vim-deus'         " deus
Plugin 'morhetz/gruvbox'           " gruvbox
Plugin 'jnurmine/Zenburn'          " zenburn
Plugin 'fcpg/vim-farout'           " farout

call vundle#end()

filetype plugin indent on

" Enable external rc files
set exrc
set secure

set number

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

set incsearch
set autoread
set virtualedit=block
set hidden

set guicursor=
set termguicolors

set conceallevel=2
set concealcursor=n

set splitright
set nosplitbelow


" ------------------ Key remaps ------------------

" Free keys
map <S-l> <Nop>

" leader
map <S-h> <Nop>
let mapleader = "H"

" Scroll
noremap J <C-E>
noremap K <C-Y>

" Window navigation
nnoremap <A-h> <C-W>h
nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-l> <C-W>l
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

nnoremap <silent> <C-w>r :resize<CR>
tnoremap <silent> <C-w>r <C-\><C-n>:resize<CR>a

nnoremap <silent> <C-t> :below 10split +term<CR>a

" Next and previous maps (see unimpaired.vim)
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


" ------------------ Plugin setups ------------------

" CtrlSpace
nnoremap <silent> <Space> :CtrlSpace<CR>
let g:CtrlSpaceGlobCommand = 'ag -l --hidden --nocolor -g ""'

" YCM
let g:ycm_autoclose_preview_window_after_completion=1
"let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_key_list_stop_completion = ['<Enter>']
syntax on

" fuzzy
let $FZF_DEFAULT_COMMAND = 'find -L . ""'
command! -bang -nargs=* GrepFiles call fzf#vim#grep('grep -RnT --line-number --exclude-dir=.git/ --exclude=\\.tags '.shellescape(<q-args>), 0, <bang>0)
nnoremap <silent> <C-f> :Files<CR>
nnoremap <C-g> :GrepFiles<CR>

" NERD Tree
nnoremap <silent> <Leader>t :NERDTreeToggle<CR>

" Tags
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
set tags=./.tags;
let g:easytags_file = './.tags'
let g:easytags_dynamic_files = 1
let g:easytags_include_members = 1
let g:easytags_auto_highlight = 0
let g:easytags_resolve_links = 1
let g:easytags_async=1

" anyfold
let anyfold_activate=1
set foldlevel=10

" Tagbar
let g:tagbar_zoomwidth = 0
let g:tagbar_sort = 0
nmap <silent> <Leader><Space> :TagbarOpenAutoClose<CR>

" airline
let g:airline_powerline_fonts = 1
let g:airline_exclude_preview = 1
function! Noscrollbar(...)
  let w:airline_section_y = '%{noscrollbar#statusline(40, "-", "#")}'
endfunction
function! Time(...)
  let w:airline_section_z = '%{strftime("%l:%M%p")}'
endfunction
call airline#add_statusline_func('Noscrollbar')
call airline#add_statusline_func('Time')

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
