" * General Settings

  scriptencoding utf-8
  
  colorscheme ir_black

" Title: no title for me
  set notitle
  
" Use zsh.
  set shell=zsh  

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
  
" Use the tab complete menu
  set wildmenu 
  set wildmode=list:longest,full
  
" Disable bell.
  set vb t_vb=

" Don't flick cursor.
  set guicursor=a:blinkon0

" Enable error files & error jumping.
  set cf  
  
" Yanks go on clipboard instead.
  set clipboard+=unnamed

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

" disable line numbers
  set nonumber
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

" * Load external config
" runtime! statusbar_config.vim
  runtime! vimshell_config.vim
  runtime! taglist_config.vim
  runtime! search_config.vim
  runtime! nerdcommenter_config.vim
  runtime! nerdtree_config.vim
  runtime! fuzzy_finder_config.vim