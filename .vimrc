  scriptencoding utf-8

" Enable filetype-specific indenting and plugins
  filetype plugin indent on

" Explicitly set 256 color support
  set t_Co=256

" Change <Leader>
  let mapleader = ","

" Set temporary directory (don't litter local dir with swp/tmp files)
  set directory=/tmp/

" Syntax Highlighting on
  set nocompatible
  syntax on
  
" Highlight matching parens
  set showmatch
  "set completeopt=menu,preview
  
" Use the tab complete menu
  set wildmenu 
  set wildmode=list:longest,full

" have the mouse enabled all the time:
  set mouse=a

" * Text Formatting -- General

" don't make it look like there are line breaks where there aren't:
  set nowrap

" use indents of 2 spaces, and have them copied down lines:
  set expandtab
  set tabstop=2
  set softtabstop=2 
  set shiftwidth=2

  set autoindent
  
" Set to auto read when a file is changed from the outside
  set autoread

" enable line numbers
  set number
  set numberwidth=3

"folding settings
  set nofoldenable
  set foldmethod=indent
  set foldlevel=1
  set foldnestmax=10

" * File Browsing

" Settings for explorer.vim
  let g:explHideFiles='^\.'

" Enable the tab bar
  set showtabline=1 " 1=only if there are at least two tabs, 2=always

" Make backspace work in insert mode
  set backspace=indent,eol,start

" Remember last position in file
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
  
" Tab navigation
  nmap <leader>tn :tabnext<CR>
  nmap <leader>tp :tabprevious<CR>  
  nmap <leader>te :tabedit  

" Remap F1 from Help to ESC.  No more accidents
  nmap <F1> <Esc>
  map! <F1> <Esc>

	set splitbelow " Open new horizontal split windows below current
  set splitright " Open new vertical split windows to the right

  " Add RebuildTagsFile function/command
  function! s:RebuildTagsFile()
    !ctags -R --exclude=coverage --exclude=files --exclude=public --exclude=log --exclude=tmp --exclude=vendor *
  endfunction
  command! -nargs=0 RebuildTagsFile call s:RebuildTagsFile()

" Run file with...
  nmap <leader>st :Shell ruby %<CR>
  
" Quick, jump out of insert mode while no one is looking
  imap ii <Esc>

" Title: no title for me
  set notitle

" IRB 
  autocmd FileType irb inoremap <buffer> <silent> <CR> <Esc>:<C-u>ruby v=VIM::Buffer.current;v.append(v.line_number, eval(v[v.line_number]).inspect)<CR>
  nnoremap <leader>irb :<C-u>below new<CR>:setfiletype irb<CR>:set syntax=ruby<CR>:set buftype=nofile<CR>:set bufhidden=delete<CR>i

" Turn on language specific omnifuncs
  autocmd FileType ruby set omnifunc=rubycomplete#Complete
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType c set omnifunc=ccomplete#Complete
  autocmd FileType vim set omnifunc=syntaxcomplete#Complete

" have some fun with bufexplorer
  let g:bufExplorerDefaultHelp=0       " Do not show default help.
  let g:bufExplorerShowRelativePath=1  " Show relative paths.

" Set keyword prog for ruby
  set keywordprg=ri

" search next/previous -- center in page
  nmap n nzz
  nmap N Nzz
  nmap * *Nzz
  nmap # #nzz

" Yank from the cursor to the end of the line, to be consistent with C and D.
  nnoremap Y y$

" Hide search highlighting
  map <silent> <leader>nh :nohls <CR>

" toggle Quickfix window with <leader>q
  map <silent> <leader>q :QFix<CR>

" Mappings for align 
  vmap <silent> <Leader>i= <ESC>:AlignPush<CR>:AlignCtrl lp1P1<CR>:'<,'>Align =<CR>:AlignPop<CR>
  vmap <silent> <Leader>i, <ESC>:AlignPush<CR>:AlignCtrl lp0P1<CR>:'<,'>Align ,<CR>:AlignPop<CR>
  vmap <silent> <Leader>i( <ESC>:AlignPush<CR>:AlignCtrl lp0P0<CR>:'<,'>Align (<CR>:AlignPop<CR>
  
" Remap common rubytest keybindings
  map <Leader>rt <Plug>RubyTestRun
  map <Leader>rf <Plug>RubyFileRun
  
  set term=xterm
  colorscheme spicycode

  runtime! statusbar.vim
  runtime! clojure_config.vim
  runtime! nerdtree_config.vim
  runtime! nerdcommenter_config.vim
  runtime! fuzzy_finder_config.vim
  runtime! search_config.vim
  runtime! shell.vim
