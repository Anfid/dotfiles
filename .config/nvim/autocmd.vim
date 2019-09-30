" ------------------ Terminal
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
autocmd TermOpen * startinsert

" ------------------ QF List
:command! RemoveQFItem :call RemoveQFItem()
" Map function to dd in qf list buffer
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>

" ------------------ Rust
au FileType rust nmap gd <Cmd>TagImposterAnticipateJump<CR><Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <C-e> <Cmd>TagImposterAnticipateJump<CR><Plug>(rust-def)
"autocmd BufRead *.rs :setlocal tags=./.tags.rs;/,$RUST_SRC_PATH/rusty-tags.vi
"autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet -O=.tags.rs --start-dir=" . expand('%:p:h') . "&" | redraw!


" ------------------ Vim
function! VimFtConfig()
  setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab nowrap
endfunction
autocmd filetype vim call VimFtConfig()

" ------------------ Sh
function! ShFtConfig()
  setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
endfunction
autocmd filetype sh call ShFtConfig()

" ------------------ Vimwiki
function! VimwikiFtConfig()
  setlocal tabstop=3 softtabstop=3 shiftwidth=3 expandtab breakindent wrap

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

