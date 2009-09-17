" Vim syntax file
" Language:	HTML (version 5)
" Maintainer:	Rodrigo Machado <rcmachado@gmail.com>
" URL:		http://rm.blog.br/vim/syntax/html.vim
" Last Change:  2009 Aug 19
" License:      Public domain
"               (but let me know if you like :) )
"
" Note: This file just adds the new tags from HTML 5
"       and don't replace default html.vim syntax file

" HTML 5 tags
syn keyword htmlTagName contained article aside audio bb canvas command datagrid
syn keyword htmlTagName contained datalist details dialog embed figure footer
syn keyword htmlTagName contained header hgroup keygen mark meter nav output
syn keyword htmlTagName contained progress time ruby rt rp section time video

" HTML 5 arguments
syn keyword htmlArg contained contenteditable contextmenu draggable hidden item
syn keyword htmlArg contained itemprop list subject spellcheck
" o '-' (traÃ§o) causa problemas pq jÃ¡ existe um atributo 'data' definido
syn match   htmlArg "\<\(data-[\-a-zA-Z0-9_]\+\)=" contained
