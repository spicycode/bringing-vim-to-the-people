" NERDTree 

" Enable nice colors
  let NERDChristmasTree = 1

" Make it easy to see where we are
  let NERDTreeHighlightCursorline = 1

" Make bookmarks visible
  let NERDTreeShowBookmarks = 1

" Show hidden files
  let NERDTreeShowHidden = 1
" Don't hijack NETRW
  let NERDTreeHijackNetrw = 0
  let NERDTreeIgnore=['\.$', '\~$']
  
" Make F2 open NERDTree
  nmap <F2> :NERDTreeToggle<CR>
