runtime syntax/diff.vim
setlocal filetype=

" match first 50 characters on first line, unless it starts with #
syntax match gitCommitHeader    +^[^#]\%1l.\{1,50}+
" match everything on line 2 if first character is not #
syntax match gitCommitEmptyLine +^[^#]\%2l.*+

syntax match gitStatusComment   +^#.*+ contains=ALL

syntax match gitStatusBranch    +On branch .\++

syntax match gitStatusUndracked +\t\zs.\++
syntax match gitStatusNewFile   +\t\zsnew file: .\++
syntax match gitStatusModified  +\t\zsmodified: .\++

highlight link gitCommitHeader      Title
highlight link gitCommitEmptyLine   Error

highlight link gitStatusComment     Comment

highlight link gitStatusBranch      Title

highlight link gitStatusUndracked   diffOnly
highlight link gitStatusNewFile     diffAdded
highlight link gitStatusModified    diffChanged
