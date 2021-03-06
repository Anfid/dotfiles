" autoinstall vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.config/nvim/plugins/')

Plug 'junegunn/vim-plug'
Plug 'tpope/vim-rsi'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'w0rp/ale', { 'for': ['c', 'cpp', 'haskell', 'lua', 'vim'] }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'tommcdo/vim-exchange'
Plug 'scrooloose/nerdcommenter'
Plug 'pseewald/vim-anyfold'
Plug 'rhysd/clever-f.vim'
Plug 'junegunn/vim-easy-align'
Plug 'ludovicchabant/vim-gutentags', { 'for': ['c', 'cpp', 'haskell', 'lua', 'sh'] }
Plug 'majutsushi/tagbar'
Plug 'liuchengxu/vista.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-repeat'
Plug 'vim-airline/vim-airline'
Plug 'gcavallanti/vim-noscrollbar'
Plug 'airblade/vim-gitgutter'
Plug 'yggdroot/indentline'
Plug 'RRethy/vim-illuminate'
Plug 'bogado/file-line'
Plug 'kassio/neoterm'

" text objects
Plug 'tpope/vim-surround'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'coderifous/textobj-word-column.vim'
Plug 'wellle/targets.vim'
Plug 'junegunn/vim-after-object'
Plug 'terryma/vim-expand-region'

" language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rust-lang/rust.vim'
Plug 'tikhomirov/vim-glsl'
Plug 'cespare/vim-toml'
Plug 'idbrii/vim-tagimposter'
Plug 'neovimhaskell/haskell-vim'
Plug 'tbastos/vim-lua'
Plug 'derekwyatt/vim-scala'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" completions
"Plug 'ncm2/ncm2'
"Plug 'roxma/nvim-yarp'
"Plug 'ncm2/ncm2-pyclang'
"Plug 'ncm2/ncm2-racer'
"Plug 'Shougo/neco-vim' " ncm2-vim
"Plug 'ncm2/ncm2-vim'
"Plug 'ncm2/ncm2-tagprefix'
"Plug 'ncm2/ncm2-path'
"Plug 'ncm2/ncm2-github'
"Plug 'ncm2/ncm2-bufword'
"Plug 'ncm2/ncm2-ultisnips'
"Plug 'artur-shaik/vim-javacomplete2' " ncm2-jc2
"Plug 'ObserverOfTime/ncm2-jc2'

" snippets
Plug 'SirVer/ultisnips', { 'on': [] }
Plug 'honza/vim-snippets'

" colorschemes
Plug 'luochen1990/rainbow'
Plug 'dkasak/gruvbox'          " gruvbox

call plug#end()

augroup plug_on_insert
  autocmd InsertEnter * call plug#load('ultisnips')
augroup END


" ------------------ Settings ------------------
" CtrlSpace
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
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1

" fuzzy
let $FZF_DEFAULT_COMMAND = "rg --smart-case --hidden --follow --no-heading --files --glob '!.git/'"
command! -bang -nargs=* GrepFiles
\ call fzf#vim#grep('rg --smart-case --hidden --follow --no-heading --line-number --color always "" --glob "!.git/"'.shellescape(<q-args>), 0,
\   {'options': ['--reverse', '--preview-window', 'down:60%:hidden', '--preview', '/home/mikhail/.config/nvim/plugins/fzf.vim/bin/preview.sh {}', '--bind', '?:toggle-preview']},
\   <bang>0 )

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


" Ranger
let g:ranger_map_keys = 0
let g:ranger_replace_netrw = 1
" disable netrw loading
let g:loaded_netrwPlugin = 1

" gutentags
"let g:gutentags_ctags_tagfile = './.tags'
"let g:gutentags_ctags_executable_rust = 'rusty-tags vi'
let g:gutentags_cache_dir = '~/.cache/ctags'
let g:gutentags_ctags_auto_set_tags = 0
let g:gutentags_generate_on_empty_buffer = 1
let g:gutentags_resolve_symlinks = 1

" anyfold
autocmd BufEnter * AnyFoldActivate

" clever-f
let g:clever_f_smart_case = 0
let g:clever_f_fix_key_direction = 1

" Tagbar
let g:tagbar_zoomwidth = 0
let g:tagbar_sort = 0

" Vista
let g:vista_icon_indent = ["▸ ", ""]
let g:vista_default_executive = 'ctags'
let g:vista_executive_for = {
  \ 'rust': 'coc',
  \ 'lua': 'coc',
  \ }
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista_close_on_jump = 1

" auto-pairs
let g:AutoPairsFlyMode = 0

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
let g:airline#extensions#ctrlspace#enabled = 1
let g:airline#extensions#coc#enabled = 1
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

function! AirlineInit()
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
  endfunction

  let g:airline_timer = timer_start(30, airline#update_statusline(), {'repeat': -1})
autocmd User AirlineAfterInit call AirlineInit()

" gitgutter
let g:gitgutter_enabled = 0
let g:gitgutter_max_signs               = 1500
let g:gitgutter_sign_added              = '┃'
let g:gitgutter_sign_modified           = '┃'
let g:gitgutter_sign_removed            = '◢'
let g:gitgutter_sign_removed_first_line = '◥'
let g:gitgutter_sign_modified_removed   = '◢'

" indentline
let g:indentLine_fileType = ['h', 'hh', 'hpp', 'c', 'cc', 'cpp', 'sh', 'vim', 'lua']
let g:indentLine_setColors = 0
let g:indentLine_char = '¦'

" neoterm
let g:neoterm_size = 10
let g:neoterm_default_mod = "below"
let g:neoterm_autoinsert = 1
let g:neoterm_fixedsize = 1
let g:neoterm_term_per_tab = 1


" Coc
let g:coc_global_extensions = ['coc-snippets', 'coc-git', 'coc-rust-analyzer', 'coc-lua', 'coc-json', 'coc-marketplace']


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
let g:racer_experimental_completer = 0
let g:rustfmt_fail_silently = 0

" lua
let g:lua_syntax_nofold = 1

" pandoc
let g:pandoc#syntax#conceal#use = 1
let g:pandoc#syntax#conceal#backslash = 1
let g:pandoc#syntax#conceal#urls = 1


" Completion
" ncm2
"let g:ncm2#filter="same_word"
"let g:ncm2#popup_limit=20
"autocmd BufEnter * call ncm2#enable_for_buffer()

"let g:ncm2_pyclang#library_path = '/usr/lib/llvm-6.0/lib'
"let g:ncm2_pyclang#database_path = [
"\ 'compile_commands.json',
"\ 'build/compile_commands.json' ]
"let g:ncm2_pyclang#args_file_path = ['.clang_complete']

" Snippets
let g:UltiSnipsEditSplit="vertical"

" colorscheme
let g:gruvbox_bold = 1
let g:gruvbox_italic = 1
let g:gruvbox_invert_selection = 0
let g:gruvbox_italicize_strings=1

let g:rainbow_active = 1
let g:rainbow_conf = {
\ 'guifgs': ['#98971a', 'darkorange3', '#cc241d', '#b16286', '#458588'],
\ }
