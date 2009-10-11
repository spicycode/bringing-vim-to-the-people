" show the `best match so far' as search strings are typed:
  set incsearch

" Do not highlight search results once found:
  set nohlsearch
  
" assume the /g flag on :s substitutions to replace all matches in a line:
  set gdefault

" <leader>f to startup an ack search
  map <leader>f :Ack<Space>