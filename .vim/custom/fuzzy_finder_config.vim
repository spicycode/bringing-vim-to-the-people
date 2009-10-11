" Only show the XX best matches to keep speed up
  let g:fuf_enumeratingLimit = 50

" Ignore case when searching
  let g:fuf_ignoreCase = 1

" Buffers:

" Order buffers in MRU order
  let g:fuf_buffer_mruOrder = 1

" Files:

" Ignore these extensions
  let g:fuf_file_exclude = "\.png$|\.jpg$|\.gif$|vendor|coverage|tmp"

" Never switch to Tagged File mode
  let g:fuf_taggedfile_switchOrder = -1

" Use fuzzy finder tag lookup instead of builtin one
  noremap <silent> <C-]> :FufTagWithCursorWord!<CR>
