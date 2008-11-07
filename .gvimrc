:nmap <D-[> :tabprevious<cr>
:nmap <D-]> :tabnext<cr>
:map <D-[> :tabprevious<cr>
:map <D-]> :tabnext<cr>
:imap <D-[> <ESC>:tabprevious<cr>i
:imap <D-]> <ESC>:tabnext<cr>i
" Unmap Apple+T
macmenu &File.New\ Tab key=<nop>
" FuzzyFinder
nnoremap <D-t> :FuzzyFinderTextMate<CR> 
