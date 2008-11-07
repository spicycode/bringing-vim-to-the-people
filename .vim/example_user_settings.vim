if has("gui_running")
  colors spicycodegui
  set guioptions=e
  set guioptions-=m
else
" MAKE ARROW KEYS WORK IN CONSOLE VI
 set term=xterm
 colors spicycode
endif
