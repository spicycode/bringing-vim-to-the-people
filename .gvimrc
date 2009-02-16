nmap <D-[> :tabprevious<CR>
nmap <D-]> :tabnext<CR>
map <D-[> :tabprevious<CR>
map <D-]> :tabnext<CR>
imap <D-[> <C-O>:tabprevious<CR>
imap <D-]> <C-O>:tabnext<CR>

" Unmap Apple+T so we can...
macmenu &File.New\ Tab key=<nop>

" Change Apple+T to TextMate Like Fuzzy Finder
nnoremap <D-t> :FuzzyFinderTextMate<CR> 

" Unmap Apple+Shift+T so we can...
macmenu &File.Open\ Tab\.\.\. key=<nop>

" Change Apple+Shift+T to TextMate Like Fuzzy Finder
nnoremap <D-T> :FuzzyFinderTag!<CR> 

" Run file in shell mode with ruby
nnoremap <D-r> :Shell ruby %<cr>
