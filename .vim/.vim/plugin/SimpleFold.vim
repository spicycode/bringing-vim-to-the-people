" Copyright (C) 2006    Mauricio Fernandez <mfp@acm.org>
" Plugin for simple search-based folding
" Designed for use with Ruby, but can be tailored to other filetypes.
"     Version:    0.4.0b 2006-05-12
"      Author:    Mauricio Fernandez <mfp@acm.org>
"  Maintainer:    Mauricio Fernandez <mfp@acm.org> http://eigenclass.org
"     License:    Ruby's license (dual GPL/"Ruby artistic license")
" 
" Mappings and commands
" ---------------------
" Defines the :Fold command; use it as 
"   :Fold \v^function
" You can try it with this very file to see what happens.
" The default mapping to fold the current file using the default fold
" expression (more on this below) is
"    map <unique> <silent> <Leader>f <Plug>SimpleFold_Foldsearch
"                          =========
" i.e. \f unless you changed mapleader. You can copy the above mapping to your
" .vimrc and modify it as desired.
"
" Options
" -------
" By default, secondary, nestable subfolds will be created for the supported
" filetypes (read below to see how this is controlled by the associated fold
" expressions). You can turn that off with:
"   let g:SimpleFold_use_subfolds = 0
"
" Fold expressions
" ----------------
" The default fold expression for most filetypes is
"   let b:simplefold_expr = '\v^\s*[#%"0-9]{0,4}\s*\{(\{\{|!!)'
" The expressions for the extra marker-based folding phase are:
"   let b:simplefold_marker_start = '\v\{\{\{\{'
"   let b:simplefold_marker_end = '\v\}\}\}\}'
"
" You can tailor the fold expressions to other filetypes, taking the
" expressions for Ruby as an example:
"
"    au Filetype ruby let b:simplefold_expr = 
"	    \'\v(^\s*(def|class|module|attr_reader|attr_accessor|alias_method|' .
"                 \   'attr|module_function' . ')\s' . 
"           \ '\v^\s*(public|private|protected)>' .
"	    \ '|^\s*\w+attr_(reader|accessor)\s|^\s*[#%"0-9]{0,4}\s*\{\{\{[^{])' .
"	    \ '|^\s*[A-Z]\w+\s*\=[^=]'
"    au Filetype ruby let b:simplefold_nestable_start_expr = 
"		\ '\v^\s*(def>|if>|unless>|while>.*(<do>)?|' . 
"                \         'until>.*(<do>)?|case>|for>|begin>)' .
"                \ '|^[^#]*.*<do>\s*(\|.*\|)?'
"    au Filetype ruby let b:simplefold_nestable_end_expr = 
"		\ '\v^\s*end'
"
" Here's the (simpler) setup for Java:
" Java support
"    au Filetype java let b:simplefold_expr = 
"			 \ '\(^\s*\(\(private\|public\|protected\|class\)\>\)\)'

if exists("loaded_simplefold")
    finish
endif
let loaded_simplefold = 1

let s:save_cpo = &cpo
set cpo&vim

"{{{ set s:sid

map <SID>xx <SID>xx
let s:sid = maparg("<SID>xx")
unmap <SID>xx
let s:sid = substitute(s:sid, 'xx', '', '')

"{{{ FoldText
function! s:Num2S(num, len)
    let filler = "                                                            "
    let text = '' . a:num
    return strpart(filler, 1, a:len - strlen(text)) . text
endfunction

function! s:SimpleFold_FoldText()
    let linenum = v:foldstart
    if match(getline(linenum), b:simplefold_marker_start) != -1
	let line = getline(linenum)
    else
	while linenum <= v:foldend
	    let line = getline(linenum)
	    if !exists("b:simplefold_prefix") || match(line, b:simplefold_prefix) == -1
		break
	    else
		let linenum = linenum + 1
	    endif
	endwhile
	if exists("b:simplefold_prefix") && match(line, b:simplefold_prefix) != -1
	    " all lines matched the prefix regexp
	    let line = getline(v:foldstart)
	endif
    endif
    let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
    let diff = v:foldend - v:foldstart + 1
    return  '+' . v:folddashes . '[' . s:Num2S(diff,3) . ']' . sub
endfunction

"{{{~ Foldsearch adapted from t77: Fold on search result
function! s:Foldsearch(search)
    call s:SimpleFold_SetupBuffer()
    " set manual
    setlocal fdm=manual
    let origlineno = line(".")
    normal zE
    normal G$
    " set the foldtext
    execute 'setlocal foldtext=' .  s:sid . 'SimpleFold_FoldText()'
    let folded = 0     "flag to set when a fold is found
    let line1 =  0     "set marker for beginning of fold
    let flags = "w"    "allow wrapping
    let first_code_line = 0
    if a:search == ""
	if exists("b:simplefold_expr")
	    let searchre = b:simplefold_expr
	else
	    let searchre = '\v^\s*[#%"0-9]{0,4}\s*\{(\{\{|!!)'
	endif
    else
	let searchre = a:search
    endif
    while search(searchre, flags) > 0 
	let  line2 = line(".")
	while line2 - 1 >= line1 && line2 - 1 > 0 "sanity check
	    let prevline = getline(line2 - 1)
	    if exists("b:simplefold_prefix") && (match(prevline, b:simplefold_prefix) != -1)
		let line2 = line2 - 1
	    else
		break
	    endif
	endwhile
	if (line2 - 1 >= line1)
	    execute ":" . line1 . "," . (line2-1) . "fold"
	    "echo "fold " . line1 . " - " . (line2 - 1)
	    if g:SimpleFold_use_subfolds
		call s:FoldNestableBlocks(first_code_line + 1, line2 - 2, "", "")
	    endif
	    let folded = 1       "at least one fold has been found
	endif
	let line1 = line2     "update marker
	let first_code_line = line2 + 1
	let flags = "W"       "turn off wrapping
    endwhile
    let line2 = line("$")
    if (line2  >= line1 && folded == 1)
	execute ":". line1 . "," . line2 . "fold"
	execute "normal " . line1 . "G"
	" try to find the last top-level fold so that we get the correct range
	" for nested subblocks
	if search(searchre, "W") > 0  
	    let line1 = line(".")    
	endif
	let line1 = line1 + 1
	"echo "last call: " line1 . " - " . line2
	if g:SimpleFold_use_subfolds
	    call s:FoldNestableBlocks(line1, line2, "", "")
	endif
    endif
    call s:FoldNestableBlocks(1, line("$"), b:simplefold_marker_start, 
	\			 b:simplefold_marker_end)
    normal zM
    execute "normal " . origlineno . "G"
endfunction

function! s:FoldNestableBlocks(start, end, start_expr, end_expr)
    call s:SimpleFold_SetupBuffer()
    if a:end - a:start < 1
	return 0
    endif

    if a:start_expr == ""
	if exists("b:simplefold_nestable_start_expr")
	    let start_expr = b:simplefold_nestable_start_expr
	else
	    return
	endif
    else
	let start_expr = a:start_expr
    endif
    if a:end_expr == ""
	if exists("b:simplefold_nestable_end_expr")
	    let end_expr = b:simplefold_nestable_end_expr
	else
	    return
	endif
    else
        let end_expr = a:end_expr
    endif
    "echo "nested " . a:start . " <-> " . a:end
    let origlineno = line(".")
    execute "normal " . (a:start - 1). "G" 
    normal $
    normal zR
    " allow wrapping if a:start was 1 (i.e. we moved to line("$"))
    let flags = (a:start == 1) ? "w" : "W"
    let done_up_to = a:start
    "echo "searching for " . start_expr . " from " . line(".")
    while search(start_expr, flags) > 0
	let flags = "W"
	let first_line = line(".")
	"echo "MATCH " . start_expr . " " . first_line
	if first_line >= a:end || first_line < done_up_to
	    break
	endif
	if searchpair(start_expr, "", end_expr, "W") > 0
	    let last_line = line(".")
	    let done_up_to = last_line
	    if last_line <= a:end
		"echo "nested fold (" . a:start . " - " .  a:end . ") " .
		"     \ first_line . " - " . last_line
		execute ":" . first_line . "," . last_line . "fold"
		if last_line - first_line >= 2 && last_line <= a:end
		    call s:FoldNestableBlocks(first_line + 1, last_line - 1,
		    \                         start_expr, end_expr)
		endif
	    endif
	endif
    endwhile
    execute "normal " . origlineno . "G"
    "echo "RET " . a:start . " - " . a:end " -> " . origlineno
endfunction

function! s:SimpleFold_SetupBuffer()
    if !exists("b:simplefold_expr")
	let b:simplefold_expr = '\v^\s*[#%"0-9]{0,4}\s*\{(\{\{|!!)'
    endif
    if !exists("b:simplefold_marker_start")
	let b:simplefold_marker_start = '\v\{\{\{\{'
    endif
    if !exists("b:simplefold_marker_end")
	let b:simplefold_marker_end = '\v\}\}\}\}'
    endif
endfunction

"{{{~fold commands

if !exists(":Fold")
    command -nargs=1 Fold :call s:Foldsearch(<q-args>)
endif

"{{{ mappings and default options
if !hasmapto("<Plug>SimpleFold_Foldsearch")
    map <unique> <silent> <Leader>f <Plug>SimpleFold_Foldsearch
endif
noremap <unique> <script> <Plug>SimpleFold_Foldsearch <SID>FoldSearch
noremap <SID>FoldSearch :call <SID>Foldsearch("")<cr>

let g:SimpleFold_use_subfolds = 1

"{{{ Fold expressions for different filetypes

" default expression
aug SimpleFold
    au!
    au BufEnter * call s:SimpleFold_SetupBuffer()
    " Ruby support
    au Filetype ruby let b:simplefold_expr = 
	    \'\v(^\s*(def|class|module|attr_reader|attr_accessor|alias_method|' .
                 \   'attr|module_function' . ')\s' . 
            \ '|\v^\s*(public|private|protected)>' .
	    \ '|^\s*\w+attr_(reader|accessor)\s|^\s*[#%"0-9]{0,4}\s*\{\{\{[^{])' .
	    \ '|^\s*[A-Z]\w+\s*\=[^=]|^__END__$'
    au Filetype ruby let b:simplefold_nestable_start_expr = 
		\ '\v^\s*(def>|if>|unless>|while>.*(<do>)?|' . 
                \         'until>.*(<do>)?|case>|for>|begin>)' .
                \ '|^[^#]*.*<do>\s*(\|.*\|)?'
    au Filetype ruby let b:simplefold_nestable_end_expr = 
		\ '\v^\s*end'
    
    au Filetype ruby let b:simplefold_prefix='\v^\s*(#.*)?$'

    " Java support
    au Filetype java let b:simplefold_expr = 
			 \ '\(^\s*\(\(private\|public\|protected\|class\)\s\)\)'
aug END

let &cpo = s:save_cpo
