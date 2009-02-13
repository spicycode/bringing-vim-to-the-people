nmap <D-[> :tabprevious<CR>
nmap <D-]> :tabnext<CR>
map <D-[> :tabprevious<CR>
map <D-]> :tabnext<CR>
imap <D-[> <C-O>:tabprevious<CR>
imap <D-]> <C-O>:tabnext<CR>

" Unmap Apple+T so we can...
macmenu &File.New\ Tab key=<nop>
" Use it for FuzzyFinder
nnoremap <D-t> :FuzzyFinderTextMate<CR> 

" Run file in shell mode with ruby
nnoremap <D-r> :Shell ruby %<cr>
