" TODO: Sort everything in different files. init.vim now looks messy

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
Plugin 'simnalamburt/vim-mundo'
Plugin 'wellle/targets.vim'
Plugin 'tommcdo/vim-exchange'
Plugin 'scrooloose/nerdcommenter'
Plugin 'pseewald/vim-anyfold'
Plugin 'chrisbra/NrrwRgn'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'Raimondi/delimitMate'
Plugin 'vimwiki/vimwiki'
Plugin 'vim-airline/vim-airline'
Plugin 'gcavallanti/vim-noscrollbar'
Plugin 'fisadev/FixedTaskList.vim'
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


" ------------------ Settings ------------------
filetype plugin indent on

" Enable external rc files
set exrc
set secure

set notimeout
set ttimeout

set mouse=a

set number
set noshowmode

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab nowrap

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

syntax on

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=2


" ------------------ Key remaps ------------------

" Free keys
map <S-l> <Nop>
map <S-h> <Nop>
map <Space> <Nop>

" leader
let mapleader = "\<C-h>"

" Scroll
noremap J <C-E>
noremap K <C-Y>
map <ScrollWheelUp> 2<C-Y>
map <ScrollWheelDown> 2<C-E>

" Window navigation and management
nnoremap <A-h> <C-W>h
nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-l> <C-W>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l

nnoremap <silent> <C-w>r :resize <Bar> vertical resize<CR>
tnoremap <silent> <C-w>r <C-\><C-n>:resize<CR>a

vnoremap > >gv
vnoremap < <gv

" Normal mode navigation
nnoremap H ^
nnoremap L $

" Insert mode navigation
inoremap <C-n> <Esc>o
inoremap <C-p> <Esc>O
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-d> <Del>
inoremap <C-b> <Backspace>

" Command mode navigation
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-d> <Del>
cnoremap <C-b> <Backspace>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Terminal paste
tnoremap <expr> <A-r> '<C-\><C-n>"'.nr2char(getchar()).'pa'

nnoremap Y y$

" Open terminal
nnoremap <silent> <C-c> :below 10split term://zsh<CR>a

" Remove item from qf list
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction
:command! RemoveQFItem :call RemoveQFItem()
" Map function to dd in qf list buffer
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>

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
call s:MapNextFamily('t','tab')

function! VimFtConfig()
  set tabstop=2 softtabstop=2 shiftwidth=2 expandtab nowrap
endfunction
autocmd filetype vim call VimFtConfig()

" Tabs management
nnoremap <C-t>e :tabedit<Space>
nnoremap <silent> <C-t>n :tabnew<CR>
nnoremap <silent> <C-t>c :tabclose<CR>
nnoremap <silent> <C-t>o :tabonly<CR>
nnoremap <silent> <C-t>[ :tabprevious<CR>
nnoremap <silent> <C-t>] :tabnext<CR>
nnoremap <silent> <C-t>{ :tabfirst<CR>
nnoremap <silent> <C-t>} :tablast<CR>

nnoremap <silent> <Leader>ic :tabedit ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>ir :source ~/.config/nvim/init.vim<CR>

nnoremap <silent> <Tab> :set relativenumber!<CR>


" ------------------ Plugin setups ------------------

" CtrlSpace
nnoremap <silent> <Space> :CtrlSpace<CR>
let g:CtrlSpaceUseMouseAndArrowsInTerm = 1
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceGlobCommand = "rg --smart-case --hidden --follow --no-heading --files"

" ALE
let g:ale_linters = {'cpp': ['clang', 'cppcheck']}
let g:ale_sign_error = "✗"
let g:ale_sign_warning = "⚠"
let g:ale_sign_info = "ℹ"
let g:ale_sign_style_error = "Ⓢ"
let g:ale_sign_style_warning = "⧌"

" nvim-completion-manager
let g:cm_matcher = {'module': 'cm_matchers.abbrev_matcher', 'case': 'smartcase'}
let g:racer_experimental_completer = 1
inoremap <expr> <Tab> pumvisible()? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-tab> pumvisible()? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> (pumvisible() ? "\<c-y>" : "\<CR>")

" fuzzy
let $FZF_DEFAULT_COMMAND = "rg --smart-case --hidden --follow --no-heading --files"
command! -bang -nargs=* GrepFiles call fzf#vim#grep('rg --smart-case --hidden --follow --no-heading --line-number ""'.shellescape(<q-args>), 0, <bang>0)
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <C-g> :GrepFiles<CR>
" NOTE: the following mapping is a veird workaround of vim interpreting <C-/>
" as <C-_> and vice versa. So, the actual mapping is to <C-/>
" TODO: check on win
nnoremap <silent> <C-_> :BLines<CR>

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
nnoremap <silent> <Leader>u :MundoToggle<CR>
let g:mundo_width=25
let g:mundo_preview_bottom=1
let g:mundo_preview_height=10
let g:mundo_help=0
let g:mundo_close_on_revert=1

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

" NrrwRgn
let g:nrrw_rgn_protect = 'n'
let g:nrrw_rgn_nomap_Nr = 1
let g:nrrw_rgn_nomap_nr = 1
xnoremap <silent> <leader>nr :NR!<CR>
xnoremap <silent> <leader>np :NRP<CR>
xnoremap <silent> <leader>nm :NRM!<CR>

" Tagbar
let g:tagbar_zoomwidth = 0
let g:tagbar_sort = 0
nmap <silent> <C-l> :TagbarOpenAutoClose<CR>

" delimitMate
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1
let delimitMate_balance_matchpairs = 1
let delimitMate_excluded_regions = "String"

" airline
let g:airline_powerline_fonts = 1
let g:airline_exclude_preview = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tabs_label = 'Tabs'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_nr = 0 " Disable tab numbers
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#branch#sha1_len = 8
let g:airline#extensions#nrrwrgn#enabled = 1
let g:airline#extensions#ctrlspace#enabled = 1
let g:CtrlSpaceStatuslineFunction = "airline#extensions#ctrlspace#statusline()"
" sections X and C are swapped as C gets highlighted on file modification
let g:airline#extensions#default#layout = [
\   [ 'a', 'b', 'x' ],
\   [ 'c', 'warning', 'error', 'y', 'z' ]
\ ]
let g:airline_section_x = airline#section#create(['tagbar'])
let g:airline_section_c = airline#section#create_right(['filetype', 'readonly', 'file'])
function! Noscrollbar(...)
let w:airline_section_y = "▐%{noscrollbar#statusline(20,'▄','█',['▟'],['▙'])}▌"
endfunction
call airline#add_statusline_func('Noscrollbar')
function! Time(...)
  let w:airline_section_z = airline#section#create(['xkblayout', '%{strftime("%l:%M%p")}'])
endfunction
call airline#add_statusline_func('Time')

" FixedTaskList
nnoremap <silent> <Leader>tl :TaskList<CR>

" cpp-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1

" gitgutter
nnoremap <silent> <Leader>gh :GitGutterLineHighlightsToggle<CR>

" indentline
let g:indentLine_fileType = ['h', 'hh', 'hpp', 'c', 'cc', 'cpp']
let g:indentLine_setColors=0
let g:indentLine_char='¦'

" vimwiki
let g:vimwiki_folding = 'list'
function! VimwikiFtConfig()
  setlocal tabstop=3 softtabstop=3 shiftwidth=3 expandtab wrap
  nmap <buffer> <CR> <Plug>VimwikiFollowLink<Esc>zt
  nmap <buffer> <2-LeftMouse> <Plug>VimwikiFollowLink<Esc>zt
  nmap <buffer> <RightMouse> <BS>
  nmap <buffer> <MiddleMouse> <LeftMouse><C-Space>
endfunction
autocmd FileType vimwiki call VimwikiFtConfig()

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
"      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
"      or put next line in CMakeLists.txt
"      set(CMAKE_EXPORT_COMPILE_COMMANDS ON) )
