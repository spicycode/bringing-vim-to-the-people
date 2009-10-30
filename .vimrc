" * General Settings

  scriptencoding utf-8
  
  " colorscheme spicycodegui
  " colorscheme github256
  colorscheme ir_black

" Use zsh.
  set shell=zsh  

" Enable filetype-specific indenting and plugins
  filetype plugin indent on

" Explicitly set 256 color support
  set t_Co=256

" Change <Leader> and <LocalLeader>
  let mapleader = ","
  let maplocalleader = ","

" Set temporary directory (don't litter local dir with swp/tmp files)
  set directory=/tmp/

" Syntax Highlighting on
  set nocompatible
  syntax on
  
" Highlight matching parens
  set showmatch
  
" Use the tab complete menu
  set wildmenu 
  set wildmode=list:longest,full
  
" Disable bell.
  set vb t_vb=

" Don't flick cursor.
  set guicursor=a:blinkon0

" Enable error files & error jumping.
  set cf  
  
" Writes on make/shell commands
  set autowrite  
  
" * Text Formatting -- General

" don't make it look like there are line breaks where there are none
  set nowrap

" use indents of 2 spaces, and have them copied down lines:
  set expandtab
  set tabstop=2
  set softtabstop=2 
  set shiftwidth=2

  set autoindent

" Set to auto read when a file is changed from the outside
  set autoread

" line numbers
  set number
  set numberwidth=3
  
" Make backspace work in insert mode
  set backspace=indent,eol,start
  
" * File Browsing

" Settings for explorer.vim
  let g:explHideFiles='^\.'
  
" * Window splits

" Open new horizontal split windows below current
  set splitbelow

" Open new vertical split windows to the right
  set splitright   
  
" * Quick keybindings

" Quick, jump out of insert mode while no one is looking
  imap ii <Esc>
  
" Remap F1 from Help to ESC.  No more accidents
  nmap <F1> <Esc>
  map! <F1> <Esc>
  
" Yank from the cursor to the end of the line, to be consistent with C and D.
  nnoremap Y y$
  
" Let syntastic open the error list
  " let g:syntastic_auto_loc_list=1

" Add RebuildTagsFile function/command
  function! s:RebuildTagsFile()
    !ctags -R --exclude=coverage --exclude=files --exclude=public --exclude=log --exclude=tmp --exclude=vendor *
  endfunction
  command! -nargs=0 RebuildTagsFile call s:RebuildTagsFile()
  
" * Load external config
" runtime! custom/statusbar_config.vim
  runtime! custom/ruby_and_rails_config.vim
  runtime! custom/clojure_config.vim
  runtime! custom/vimshell_config.vim
  runtime! custom/taglist_config.vim
  runtime! custom/search_config.vim
  runtime! custom/nerdcommenter_config.vim
  runtime! custom/nerdtree_config.vim
  runtime! custom/fuzzy_finder_config.vim
