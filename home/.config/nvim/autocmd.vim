" ------------------ Terminal
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
autocmd TermOpen * startinsert

" ------------------ Coc
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" ------------------ QF List
:command! RemoveQFItem :call RemoveQFItem()
" Map function to dd in qf list buffer
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>

" ------------------ Rust
au FileType rust nmap gd <Cmd>TagImposterAnticipateJump<CR><Plug>(coc-definition)
au FileType rust nmap <C-e> <Cmd>TagImposterAnticipateJump<CR><Plug>(coc-definition)

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
