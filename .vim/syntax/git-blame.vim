if exists("b:current_syntax")
    finish
endif

syn match gitblameSHA1 /^[0-9a-f]\+/ contained
syn match gitblameHistory /^[0-9a-f]\+ ([^)]*)/ contains=gitblameSHA1

hi link gitblameSHA1 Statement
hi link gitblameHistory Comment

let b:current_syntax = "gitblame"
