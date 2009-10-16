" Fuzzy find files in project a la TextMate
  let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;files/**;vendor/**;coverage/**;tmp/**,public/image/**"
  let g:fuzzy_enumerating_limit = 20
  let g:fuzzy_path_display = 'relative_path'
  let g:fuzzy_ceiling = 5000

" Use FuzzyFinder to replace built-in tag navigation :tag and <C-]>:
  nnoremap <silent> <C-f><C-t> :FuzzyFinderTag!<CR>
  nnoremap <silent> <C-]>      :FuzzyFinderTag! <C-r>=expand('<cword>')<CR><CR>
