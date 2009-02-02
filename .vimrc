  scriptencoding utf-8

  " Change <Leader>
  let mapleader = ","

" Set temporary directory (don't litter local dir with swp/tmp files)
  set directory=/tmp/

" When scrolling off-screen do so 3 lines at a time, not 1
  set scrolloff=3

" These two enable syntax highlighting
  set nocompatible
  syntax on
  
" have one hundred lines of command-line (etc) history:
  set history=100

" Show us the command we're typing
  set showcmd

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
  set smartindent
  
""Set to auto read when a file is changed from the outside
  set autoread

" * Search & Replace
" show the `best match so far' as search strings are typed:
  set incsearch

" assume the /g flag on :s substitutions to replace all matches in a line:
  set gdefault

" enable line numbers
  set number
  setlocal numberwidth=3

" FILE BROWSING
" Settings for explorer.vim
  let g:explHideFiles='^\.'

" Settings fo rnetrw
  let g:netrw_list_hide='^\.,\~$'

" ENABLE THE TAB BAR
  set tabline=%!MyTabLine()
  set showtabline=2 " 2=always

" MAKE BACKSPACE WORK IN INSERT MODE
  set backspace=indent,eol,start

" REMEMBER LAST POSITION IN FILE
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" MAKE IT EASY TO UPDATE/RELOAD_vimrc 
  :nmap ,s :source ~/.vimrc<cr>
  :nmap ,v :tabe ~/.vimrc<cr>
  
" TAB NAVIGATION
  :nmap ,tn :tabnext<cr>
  :nmap ,tp :tabprevious<cr>  
  :nmap ,te :tabedit  

" Remap F1 from Help to ESC.  No more accidents
  nmap <F1> <Esc>
  map! <F1> <Esc>

" <leader>f to startup an ack search
  map <leader>f :Ack<space>

" SHELL
  command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)

  function! s:RunShellCommand(cmdline)
    botright new

    setlocal buftype=nofile 
    setlocal bufhidden=delete 
    setlocal nobuflisted 
    setlocal noswapfile 
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell

    call setline(1,a:cmdline)
    call setline(2,substitute(a:cmdline,'.','=','g'))
    execute 'silent $read !'.escape(a:cmdline,'%#')
    setlocal nomodifiable
    1
  endfunction

  :nmap ,sh :Shell 

" find file in project
  :nmap ,t :FuzzyFinderTextMate<cr> 

" Run file with 
  :nmap ,sf :Shell script/spec -fn %<cr>
  :nmap ,st :Shell ruby %<cr>
  
" Quick, jump out of insert mode while no one is looking
  :imap ii <Esc>

" Nice statusbar
  set laststatus=2
  set statusline=\ "
  set statusline+=%f\ " file name
  set statusline+=[
  set statusline+=%{strlen(&ft)?&ft:'none'}, " filetype
  set statusline+=%{&fileformat}] " file format
  set statusline+=%h%1*%m%r%w%0* " flag
  set statusline+=%= " right align
  set statusline+=%-14.(%l,%c%V%)\ %<%P " offset

" Title: update the title of the window?
  set title

" Title String: what will actually be displayed
  set titlestring=VIM:\ %-25.55F\ %a%r%m titlelen=70

" Turn off rails bits of statusbar
  let g:rails_statusline=0
 
" TagList {{{
  let Tlist_GainFocus_On_ToggleOpen = 1
  let Tlist_Process_File_Always = 1
  let Tlist_Inc_Winwidth = 0
  let Tlist_Enable_Fold_Column = 0 "Disable drawing the fold column
  let Tlist_Use_SingleClick = 1 "Single click tag selection
  let Tlist_Use_Right_Window = 1
  let Tlist_Exit_OnlyWindow = 1 "Exit if only the taglist is open
  let Tlist_File_Fold_Auto_Close = 1 " Only auto expand the current file
  :nmap ,ta ::TlistAddFilesRecursive app<cr>TlistAddFilesRecursive lib<cr>TlistAddFilesRecursive public/stylesheets<cr>
  :nmap <F3> :TlistToggle<cr>

" NERDTree {{{
  let NERDChristmasTree = 1
  let NERDTreeHighlightCursorline = 1
  let NERDTreeShowBookmarks = 1
  let NERDTreeShowHidden = 1

  :nmap <F2> :NERDTreeToggle<cr>

" NERDComment {{{
  let NERDShutUp = 1
  " bind command-/ to toggle comment
  " requires NERD Commenter to be installed: http://www.vim.org/scripts/script.php?script_id=1218
  nmap <D-/> ,c<space>
  vmap <D-/> ,c<space>
  imap <D-/> <C-O>,c<space>

  autocmd FileType irb inoremap <buffer> <silent> <Cr> <Esc>:<C-u>ruby v=VIM::Buffer.current;v.append(v.line_number, eval(v[v.line_number]).inspect)<Cr>
  nnoremap ,irb :<C-u>below new<Cr>:setfiletype irb<Cr>:set syntax=ruby<Cr>:set buftype=nofile<Cr>:set bufhidden=delete<Cr>i

  " Textmate Fuzzy Finder ignores
  let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**"
  let g:fuzzy_matching_limit = 40


  autocmd FileType ruby set omnifunc=rubycomplete#Complete
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

  runtime user_settings.vim
