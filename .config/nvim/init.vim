" TODO: Sort everything in different files. init.vim now looks messy

set runtimepath+=~/.config/nvim/bundle/Vundle.vim
set runtimepath+=~/.fzf
let &packpath = &runtimepath

call vundle#begin('~/.config/nvim/plugins/')

" Plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-rsi'
Plugin 'vim-ctrlspace/vim-ctrlspace'
Plugin 'w0rp/ale'
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'rbgrouleff/bclose.vim'
Plugin 'francoiscabrol/ranger.vim'
Plugin 'simnalamburt/vim-mundo'
Plugin 'tommcdo/vim-exchange'
Plugin 'scrooloose/nerdcommenter'
Plugin 'pseewald/vim-anyfold'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'rhysd/clever-f.vim'
Plugin 'chrisbra/NrrwRgn'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-repeat'
Plugin 'vimwiki/vimwiki'
Plugin 'lyokha/vim-xkbswitch'
Plugin 'vim-airline/vim-airline'
Plugin 'gcavallanti/vim-noscrollbar'
Plugin 'fisadev/FixedTaskList.vim'
Plugin 'junegunn/vim-peekaboo'
Plugin 'airblade/vim-gitgutter'
Plugin 'yggdroot/indentline'
Plugin 'RRethy/vim-illuminate'
Plugin 'bogado/file-line'

" text objects
Plugin 'tpope/vim-surround'
Plugin 'kana/vim-textobj-user'
Plugin 'Julian/vim-textobj-variable-segment'
Plugin 'wellle/targets.vim'
Plugin 'junegunn/vim-after-object'
Plugin 'tpope/vim-speeddating' " proper date increment/decrement

" language support
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'rust-lang/rust.vim'
Plugin 'racer-rust/vim-racer'
Plugin 'tbastos/vim-lua'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'

" completions
Plugin 'ncm2/ncm2'
Plugin 'roxma/nvim-yarp'
Plugin 'ncm2/ncm2-pyclang'
Plugin 'ncm2/ncm2-racer'
Plugin 'Shougo/neco-vim' " ncm2-vim
Plugin 'ncm2/ncm2-vim'
Plugin 'ncm2/ncm2-tagprefix'
Plugin 'ncm2/ncm2-path'
Plugin 'ncm2/ncm2-github'
Plugin 'ncm2/ncm2-bufword'
Plugin 'ncm2/ncm2-ultisnips'

" snippets
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" colorschemes
Plugin 'ajmwagar/vim-deus'         " deus
Plugin 'morhetz/gruvbox'           " gruvbox
Plugin 'dylanaraps/wal.vim'        " TODO: Needs propper function to enable. Requires no termguicolors to work properly

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

syntax on


" ------------------ Key remaps ------------------

" Free keys
noremap ;       <Nop>
noremap ,       <Nop>
noremap <C-b>   <Nop>
noremap <C-e>   <Nop>
noremap <C-y>   <Nop>

" leader
noremap <Space> <Nop>
let mapleader = " "

" Scroll
let g:keyboard_scroll = 5
let g:mouse_scroll = 3

function! AlignOptimal()
  let l:view = winsaveview()
  let l:view['topline'] += winline() - winheight(0) / 4
  call winrestview(l:view)
endfunction

function! Scroll(lines, direction)
  if v:count && a:lines
    let l:lines = v:count * a:lines
  elseif a:lines
    " if count is not present, prevent cursor scroll off, unless it is already
    " on the edge of the screen
    if a:direction == "up"
      let l:to_edge = winheight(0) - winline()
    elseif a:direction == "down"
      let l:to_edge = winline() - 1
    endif
    let l:lines = (l:to_edge != 0 && l:to_edge < a:lines) ? l:to_edge : a:lines
  elseif v:count
    let l:lines = v:count
  else
    let l:lines = 1
  endif

  if a:direction == "up"
    execute "normal!" l:lines . "\<C-y>"
  elseif a:direction == "down"
    execute "normal!" l:lines . "\<C-e>"
  endif
endfunction

nnoremap zm zz
xnoremap zm zz
" NOTE: <Cmd> is neovim only feature. Vim requires hacks with 'gv' to get this to work in visual
" mode. Also <Cmd> has to be replaced with ':<C-u>'
nnoremap <silent> zz <Cmd>call AlignOptimal()<CR>
xnoremap <silent> zz <Cmd>call AlignOptimal()<CR>

nnoremap <silent> J <Cmd>call Scroll(g:keyboard_scroll, "down")<CR>
nnoremap <silent> K <Cmd>call Scroll(g:keyboard_scroll, "up")<CR>
xnoremap <silent> J <Cmd>call Scroll(g:keyboard_scroll, "down")<CR>
xnoremap <silent> K <Cmd>call Scroll(g:keyboard_scroll, "up")<CR>
nnoremap <silent> <ScrollWheelUp>   <Cmd>call Scroll(g:mouse_scroll, "up")<CR>
nnoremap <silent> <ScrollWheelDown> <Cmd>call Scroll(g:mouse_scroll, "down")<CR>
xnoremap <silent> <ScrollWheelUp>   <Cmd>call Scroll(g:mouse_scroll, "up")<CR>
xnoremap <silent> <ScrollWheelDown> <Cmd>call Scroll(g:mouse_scroll, "down")<CR>

" Window navigation and management
nnoremap <silent> <A-h> <C-W>h
nnoremap <silent> <A-j> <C-W>j
nnoremap <silent> <A-k> <C-W>k
nnoremap <silent> <A-l> <C-W>l
inoremap <silent> <A-h> <C-\><C-N><C-w>h
inoremap <silent> <A-j> <C-\><C-N><C-w>j
inoremap <silent> <A-k> <C-\><C-N><C-w>k
inoremap <silent> <A-l> <C-\><C-N><C-w>l
vnoremap <silent> <A-h> <C-\><C-N><C-w>h
vnoremap <silent> <A-j> <C-\><C-N><C-w>j
vnoremap <silent> <A-k> <C-\><C-N><C-w>k
vnoremap <silent> <A-l> <C-\><C-N><C-w>l
cnoremap <silent> <A-h> <C-\><C-N><C-w>h
cnoremap <silent> <A-j> <C-\><C-N><C-w>j
cnoremap <silent> <A-k> <C-\><C-N><C-w>k
cnoremap <silent> <A-l> <C-\><C-N><C-w>l
tnoremap <silent> <A-h> <C-\><C-N><C-w>h
tnoremap <silent> <A-j> <C-\><C-N><C-w>j
tnoremap <silent> <A-k> <C-\><C-N><C-w>k
tnoremap <silent> <A-l> <C-\><C-N><C-w>l
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
autocmd TermOpen * startinsert

nnoremap <silent> <C-w>r :resize <Bar> vertical resize<CR>
tnoremap <silent> <C-w>r <C-\><C-n>:resize<CR>a

xnoremap > >gv
xnoremap < <gv

" General
noremap j gj
noremap k gk
noremap <expr> H (&wrap == 1 ? "g^" : "^")
noremap <expr> L (&wrap == 1 ? "g$" : "$")
noremap <expr> I (&wrap == 1 ? "g^i" : "^i")
noremap <expr> A (&wrap == 1 ? "g$a" : "$a")
" Fall through to non-whitespace
noremap <silent> <leader>j /\%<C-r>=col(".")<CR>c[^ ]<CR>
noremap <silent> <leader>k ?\%<C-r>=col(".")<CR>c[^ ]<CR>
nnoremap Y y$
noremap <expr> n 'Nn'[v:searchforward]
noremap <expr> N 'nN'[v:searchforward]
noremap s b
noremap S B
noremap b *
noremap B #

" Insert mode navigation
inoremap <expr> <Esc>   (pumvisible() ? "\<C-e>" : "\<Esc>")
inoremap <expr> <Tab>   (pumvisible() ? "\<C-n>" : "\<Tab>")
inoremap <expr> <S-tab> (pumvisible() ? "\<C-p>" : "\<S-Tab>")
inoremap <expr> <CR>    (pumvisible() ? "\<c-y>" : "\<CR>")
" Remaps done by tpope/vim-rsi. See corresponding github page for details

" Terminal paste
tnoremap <expr> <A-r> '<C-\><C-n>"'.nr2char(getchar()).'pa'

" Open terminal
nnoremap <silent> <C-c> <Cmd>below 10split term://zsh<CR>

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
  setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab nowrap
endfunction
autocmd filetype vim call VimFtConfig()

function! ShFtConfig()
  setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
endfunction
autocmd filetype sh call ShFtConfig()

" Tabs management
nnoremap <silent> <Tab> gt
nnoremap <silent> <S-Tab> gT
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


" ------------------ Plugin configuration ------------------

" CtrlSpace
nnoremap <silent> <C-Space> :CtrlSpace<CR>
let g:CtrlSpaceUseMouseAndArrowsInTerm = 1
let g:CtrlSpaceLoadLastWorkspaceOnStart = 0
let g:CtrlSpaceGlobCommand = "rg --smart-case --hidden --follow --no-heading --files --glob '!.git/'"

" ALE
let g:ale_sign_error = "✗"
let g:ale_sign_warning = "⚠"
let g:ale_sign_info = "ℹ"
let g:ale_sign_style_error = "Ⓢ"
let g:ale_sign_style_warning = "⧌"
let g:ale_linters = {'cpp': ['clang', 'cppcheck']}
let g:ale_lua_luacheck_options = '--no-redefined --no-unused-args'
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

" fuzzy
let $FZF_DEFAULT_COMMAND = "rg --smart-case --hidden --follow --no-heading --files --glob '!.git/'"
command! -bang -nargs=* GrepFiles
\ call fzf#vim#grep('rg --smart-case --hidden --follow --no-heading --line-number --color always "" --glob "!.git/"'.shellescape(<q-args>), 0,
\   {'options': ['--reverse', '--preview-window', 'down:60%:hidden', '--preview', '/home/mikhail/.config/nvim/plugins/fzf.vim/bin/preview.sh {}', '--bind', '?:toggle-preview']},
\   <bang>0 )

nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <C-g> :GrepFiles<CR>
nnoremap <silent> <C-s> :BLines<CR>

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

" Ranger
let g:ranger_map_keys = 0
let g:ranger_replace_netrw = 1
nnoremap - :Ranger<CR>

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
autocmd BufEnter * AnyFoldActivate
set foldlevel=10

" vim-multiple-cursors
let g:multi_cursor_use_default_mapping=1

" clever-f
let g:clever_f_smart_case = 1
let g:clever_f_fix_key_direction = 1

" NrrwRgn
let g:nrrw_rgn_protect = 'n'
let g:nrrw_rgn_nomap_Nr = 1
let g:nrrw_rgn_nomap_nr = 1
xnoremap <silent> <leader>nr :NR!<CR>
xnoremap <silent> <leader>np :NRP<CR>
nnoremap <silent> <leader>nm :NRM<CR>

" Tagbar
let g:tagbar_zoomwidth = 0
let g:tagbar_sort = 0
nmap <silent> <C-l> :TagbarOpenAutoClose<CR>

" auto-pairs
let g:AutoPairsFlyMode = 1

" xkbswitch
let g:XkbSwitchEnabled = 1
let g:XkbSwitchNLayout = 'us'

" airline
let g:airline_inactive_collapse = 0
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
let g:airline#extensions#default#section_truncate_width = {
\   'b': 79,
\   'x': 60,
\   'y': 88,
\   'z': 45,
\   'warning': 80,
\   'error': 80,
\ }
let g:airline_section_x = airline#section#create(['tagbar'])
let g:airline_section_c = airline#section#create_right(['filetype', 'readonly', 'file'])
function! Noscrollbar(...)
  let w:airline_section_y = "▐%{noscrollbar#statusline(20,'▄','█',['▟'],['▙'])}▌"
endfunction
call airline#add_statusline_func('Noscrollbar')
function! Time(...)
  let w:airline_section_z = airline#section#create(['%{strftime("%l:%M%p")}'])
endfunction
call airline#add_statusline_func('Time')

" FixedTaskList
nnoremap <silent> <Leader>tl :TaskList<CR>

" vim-peekaboo
let g:peekaboo_delay = 500

" gitgutter
let g:gitgutter_sign_added              = '┃'
let g:gitgutter_sign_modified           = '┃'
let g:gitgutter_sign_removed            = '◢'
let g:gitgutter_sign_removed_first_line = '◥'
let g:gitgutter_sign_modified_removed   = '◢'

nnoremap <silent> <Leader>gh :GitGutterLineHighlightsToggle<CR>

" indentline
let g:indentLine_fileType = ['h', 'hh', 'hpp', 'c', 'cc', 'cpp', 'sh', 'vim', 'lua']
let g:indentLine_setColors = 0
let g:indentLine_char = '¦'

" vim-after-object
call after_object#enable(["a", "A"], '=', ':')

" vimwiki
let g:vimwiki_use_mouse = 1
let g:vimwiki_folding = 'list'
let g:vimwiki_dir_link = 'index'
let g:vimwiki_ext2syntax = {
\ '.md': 'markdown',
\ '.mkd': 'markdown',
\ '.wiki': 'vimwiki'}
let g:vimwiki_list = [
\ { 'path': '~/vimwiki/',
\   'syntax': 'markdown',
\   'ext': '.md' },
\ { 'path': '~/.wiki/',
\   'syntax': 'markdown',
\   'ext': '.md' }]
function! VimwikiFtConfig()
  setlocal tabstop=3 softtabstop=3 shiftwidth=3 expandtab wrap

  set syntax=pandoc

  nmap <buffer> <CR> <Plug>VimwikiFollowLink<Esc>zt
  nmap <buffer> <2-LeftMouse> <Plug>VimwikiFollowLink<Esc>zt
  nmap <buffer> <RightMouse> <BS>
  nmap <buffer> <MiddleMouse> <LeftMouse><C-Space>
  imap <expr> <Esc>   (pumvisible() ? "\<C-e>" : "\<Esc>")
  imap <expr> <Tab>   (pumvisible() ? "\<C-n>" : "\<Tab>")
  imap <expr> <S-tab> (pumvisible() ? "\<C-p>" : "\<S-Tab>")
  imap <expr> <CR>    (pumvisible() ? "\<c-y>" : "\<CR>")
endfunction
autocmd FileType vimwiki call VimwikiFtConfig()


" Languages
" cpp
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 0
let g:cpp_no_function_highlight = 1

" rust
let g:rustfmt_autosave = 1
let g:rust_conceal = 0
let g:rust_conceal_mod_path = 0
let g:rust_conceal_pub = 0
let g:racer_experimental_completer = 1
let g:rustfmt_fail_silently = 0

au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)

" lua
let g:lua_syntax_nofold = 1

" pandoc
let g:pandoc#syntax#conceal#use = 1
let g:pandoc#syntax#conceal#backslash = 1
let g:pandoc#syntax#conceal#urls = 1


" Completion
" ncm2
let g:ncm2#filter="same_word"
let g:ncm2#popup_limit=20
autocmd BufEnter * call ncm2#enable_for_buffer()

let g:ncm2_pyclang#library_path = '/usr/lib/llvm-6.0/lib'
let g:ncm2_pyclang#database_path = [
    \ 'compile_commands.json',
    \ 'build/compile_commands.json' ]
let g:ncm2_pyclang#args_file_path = ['.clang_complete']
autocmd FileType c,cpp nnoremap <buffer> gd :<c-u>call ncm2_pyclang#goto_declaration()<cr>

" Snippets
" UltiSnips
let g:UltiSnipsExpandTrigger="<C-e>"
let g:UltiSnipsJumpForwardTrigger="<C-n>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"
let g:UltiSnipsEditSplit="vertical"

" colorscheme
let g:gruvbox_bold=1
let g:gruvbox_italic=1
let g:gruvbox_invert_selection=0
let g:gruvbox_italicize_strings=1
colorscheme gruvbox
set background=dark
call gruvbox#hls_hide()
nnoremap <silent> <Leader>hs :call gruvbox#hls_toggle()<CR>
