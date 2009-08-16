" NERDCommenter
  let NERDDefaultNesting = 0
  let NERDRemoveExtraSpaces = 1
  let NERDSpaceDelims = 1

" bind command-/ to toggle comment
" requires NERD Commenter to be installed: http://www.vim.org/scripts/script.php?script_id=1218
  nmap <D-/> ,c<Space>
  vmap <D-/> ,c<Space>
  imap <D-/> <C-O>,c<Space>