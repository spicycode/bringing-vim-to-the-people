" show the `best match so far' as search strings are typed:
  set incsearch

" Highlight search results once found:
  set hlsearch
  
" assume the /g flag on :s substitutions to replace all matches in a line:
  set gdefault

" <leader>f to startup an ack search
  map <leader>f :Ack<Space>
