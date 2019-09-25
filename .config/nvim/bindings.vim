" ------------------ Functions ------------------
" Align cursor to top quarter of the screen
function! AlignOptimal()
  let l:view = winsaveview()
  let l:view['topline'] += winline() - winheight(0) / 4
  call winrestview(l:view)
endfunction

" Scroll function
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

function! GetCharRelative(x, y)
  return strcharpart(strpart(getline(line('.') + a:y), col('.') + a:x - 1), 0, 1)
endfunction

function! JumpVertical(direction, ...)
  if a:direction == 'down'
    let a = 1
    let dir_flag = ''
  elseif a:direction == 'up'
    let a = -1
    let dir_flag = 'b'
  else
    echoerr 'Invalid argument'
    return
  endif

  let col = col('.')
  let line = line('.')
  let jumplist_threshold = get(a:, 1, 10)
  let char = GetCharRelative(0, 0)
  let next_char = GetCharRelative(0, a)

  if next_char == '' || next_char == ' ' || next_char == '	' ||
  \  char == ''      || char == ' '      || char == '	'
    let dest_line = search('\%'.col.'c[^ 	]', 'n'.dir_flag)
    if abs(line - dest_line) > jumplist_threshold
      call setpos("''", getpos('.'))
    endif
    call cursor(dest_line, col)
  else
    let dest_line = search('\%'.col.'c[ 	]\|^.\{,'.(col-1).'}$', 'nW'.dir_flag) - a
    if abs(line - dest_line) >= jumplist_threshold
      call setpos("''", getpos('.'))
    endif
    call cursor(dest_line, col)
  endif
endfunction

" Remove item from qf list
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction

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


" ------------------ Leader ------------------
noremap <Space> <Nop>
let mapleader = " "


" ------------------ Movement ------------------
" General
nnoremap n h|  xnoremap n h|  onoremap n h
nnoremap e gj| xnoremap e gj| onoremap e gj
nnoremap i gk| xnoremap i gk| onoremap i gk
nnoremap o l|  xnoremap o l|  onoremap o l

nnoremap <expr> N (&wrap == 1 ? "g^" : "^")
nnoremap <expr> O (&wrap == 1 ? "g$" : "$")
xnoremap <expr> N (&wrap == 1 ? "g^" : "^")
xnoremap <expr> O (&wrap == 1 ? "g$" : "$")
onoremap <expr> N (&wrap == 1 ? "g^" : "^")
onoremap <expr> O (&wrap == 1 ? "g$" : "$")

nnoremap l b| xnoremap l b| onoremap l b
nnoremap L B| xnoremap L B| onoremap L B
nnoremap y e| xnoremap y e| onoremap y e
nnoremap Y E| xnoremap Y E| onoremap Y E
nnoremap u w| xnoremap u w| onoremap u w
nnoremap U W| xnoremap U W| onoremap U W

noremap b *
noremap B #
noremap <expr> k 'Nn'[v:searchforward]
noremap <expr> K 'nN'[v:searchforward]

let g:clever_f_not_overwrites_standard_mappings = 1
nmap f <Plug>(clever-f-f)| xmap f <Plug>(clever-f-f)| omap f <Plug>(clever-f-f)
nmap F <Plug>(clever-f-F)| xmap F <Plug>(clever-f-F)| omap F <Plug>(clever-f-F)
nmap p <Plug>(clever-f-t)| xmap p <Plug>(clever-f-t)| omap p <Plug>(clever-f-t)
nmap P <Plug>(clever-f-T)| xmap P <Plug>(clever-f-T)| omap P <Plug>(clever-f-T)

" Fall through to non-whitespace
noremap <silent> <leader>e <Cmd>call JumpVertical('down')<CR>
noremap <silent> <leader>i <Cmd>call JumpVertical('up')<CR>

" Insert
inoremap <expr> <Tab>   (pumvisible() ? "\<C-n>" : "\<Tab>")
inoremap <expr> <S-tab> (pumvisible() ? "\<C-p>" : "\<S-Tab>")
inoremap <expr> <CR>    (pumvisible() ? "\<c-y>" : "\<CR>")

" Terminal
tnoremap <expr> <A-r> '<C-\><C-n>"'.nr2char(getchar()).'pa'


" ------------------ Editing ------------------
" Insert mode
nnoremap a i
nnoremap t a
noremap <expr> A (&wrap == 1 ? "g^i" : "^i")
noremap <expr> T (&wrap == 1 ? "g$a" : "$a")
" Make insert/add work also in visual line mode like in visual block mode
xnoremap <silent> <expr> A (mode() =~# "[V]" ? "\<C-V>1o$I" : "I")
xnoremap <silent> <expr> A (mode() =~# "[V]" ? "\<C-V>0o$I" : "I")
xnoremap <silent> <expr> T (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")
xnoremap <silent> <expr> T (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")
" with new line
nnoremap h o
nnoremap H O

" Visual mode
nnoremap s v| xnoremap s v
nnoremap S V| xnoremap S V
nnoremap <C-s> <C-v>|xnoremap <C-s> <C-v>
nnoremap gs gv

" Command mode
noremap ' :

" Cut/Copy/Paste
nnoremap x x|  xnoremap x d
nnoremap X dd| xnoremap X d
nnoremap c y|  xnoremap c y
nnoremap C y$| xnoremap C y
nnoremap cc yy
nnoremap v p|  xnoremap v p
nnoremap V P|  xnoremap V P
nnoremap gv gp|xnoremap gv gp
nnoremap gV gP|xnoremap gV gP

" Change
nnoremap w c| xnoremap w c
nnoremap W C| xnoremap W C
nnoremap ww cc

" Undo/Redo
nnoremap z u|     xnoremap z :<C-U>undo<CR>
nnoremap gz U|    xnoremap gz :<C-U>undo<CR>
nnoremap Z <C-R>| xnoremap Z :<C-U>redo<CR>

" Indent
xnoremap > >gv
xnoremap < <gv

" Align
nmap <Leader>a <Plug>(EasyAlign)| xmap <Leader>a <Plug>(EasyAlign)


" ------------------ Navigation ------------------
" Tags
nnoremap <C-e> g<C-]>
nnoremap <silent> <C-y> <Cmd>pop<CR>

" Screen positioning
nnoremap ,m zz| xnoremap ,m zz
nnoremap ,b zb| xnoremap ,b zb
nnoremap ,t zt| xnoremap ,t zt
nnoremap <silent> ,, <Cmd>call AlignOptimal()<CR>
xnoremap <silent> ,, <Cmd>call AlignOptimal()<CR>

" Scroll
let g:keyboard_scroll = 5
let g:mouse_scroll = 3
nnoremap <silent> E <Cmd>call Scroll(g:keyboard_scroll, "down")<CR>
nnoremap <silent> I <Cmd>call Scroll(g:keyboard_scroll, "up")<CR>
xnoremap <silent> E <Cmd>call Scroll(g:keyboard_scroll, "down")<CR>
xnoremap <silent> I <Cmd>call Scroll(g:keyboard_scroll, "up")<CR>
nnoremap <silent> <ScrollWheelUp>   <Cmd>call Scroll(g:mouse_scroll, "up")<CR>
nnoremap <silent> <ScrollWheelDown> <Cmd>call Scroll(g:mouse_scroll, "down")<CR>
xnoremap <silent> <ScrollWheelUp>   <Cmd>call Scroll(g:mouse_scroll, "up")<CR>
xnoremap <silent> <ScrollWheelDown> <Cmd>call Scroll(g:mouse_scroll, "down")<CR>

" Folds
nnoremap ,a za| xnoremap ,a za| onoremap ,a za

" Highlight
nnoremap <silent> <Leader>hs :call gruvbox#hls_toggle()<CR>


" ------------------ Buffers ------------------
" Splits
noremap <silent> <A-n> <Esc><C-w>h| inoremap <silent> <A-n> <Esc><C-w>h| cnoremap <silent> <A-n> <Esc><C-w>h
noremap <silent> <A-e> <Esc><C-w>j| inoremap <silent> <A-e> <Esc><C-w>j| cnoremap <silent> <A-e> <Esc><C-w>j
noremap <silent> <A-i> <Esc><C-w>k| inoremap <silent> <A-i> <Esc><C-w>k| cnoremap <silent> <A-i> <Esc><C-w>k
noremap <silent> <A-o> <Esc><C-w>l| inoremap <silent> <A-o> <Esc><C-w>l| cnoremap <silent> <A-o> <Esc><C-w>l
tnoremap <silent> <A-n> <C-\><C-N><C-w>h
tnoremap <silent> <A-e> <C-\><C-N><C-w>j
tnoremap <silent> <A-i> <C-\><C-N><C-w>k
tnoremap <silent> <A-o> <C-\><C-N><C-w>l

nnoremap <silent> <C-w>r :resize <Bar> vertical resize<CR>
tnoremap <silent> <C-w>r <C-\><C-n>:resize<CR>a

" Tabs
nnoremap <silent> <Tab> gt
nnoremap <silent> <S-Tab> gT
nnoremap <C-t>e :tabedit<Space>
nnoremap <silent> <C-t>n <Cmd>tabnew<CR>
nnoremap <silent> <C-t>c <Cmd>tabclose<CR>
nnoremap <silent> <C-t>o <Cmd>tabonly<CR>
nnoremap <silent> <C-t>[ <Cmd>tabprevious<CR>
nnoremap <silent> <C-t>] <Cmd>tabnext<CR>
nnoremap <silent> <C-t>{ <Cmd>tabfirst<CR>
nnoremap <silent> <C-t>} <Cmd>tablast<CR>

" Open terminal
nnoremap <silent> <C-c> <Cmd>Tnew<CR>

" Next-family
call s:MapNextFamily('a','')
call s:MapNextFamily('b','b')
call s:MapNextFamily('l','l')
call s:MapNextFamily('q','c')
call s:MapNextFamily('t','tab')

" Config editong
nnoremap <silent> <Leader>sc <Cmd>tabedit ~/.config/nvim<CR>
nnoremap <silent> <Leader>sr <Cmd>source ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>st <Cmd>source %<CR>


" ------------------ Text Objects ------------------
let g:textobj_entire_no_default_key_mappings = 1
let g:textobj_function_no_default_key_mappings = 1
let g:textobj_indent_no_default_key_mappings = 1
let g:textobj_line_no_default_key_mappings = 1
let g:textobj_variable_no_default_key_mappings = 1
let g:skip_default_textobj_word_column_mappings = 1
let g:surround_no_mappings = 1

omap ae <Plug>(textobj-entire-a)|              xmap ae <Plug>(textobj-entire-a)
omap re <Plug>(textobj-entire-i)|              xmap re <Plug>(textobj-entire-i)
omap af <Plug>(textobj-function-a)|            xmap af <Plug>(textobj-function-a)
omap rf <Plug>(textobj-function-i)|            xmap rf <Plug>(textobj-function-i)
omap aF <Plug>(textobj-function-A)|            xmap aF <Plug>(textobj-function-A)
omap rF <Plug>(textobj-function-I)|            xmap rF <Plug>(textobj-function-A)
omap ai <Plug>(textobj-indent-a)|              xmap ai <Plug>(textobj-indent-a)
omap ri <Plug>(textobj-indent-i)|              xmap ri <Plug>(textobj-indent-i)
omap aI <Plug>(textobj-indent-same-a)|         xmap aI <Plug>(textobj-indent-same-a)
omap rI <Plug>(textobj-indent-same-i)|         xmap rI <Plug>(textobj-indent-same-i)
omap al <Plug>(textobj-line-a)|                xmap al <Plug>(textobj-line-a)|
omap rl <Plug>(textobj-line-i)|                xmap rl <Plug>(textobj-line-i)|
omap av <Plug>(textobj-variable-a)|            xmap av <Plug>(textobj-variable-a)
omap rv <Plug>(textobj-variable-i)|            xmap rv <Plug>(textobj-variable-i)
omap rh <Plug>(GitGutterTextObjectInnerPending)| xmap rh <Plug>(GitGutterTextObjectInnerVisual)
omap ah <Plug>(GitGutterTextObjectOuterPending)| xmap ah <Plug>(GitGutterTextObjectOuterVisual)
omap <silent> ac :call TextObjWordBasedColumn("aw")<cr>| xmap <silent> ac :<C-u>call TextObjWordBasedColumn("aw")<cr>
omap <silent> aC :call TextObjWordBasedColumn("aW")<cr>| xmap <silent> aC :<C-u>call TextObjWordBasedColumn("aW")<cr>
omap <silent> rc :call TextObjWordBasedColumn("iw")<cr>| xmap <silent> rc :<C-u>call TextObjWordBasedColumn("iw")<cr>
omap <silent> rC :call TextObjWordBasedColumn("iW")<cr>| xmap <silent> rC :<C-u>call TextObjWordBasedColumn("iW")<cr>
call after_object#enable(["a", "A"], '=', ':')
let g:targets_aiAI = 'arAR'

let g:expand_region_text_objects = {
\ 'rw'  :0,
\ 'rW'  :0,
\ 'r"'  :0,
\ 'r''' :0,
\ 'r]'  :1,
\ 'rb'  :1,
\ 'rl'  :0,
\ 'ri'  :0,
\ 'rB'  :1,
\ 'rf'  :0,
\ 're'  :0,
\ }

" Targets workaround. Could not get it to work with provided options
onoremap rw iw| xnoremap rw iw
onoremap rW iW| xnoremap rW iW
onoremap rp ip| xnoremap rp ip
onoremap rp ip| xnoremap rp ip
onoremap rs is| xnoremap rs is
onoremap rp ip| xnoremap rp ip

nmap ds  <Plug>Dsurround
nmap ws  <Plug>Csurround
nmap wS  <Plug>CSurround
nmap cs  <Plug>Ysurround
nmap cS  <Plug>YSurround
nmap css <Plug>Yssurround
nmap cSs <Plug>YSsurround
nmap cSS <Plug>YSsurround
xmap S   <Plug>VSurround
xmap gS  <Plug>VgSurround


" ------------------ Free keys ------------------
noremap <C-b>   <Nop>
noremap ;       <Nop>


" ------------------ Quality of life ------------------
nnoremap w<CR> :w<CR>


" ------------------ Plugin keys ------------------
" GitGutter
let g:gitgutter_map_keys = 0
nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
nmap <Leader>hs <Plug>(GitGutterStageHunk)
nmap <Leader>hu <Plug>(GitGutterUndoHunk)
nmap [c <Plug>(GitGutterPrevHunk)
nmap ]c <Plug>(GitGutterNextHunk)

" CtrlSpace
nnoremap <silent> <C-Space> :CtrlSpace<CR>
let g:CtrlSpaceKeys = {
\ "Buffer": {
  \ "e": "ctrlspace#keys#common#Down",
  \ "i": "ctrlspace#keys#common#Up",
  \ "x": "ctrlspace#keys#buffer#DeleteBuffer",
  \ "d": "ctrlspace#keys#buffer#DeleteBuffer", },
\ "Tab": {
  \ "e": "ctrlspace#keys#common#Down",
  \ "i": "ctrlspace#keys#common#Up", },
\ "File": {
  \ "e": "ctrlspace#keys#common#Down",
  \ "i": "ctrlspace#keys#common#Up", },
\ "Workspace": {
  \ "e": "ctrlspace#keys#common#Down",
  \ "i": "ctrlspace#keys#common#Up", },
\ "Bookmark": {
  \ "e": "ctrlspace#keys#common#Down",
  \ "i": "ctrlspace#keys#common#Up", },
\ "Nop": {},
\ "Search": {
  \ "e": "ctrlspace#keys#common#Down",
  \ "i": "ctrlspace#keys#common#Up", },
\ "Help": {
  \ "e": "ctrlspace#keys#common#Down",
  \ "i": "ctrlspace#keys#common#Up", },
\ }

" Tagbar
nmap <silent> <C-o> :TagbarOpenAutoClose<CR>
let g:tagbar_map_togglecaseinsensitive = "t"
let g:tagbar_map_togglefold = ",a"
let g:tagbar_map_jump = ["o", "<CR>"]

" fuzzy
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <C-g> :GrepFiles<CR>
nnoremap <silent> <C-_> :BLines<CR>

" git (VCS)
nnoremap <silent> <Leader>vb <Cmd>Gblame<CR>
nnoremap <silent> <Leader>vs <Cmd>Gstatus<CR>
nnoremap <silent> <Leader>vd <Cmd>Gdiff<CR>
nnoremap <silent> <Leader>vc <Cmd>Commits<CR>
nnoremap <silent> <Leader>vf <Cmd>BCommits<CR>
" return on Backspace
autocmd User fugitive
 \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
 \   nnoremap <buffer> <BS> :edit %:h<CR> |
 \ endif

" Ranger
nnoremap - :Ranger<CR>

" AutoPairs
let g:AutoPairsShortcutFastWrap = '<M-w>'
let g:AutoPairsShortcutJump = '<M-k>'

" FixedTaskList
nnoremap <silent> <Leader>tl :TaskList<CR>

nnoremap <silent> <Leader>gh :GitGutterLineHighlightsToggle<CR>


" ------------------ UltiSnips ------------------
let g:UltiSnipsExpandTrigger="<C-w>"
let g:UltiSnipsJumpForwardTrigger="<C-n>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"

nnoremap <silent> <Leader>hs :call gruvbox#hls_toggle()<CR>


" ------------------ Workarounds for tpope plugins ------------------
nmap z <Plug>(RepeatUndo)
if empty(mapcheck("<Plug>(RepeatUndo)"))
  nnoremap <Plug>(RepeatUndo) u
endif

augroup RemoveFugitiveMapping
  autocmd!
  autocmd BufEnter * silent! execute "nunmap <buffer> <silent> y<C-G>"
augroup END
