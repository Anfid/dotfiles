set runtimepath+=~/.config/nvim/bundle/Vundle.vim
set runtimepath+=~/.fzf
let &packpath = &runtimepath

call vundle#begin('~/.config/nvim/plugins/')

" Plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-ctrlspace/vim-ctrlspace'
Plugin 'w0rp/ale'
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'sjl/gundo.vim'
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

Plugin 'roxma/nvim-completion-manager'
Plugin 'rust-lang/rust.vim'
Plugin 'racer-rust/vim-racer'
Plugin 'roxma/nvim-cm-racer'
Plugin 'roxma/ncm-clang'

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

set mouse=a

set number
set noshowmode

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab nowrap

set incsearch
set autoread
set virtualedit=block
set hidden

set wildmenu
set wildmode=list:longest,full

set guicursor=
set termguicolors

set conceallevel=2
set concealcursor=n

set splitright
set nosplitbelow

syntax on


" ------------------ Key remaps ------------------

" Free keys
map <S-l> <Nop>
map <S-h> <Nop>

" leader
let mapleader = "H"

" Scroll
noremap J <C-E>
noremap K <C-Y>
map <ScrollWheelUp> 2<C-Y>
map <ScrollWheelDown> 2<C-E>

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

nnoremap <A-i> Bi
nnoremap <A-a> Ea

nnoremap <silent> <C-w>r :resize <Bar> vertical resize<CR>
tnoremap <silent> <C-w>r <C-\><C-n>:resize<CR>a

nnoremap <silent> <C-t> :below 10split term://zsh<CR>a

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
let g:CtrlSpaceUseMouseAndArrowsInTerm = 1
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceGlobCommand = 'ag -l -f --hidden --nocolor -g ""'

" ALE
let g:ale_linters = {'cpp': ['clang', 'cppcheck']}
let g:ale_sign_error = "✗"
let g:ale_sign_warning = "⚠"
let g:ale_sign_info = "ℹ"
let g:ale_sign_style_error = "✗"
let g:ale_sign_style_warning = "⚠"

" nvim-completion-manager
let g:racer_experimental_completer = 1
inoremap <expr> <Tab> pumvisible()? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-tab> pumvisible()? "\<C-p>" : "\<S-Tab>"

" fuzzy
"'rg -L --hidden -n -p -S -e ""'
"''
let $FZF_DEFAULT_COMMAND = 'find -L . ""'
command! -bang -nargs=* GrepFiles call fzf#vim#grep('grep -RnT --color=always --line-number --exclude-dir=.git/ --exclude=\\.tags '.shellescape(<q-args>), 0, <bang>0)
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <C-g> :GrepFiles<CR>

let g:fzf_buffers_jump = 1
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0
  \| autocmd BufLeave <buffer> set laststatus=2


" Tags
nnoremap <C-j> g<C-]>
nnoremap <2-LeftMouse> g<C-]>
nnoremap <silent> <C-k> :pop<CR>

" git
set diffopt+=vertical
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gc :Commits<CR>
nnoremap <silent> <Leader>gf :BCommits<CR>
" return on Backspace
autocmd User fugitive
 \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
 \   nnoremap <buffer> <BS> :edit %:h<CR> |
 \ endif

" Gundo
nnoremap <silent> <Leader>u :GundoToggle<CR>
let g:gundo_width=25
let g:gundo_preview_bottom=1
let g:gundo_preview_height=10
let g:gundo_help=0
let g:gundo_close_on_revert=1

" easytags
set tags=./.tags;
let g:easytags_file = './.tags'
let g:easytags_dynamic_files = 1
let g:easytags_include_members = 1
let g:easytags_auto_highlight = 0
let g:easytags_resolve_links = 1
let g:easytags_async=1

" anyfold
let g:anyfold_activate=1
set foldlevel=10

" Tagbar
let g:tagbar_zoomwidth = 0
let g:tagbar_sort = 0
nmap <silent> <Leader><Space> :TagbarOpenAutoClose<CR>

" delimitMate
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1
let delimitMate_balance_matchpairs = 1
let delimitMate_excluded_regions = "String"

" airline
let g:airline_powerline_fonts = 1
let g:airline_exclude_preview = 1
function! Noscrollbar(...)
  let w:airline_section_y = "%{noscrollbar#statusline(20,' ','█',['▐'],['▌'])}"
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

" vimwiki
autocmd FileType vimwiki setlocal tabstop=3 softtabstop=3 shiftwidth=3 expandtab wrap
autocmd FileType vimwiki nmap <buffer> <2-LeftMouse> <CR>
autocmd FileType vimwiki nmap <buffer> <RightMouse> <BS>
autocmd FileType vimwiki nmap <buffer> <MiddleMouse> <LeftMouse><C-Space>
autocmd FileType vimwiki let b:delimitMate_quotes = "\" ' ` ="
autocmd FileType vimwiki let b:delimitMate_nesting_quotes = ['=']

" colorscheme
colorscheme gruvbox
set background=dark
call gruvbox#hls_hide()
nnoremap <silent> <Leader>hs :call gruvbox#hls_toggle()<CR>

" ------------------ Project-specific reminder ------------------
" ------------- cpp -------------
" Following options may need to be changed from default on some projects.
" Add them to project's root directory
"
" Set include path with -I flag. Eg:
"let g:ale_cpp_clang_options = '-std=c++14 -Wall -I /home/anfid/Documents/dotfiles/'
" Assigning value with += seems to break something.
"
" Prooved useful setting abs path to tags instead of relative
"set tags=/abs/path/to/.tags
"
" Set proper ALE linters. Defaults:
"let g:ale_linters = {'cpp': ['clang', 'cppcheck']} (See help for options)
"
" Cppcheck setup:
"let g:ale_cpp_cppcheck_options = '<>'
"    -j2 (use 2 jobs, balance performance and resources)
"    --enable='<>,<>' (enable following messages)
"        error (on by default)
"        performance,portability,warning,style (self explanatory)
"        unusedFunction (do not use in libraries)
"    --inconclusive (More warnings. May result in false warnings)
"    --project=<compile_commands.json | *.vsxproj | *.sln>
"    ( Use the following flag with cmake to generate compile_commands.json
"      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON )
