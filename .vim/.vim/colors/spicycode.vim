" Vim color scheme
"
" Name:         spicycode.vim

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let colors_name = "spicycode"

if has("gui_running")
    highlight Normal guifg=White   guibg=Black
    highlight Cursor guifg=Black   guibg=Yellow
    highlight Keyword guifg=#FF6600
    highlight Define guifg=#FF6600
    highlight Comment guifg=#9933CC
    highlight Type guifg=White gui=NONE
    highlight rubySymbol guifg=#339999 gui=NONE
    highlight Identifier guifg=White gui=NONE
    highlight rubyStringDelimiter guifg=#66FF00
    highlight rubyInterpolation guifg=White
    highlight rubyPseudoVariable guifg=#339999
    highlight Constant guifg=#FFEE98
    highlight Function guifg=#FFCC00 gui=NONE
    highlight Include guifg=#FFCC00 gui=NONE
    highlight Statement guifg=#FF6600 gui=NONE
    highlight String guifg=#66FF00
    highlight Search guibg=White
    highlight Pmenu guibg=darkgrey gui=bold guifg=white 
    highlight PmenuSel guibg=green gui=bold guifg=white 

    " display the status line of the active window in a distinctive color: 
    hi StatusLine gui=NONE,bold guibg=darkgrey guifg=white 
    hi WildMenu gui=NONE,bold guibg=green guifg=white 
    hi StatusLineNC gui=NONE guibg=black guifg=lightgrey 
    
else
    set t_Co=256
    highlight Normal ctermfg=White ctermbg=Black  
    highlight Cursor ctermfg=Black ctermbg=Yellow 
    highlight Keyword ctermfg=202 
    highlight Define ctermfg=202 
    highlight Comment ctermfg=98
    highlight Type ctermfg=White 
    highlight rubySymbol ctermfg=66 
    highlight Identifier ctermfg=White 
    highlight rubyStringDelimiter ctermfg=82 
    highlight rubyInterpolation ctermfg=White 
    highlight rubyPseudoVariable ctermfg=66 
    highlight Constant ctermfg=228 
    highlight Function ctermfg=220 
    highlight Include ctermfg=220 
    highlight Statement ctermfg=202
    highlight String ctermfg=82 
    highlight Search ctermbg=White 
    highlight Pmenu ctermbg=darkgrey cterm=bold ctermfg=white 
    highlight PmenuSel ctermbg=green cterm=bold ctermfg=white 

    " display the status line of the active window in a distinctive color: 
    hi StatusLine cterm=NONE,bold ctermbg=darkgrey ctermfg=white 
    hi WildMenu cterm=NONE,bold ctermbg=green ctermfg=white 
    hi StatusLineNC cterm=NONE ctermbg=black ctermfg=lightgrey 

    " make the active status line colours alternate between two settings to give a visual notice of the CursorHold/CursorHoldI events 
    if ! exists("s:statuslineflag") 
      let s:statuslineflag = 0 
    endif 

    " define colors for the tab line: 
    " file name of unselected tab 
    hi TabLine              gui=NONE                guibg=#EEEEEE           guifg=black   cterm=NONE,bold         ctermbg=darkgrey       ctermfg=white 
    " file name of selected tab (GUI default is bold black on white) 
    " hi TabLineSel           cterm=NONE,bold         ctermbg=white           ctermfg=black 
    " fillup and tab-delete "X" at right 
    hi TabLineFill          gui=NONE,bold           guibg=#CCCCCC           guifg=#990000 cterm=NONE ctermbg=darkgrey       ctermfg=red 

endif
