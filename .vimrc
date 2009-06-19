  scriptencoding utf-8

" Explicitly set 256 color support
  set t_Co=256

" Change <Leader>
  let mapleader = ","

" Set temporary directory (don't litter local dir with swp/tmp files)
  set directory=/tmp/

" Syntax Highlighting on
  set nocompatible
  syntax on
  
" 100 Lines of history
  set history=100

" Don't show the command in the modeline
  set noshowcmd

" Highlight matching parens
  set showmatch
  set completeopt=menu,preview
  
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

" * Search & Replace

" show the `best match so far' as search strings are typed:
  set incsearch

" assume the /g flag on :s substitutions to replace all matches in a line:
  set gdefault

" enable line numbers
  set number
  set numberwidth=3

" Display extra whitespace
  "  set list listchars=tab:»·,trail:·

"folding settings
  "set foldenable
  "set foldmethod=syntax
  "set foldlevel=1
  "set foldnestmax=2
  "set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '
  " automatically open folds at the starting cursor position
  " autocmd BufReadPost .foldo!

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

" <leader>f to startup an ack search
  map <leader>f :Ack<Space>

	set splitbelow " Open new split windows below current
  

" SHELL
  command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)

  function! s:RunShellCommand(cmdline)
    botright new

    setlocal buftype=nofile 
    setlocal bufhidden=delete 
    setlocal nobuflisted 
    setlocal noswapfile 
    setlocal wrap
    setlocal filetype=shell
    setlocal syntax=shell

    call setline(1,a:cmdline)
    call setline(2,substitute(a:cmdline,'.','=','g'))
    execute 'silent $read !'.escape(a:cmdline,'%#')
    setlocal nomodifiable
    1
  endfunction

  nmap <leader>sh :Shell 

" Fuzzy find files in project a la TextMate
  nmap <leader>t :FuzzyFinderTextMate<CR> 
  let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;files/**;vendor/**;coverage/**;tmp/**"
  let g:fuzzy_enumerating_limit = 20
  let g:fuzzy_path_display = 'relative_path'
  let g:fuzzy_ceiling = 5000

" Use FuzzyFinder to replace built-in tag navigation :tag and <C-]>:
  nnoremap <silent> <C-f><C-t> :FuzzyFinderTag!<CR>
  nnoremap <silent> <C-]>      :FuzzyFinderTag! <C-r>=expand('<cword>')<CR><CR>
  
  " Add RebuildTagsFile function/command
  function! s:RebuildTagsFile()
    !ctags -R --exclude=coverage --exclude=files --exclude=public --exclude=log --exclude=tmp --exclude=vendor *
  endfunction
  command! -nargs=0 RebuildTagsFile call s:RebuildTagsFile()

" Run file with...
  nmap <leader>sf :Shell script/spec -fn %<CR>
  nmap <leader>st :Shell ruby %<CR>
  
" Quick, jump out of insert mode while no one is looking
  imap ii <Esc>

" Nice statusbar
  set laststatus=2
  set statusline=\ "
  set statusline+=%f\ " file name
  set statusline+=[
  set statusline+=%{strlen(&ft)?&ft:'none'}, " filetype
  set statusline+=%{&fileformat}] " file format
  set statusline+=\ %{GitBranch()}
  set statusline+=%h%1*%m%r%w%0* " flag
  set statusline+=%= " right align
  set statusline+=%-14.(%l,%c%V%)\ %<%P " offset

" Title: no title for me
  set notitle

" Turn off rails bits of statusbar
  let g:rails_statusline=0
 
" NERDTree {{{
  let NERDChristmasTree = 1
  let NERDTreeHighlightCursorline = 1
  let NERDTreeShowBookmarks = 1
  let NERDTreeShowHidden = 1
  nmap <F2> :NERDTreeToggle<CR>

" NERDComment {{{
  let NERDShutUp = 1
  let NERDDefaultNesting = 0
  " bind command-/ to toggle comment
  " requires NERD Commenter to be installed: http://www.vim.org/scripts/script.php?script_id=1218
  nmap <D-/> ,c<Space>
  vmap <D-/> ,c<Space>
  imap <D-/> <C-O>,c<Space>

" IRB {{{
  autocmd FileType irb inoremap <buffer> <silent> <CR> <Esc>:<C-u>ruby v=VIM::Buffer.current;v.append(v.line_number, eval(v[v.line_number]).inspect)<CR>
  nnoremap <leader>irb :<C-u>below new<CR>:setfiletype irb<CR>:set syntax=ruby<CR>:set buftype=nofile<CR>:set bufhidden=delete<CR>i

" Turn on language specific omnifuncs
  autocmd FileType ruby set omnifunc=rubycomplete#Complete
  autocmd FileType python set omnifunc=pythoncomplete#Complete
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP
  autocmd FileType c set omnifunc=ccomplete#Complete
  autocmd FileType vim set omnifunc=syntaxcomplete#Complete

" have some fun with bufexplorer
  let g:bufExplorerDefaultHelp=0       " Do not show default help.
  let g:bufExplorerShowRelativePath=1  " Show relative paths.

" Set keyword prog for ruby
  set keywordprg=ri
  
" load user settings
  runtime user_settings.vim
