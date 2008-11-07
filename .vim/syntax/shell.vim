" Vim syntax file
" Language:         shell results
" Maintainer:       Chad Humphries
" Latest Revision:  2008-10-09

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syntax region   ShellTextSpecFileInfo start="test\/" end="\%(\d\+\)" oneline

syntax region   ShellTestResultsTime display oneline    start='^Finished in' end='seconds\.$'

syntax region   ShellTestSpecName    display oneline    start='^test_spec' end='$'

syntax match    ShellTestFailure "\%(Failure\)"

syntax match    ShellTestSuccess "\%(Success\)"

syntax match    ShellTextExpectationDivider "\%(expected \%(but was\|to be\)\)"

syntax region   ShellTextExpectation start="^.*expected" end="$" oneline contains=ShellTextExpectationDivider


let b:current_syntax = "shell"

let &cpo = s:cpo_save
unlet s:cpo_save
