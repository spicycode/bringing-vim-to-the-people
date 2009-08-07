if !exists('g:git_command_edit')
    let g:git_command_edit = 'new'
endif

if !exists('g:git_bufhidden')
    let g:git_bufhidden = ''
endif

if !exists('g:git_bin')
    let g:git_bin = 'git'
endif

if !exists('g:git_author_highlight')
    let g:git_author_highlight = { }
endif

if !exists('g:git_highlight_blame')
    let g:git_highlight_blame = 0
endif

nnoremap <Leader>gd :GitDiff<Enter>
nnoremap <Leader>gD :GitDiff --cached<Enter>
nnoremap <Leader>gs :GitStatus<Enter>
nnoremap <Leader>gl :GitLog<Enter>
nnoremap <Leader>ga :GitAdd<Enter>
nnoremap <Leader>gA :GitAdd <cfile><Enter>
nnoremap <Leader>gc :GitCommit<Enter>
nnoremap <Leader>gp :GitPullRebase<Enter>
nnoremap <Leader>gg :GitGrep -e '<C-R>=getreg('/')<Enter>'<Enter>



" Ensure b:git_dir exists.
function! s:GetGitDir()
    if !exists('b:git_dir')
        let b:git_dir = s:SystemGit('rev-parse --git-dir')
        if !v:shell_error
            let b:git_dir = fnamemodify(split(b:git_dir, "\n")[0], ':p') . '/'
        endif
    endif
    " other scripts may have set this variable, but we expect it to end with a /
    if b:git_dir[-1:] != '/'
        let b:git_dir .= '/'
    endif
    return b:git_dir
endfunction

" Returns current git branch.
" Call inside 'statusline' or 'titlestring'.
function! GetGitBranch()
    let git_dir = <SID>GetGitDir()

    if strlen(git_dir) && filereadable(git_dir . 'HEAD')
        let lines = readfile(git_dir . 'HEAD')
        return len(lines) ? matchstr(lines[0], '[^/]*$') : ''
    else
        return ''
    endif
endfunction



" List all branches.
function! ListGitBranches()
    let branches = split(s:SystemGit('branch -a'), '\n')
    if v:shell_error
        return []
    endif

    return map(branches, 'matchstr(v:val, ''^[* ] \zs\S\+\ze'')')
endfunction

" List all local branches.
function! ListGitLocalBranches()
    let branches = split(s:SystemGit('branch'), '\n')
    if v:shell_error
        return []
    endif

    return map(branches, 'matchstr(v:val, ''^[* ] \zs.*'')')
endfunction

" List all git commits.
function! ListGitCommits()
    let commits = split(s:SystemGit('log --pretty=format:%h'))
    if v:shell_error
        return []
    endif

    return commits
endfunction

" List all files, optionally restricted by type
" 'types' should be string containing zero or more of:
"  -c --cached     -d --deleted   -i --ignored   -k --killed
"  -m --modified   -o --others    -u --unmerged
function! ListGitFiles(types)
    let files = split(s:SystemGit('ls-files --exclude-standard ' . a:types))
    if v:shell_error
        return []
    endif

    return files
endfunction


" Show diff.
function! GitDiff(args)
    let git_output = s:SystemGit('diff ' . a:args . ' -- ' . s:Expand('%'))
    if !strlen(git_output)
        echo "No output from git command"
        return
    endif

    call <SID>OpenGitBuffer(git_output)
    setlocal filetype=git-diff
endfunction

function! CompleteGitDiffCmd(arg_lead, cmd_line, cursor_pos)
    let opts = [ ]
    if !strlen(a:arg_lead) || a:arg_lead =~ '^-'
        let opts = [ '-1', '-2', '-3', '-a', '--abbrev', '-B', '-b', '--base',
                    \ '--binary', '-C', '--cached', '--check', '--color',
                    \ '--color-words', '--diff-filter', '--dirstat',
                    \ '--exit-code', '--find-copies-harder', '--full-index',
                    \ '--ignore-all-space', '--ignore-space-change', '-l', '-M',
                    \ '--name-only', '--name-status', '--no-color',
                    \ '--no-renames', '--numstat', '-O', '--ours', '-p',
                    \ '--patch-with-raw', '--patch-with-stat', '--pickaxe-all',
                    \ '--pickaxe-regex', '--quiet', '-R', '--raw', '--relative',
                    \ '-S', '--shortstat', '--stat', '--summary', '--text',
                    \ '--theirs', '-u', '-w', '-z' ]
    endif
    if !strlen(a:arg_lead) || a:arg_lead !~ '^-'
        let commits = ['HEAD'] + ListGitLocalBranches() + ListGitCommits()
        if a:arg_lead =~ '\.\.'
            let pre = matchstr(a:arg_lead, '.*\.\.\ze')
            let commits = map(commits, 'pre . v:val')
        endif
        let opts += commits
    endif
    return filter(opts, 'match(v:val, ''\v'' . a:arg_lead) == 0')
endfunction

" Show Status.
function! GitStatus(args)
    if len(a:args)
        echoe 'GitStatus ignores arguments'
    endif
    let git_output = s:SystemGit('status')
    call <SID>OpenGitBuffer(git_output)
    setlocal filetype=git-status
    nnoremap <buffer> <Enter> :GitAdd <cfile><Enter>:call <SID>RefreshGitStatus()<Enter>
    nnoremap <buffer> d       :GitDiff <cfile><Enter>:call <SID>RefreshGitStatus()<Enter>
    nnoremap <buffer> -       :silent !git reset HEAD -- =expand('<cfile>')<Enter><Enter>:call <SID>RefreshGitStatus()<Enter>
endfunction

function! s:RefreshGitStatus()
    let pos_save = getpos('.')
    GitStatus
    call setpos('.', pos_save)
endfunction

" Show Log.
function! GitLog(args)
    let git_output = s:SystemGit('log ' . a:args . ' -- ' . s:Expand('%'))
    call <SID>OpenGitBuffer(git_output)
    setlocal filetype=git-log
endfunction

" Show Grep.
function! GitGrep(args)
	echo 'git grep ' . a:args
    let git_output = system('git grep -n ' . a:args)
    if !strlen(git_output)
	echo "no output from git command"
	return
    endif

    call <SID>OpenGitGrepQuickFix(git_output)
endfunction


" Add file to index.
function! GitAdd(expr)
    let args = []
    let interactive = 0
    if strlen(a:expr)
        let lookForOptions = 1
        for item in s:SplitCmd(a:expr)
            if lookForOptions && item =~ '^[''"]*-'
                if item =~ '\v^[''"]*-(i|p|-interactive|-patch)'
                    let interactive = 1
                elseif item =~ '^[''"]*--[''"]*$'
                    let lookForOptions = 0
                endif
                let args += [ item ]
            else
                let args += [ s:Expand(item) ]
            endif
        endfor
    else
        let args += [ s:Expand('%') ]
    endif

    if interactive
        execute '!' . g:git_bin . ' add ' . join(args)
    else
        call GitDoCommand('add ' . join(args))
    endif
endfunction

function! CompleteGitAddCmd(arg_lead, cmd_line, cursor_pos)
    let opts = [ ]
    let cmd_lead = a:cmd_line[:a:cursor_pos]
    " stop completing -* flags after '--' and after the first non-flag
    if cmd_lead !~ ' -- ' && cmd_lead !~ '^\v(\S+\s+){2}.*\<\S'
        if !strlen(a:arg_lead) || a:arg_lead =~ '^-'
            let opts += [ '--all', '-A', '--dry-run', '-n', '--force', '-f',
                        \ '--ignore-errors', '', '--interactive', '-i',
                        \ '--patch', '-p', '--refresh', '', '--update', '-u',
                        \ '--verbose', '-v' ]
        endif
    endif
    " if it's not a -* flag, complete filenames
    if !strlen(a:arg_lead) || a:arg_lead !~ '^-'
        let opts += ListGitFiles('-c -d -m -o')
    endif
    return filter(opts, 'match(v:val, ''\v'' . a:arg_lead) == 0')
endfunction

" Commit.
function! GitCommit(args)
    let git_dir = <SID>GetGitDir()

    let args = a:args

    if args !~ '\v\k@<!(-a|--all)>' && s:SystemGit('diff --cached --stat') =~ '^\(\s\|\n\)*$'
        let args .= ' -a'
    endif

    if args !~ '\v\k<!-([mcCF]>|-message=|-reuse-message=|-reedit-message=|-file=)'
        " no need to ask the user for a message, we have one
        execute '!' . g:git_bin . ' commit ' . args
        return
    endif

    " Create COMMIT_EDITMSG file
    let editor_save = $EDITOR
    let $EDITOR = ''
    let git_output = s:SystemGit('commit ' . args)
    let $EDITOR = editor_save

    " signoff already handled, so don't pass through -s/--signoff again
    let args = substitute(args, '\k\@<!\(-s\|--signoff\)\>', '', 'g')

    execute printf('%s %sCOMMIT_EDITMSG', g:git_command_edit, git_dir)
    setlocal filetype=gitcommit bufhidden=wipe
    augroup GitCommit
        autocmd BufRead <buffer> setlocal fileencoding=utf-8
        execute printf("autocmd BufUnload <buffer> call GitDoCommand('commit %s --cleanup=strip -F ' . expand('<afile>')) | autocmd! GitCommit * <buffer>", args)
    augroup END
endfunction
"
" Checkout.
function! GitCheckout(args)
    call GitDoCommand('checkout ' . a:args)
endfunction

function! CompleteGitCheckoutCmd(arg_lead, cmd_line, cursor_pos)
    let opts = [ ]
    if !strlen(a:arg_lead) || a:arg_lead =~ '^-'
        let opts += [ '-b', '-f', '-l', '-m', '--no-track', '-q', '--track', '-t' ]
    endif
    if !strlen(a:arg_lead) || a:arg_lead !~ '^-'
        let opts += ['HEAD'] + ListGitBranches()
    endif
    return filter(opts, 'match(v:val, ''\v'' . a:arg_lead) == 0')
endfunction


" Push.
function! GitPush(args)
"   call GitDoCommand('push ' . a:args)
    " Wanna see progress...
    let args = a:args
    if args =~ '^\s*$'
        let args = 'origin ' . GetGitBranch()
    endif
    execute '!' g:git_bin 'push' args
endfunction

" Pull.
function! GitPull(args)
"   call GitDoCommand('pull ' . a:args)
    " Wanna see progress...
    execute '!' g:git_bin 'pull' a:args
endfunction

" Show commit, tree, blobs.
function! GitCatFile(file)
    let file = s:Expand(a:file)
    let git_output = s:SystemGit('cat-file -p ' . file)
    if !strlen(git_output)
        echo "No output from git command"
        return
    endif

    call <SID>OpenGitBuffer(git_output)
endfunction

" Show revision and author for each line.
function! GitBlame()
    let git_output = s:SystemGit('blame -- ' . expand('%'))
    if !strlen(git_output)
        echo "No output from git command"
        return
    endif

    setlocal noscrollbind

    " :/
    let git_command_edit_save = g:git_command_edit
    let g:git_command_edit = 'leftabove vnew'
    call <SID>OpenGitBuffer(git_output)
    let g:git_command_edit = git_command_edit_save

    setlocal modifiable
    silent %s/\d\d\d\d\zs \+\d\+).*//
    vertical resize 20
    setlocal nomodifiable
    setlocal nowrap scrollbind

    if g:git_highlight_blame
        call s:DoHighlightGitBlame()
    endif

    wincmd p
    setlocal nowrap scrollbind

    syncbind
endfunction

" Experimental
function! s:DoHighlightGitBlame()
    for l in range(1, line('$'))
        let line = getline(l)
        let [commit, author] = matchlist(line, '\(\x\+\) (\(.\{-}\)\s* \d\d\d\d-\d\d-\d\d')[1:2]
        call s:LoadSyntaxRuleFor({ 'author': author })
    endfor
endfunction

function! s:LoadSyntaxRuleFor(params)
    let author = a:params.author
    let name = 'gitBlameAuthor_' . substitute(author, '\s', '_', 'g')
    if (!hlID(name))
        if has_key(g:git_author_highlight, author)
            execute 'highlight' name g:git_author_highlight[author]
        else
            let [n1, n2] = [0, 1]
            for c in split(author, '\zs')
                let n1 = (n1 + char2nr(c))     % 8
                let n2 = (n2 + char2nr(c) * 3) % 8
            endfor
            if n1 == n2
                let n1 = (n2 + 1) % 8
            endif
            execute 'highlight' name printf('ctermfg=%d ctermbg=%d', n1, n2)
        endif
        execute 'syntax match' name '"\V\^\x\+ (' . escape(author, '\') . '\.\*"'
    endif
endfunction

" git command wrapper
function! Git(args)
    let words = split(a:args)
    let name = 'Git' . substitute(words[0], '^.', '\u&', '')
    if exists('*' . name)
        let Fn = function(name)
        return Fn(join(words[1:]))
    endif

    " fallback to simple handler
    let git_output = s:SystemGit(a:args)
    if !strlen(git_output)
        echo "No output from git command"
        return
    endif

    call <SID>OpenGitBuffer(git_output)
    execute printf('setlocal filetype=git-%s', words[0])
endfunction

function! CompleteGitCmd(arg_lead, cmd_line, cursor_pos)
    " don't try to handle completing in the middle for now
    if a:arg_lead =~ '\s'
        return [ ]
    endif

    let words = split(substitute(a:cmd_line, '^ \+', '', ''), '\W\+')

    if words[0] != 'Git'
        return [ ]
    endif

    " complete the first word
    if len(words) < 2 || words[1] == a:arg_lead
        let commands = split(system("COLUMNS=1 git help -a | awk '/^  / { split($1,x,\" \") ; print $1 }'"))
        return filter(commands, 'match(v:val, ''\v'' . a:arg_lead) == 0')
    endif

    let name = 'CompleteGit' . substitute(words[1], '^.', '\u&', '') . 'Cmd'
    if exists('*' . name)
        let Fn = function(name)
        return Fn(a:arg_lead, a:cmd_line, a:cursor_pos)
    endif

    return [ ]
endfunction



function! GitDoCommand(args)
    let git_output = s:SystemGit(a:args)
    let git_output = substitute(git_output, '\n*$', '', '')
    if v:shell_error
        echohl Error
        echo git_output
        echohl None
    else
        echo git_output
    endif
endfunction

function! s:SystemGit(args)
    return system(g:git_bin . ' ' . a:args . '< /dev/null')
endfunction

" Show vimdiff for merge. (experimental)
function! GitVimDiffMerge()
    let file = s:Expand('%')
    let filetype = &filetype
    let t:git_vimdiff_original_bufnr = bufnr('%')
    let t:git_vimdiff_buffers = []

    topleft new
    setlocal buftype=nofile
    file `=':2:' . file`
    call add(t:git_vimdiff_buffers, bufnr('%'))
    execute 'silent read!git show :2:' . file
    0d
    diffthis
    let &filetype = filetype

    rightbelow vnew
    setlocal buftype=nofile
    file `=':3:' . file`
    call add(t:git_vimdiff_buffers, bufnr('%'))
    execute 'silent read!git show :3:' . file
    0d
    diffthis
    let &filetype = filetype
endfunction

function! GitVimDiffMergeDone()
    if exists('t:git_vimdiff_original_bufnr') && exists('t:git_vimdiff_buffers')
        if getbufline(t:git_vimdiff_buffers[0], 1, '$') == getbufline(t:git_vimdiff_buffers[1], 1, '$')
            execute 'sbuffer ' . t:git_vimdiff_original_bufnr
            0put=getbufline(t:git_vimdiff_buffers[0], 1, '$')
            normal! jdG
            update
            execute 'bdelete ' . t:git_vimdiff_buffers[0]
            execute 'bdelete ' . t:git_vimdiff_buffers[1]
            close
        else
            echohl Error
            echo 'There still remains conflict'
            echohl None
        endif
    endif
endfunction

function! s:OpenGitBuffer(content)
    if exists('b:is_git_msg_buffer') && b:is_git_msg_buffer
        enew!
    else
        execute g:git_command_edit
    endif

    setlocal buftype=nofile readonly modifiable
    execute 'setlocal bufhidden=' . g:git_bufhidden

    silent put=a:content
    keepjumps 0d
    setlocal nomodifiable

    let b:is_git_msg_buffer = 1
endfunction

function! s:OpenGitGrepQuickFix(content)
    let list = []

    for l:line in split(a:content, "\n")
        let l:parts = matchlist(l:line, '\([^:]\+\):\(\d\+\):\(.*\)')
        call add(list, { 'filename': l:parts[1], 'lnum': l:parts[2], 'text': l:parts[3] })
    endfor

    call setqflist(list)
    crewind
    copen
endfunction

function! s:Expand(expr)
    if has('win32')
        return substitute(expand(a:expr), '\', '/', 'g')
    else
        return expand(a:expr)
    endif
endfunction

" Takes a string containing a shell command and splits it into a list containing
" an approximation of the way the line would be parsed by a shell.
function! s:SplitCmd(cmd)
    let l:split_cmd = []
    let cmd = a:cmd
    let iStart = 0
    while 1
        let t = match(cmd, '\S', iStart)
        if t < iStart
            break
        endif
        let iStart = t

        let iSpace = match(cmd, '\v(\s|$)', iStart)
        if iSpace < iStart
            break
        endif

        let iQuote1 = match(cmd, '\(^["'']\|[^\\]\@<=["'']\)', iStart)
        if iQuote1 < iStart
            let iEnd = iSpace - 1
        else
            let q = cmd[iQuote1]
            let iQuote2 = match(cmd, '[^\\]\@<=[' . q . ']', iQuote1 + 1)
            if iQuote2 < iQuote1
                throw 'No matching ' . q . ' quote'
            endif
            let iEnd = iQuote2
        endif

        let l:split_cmd += [ cmd[iStart : iEnd] ]
        
        let iStart = iEnd + 1
    endwhile

    return l:split_cmd
endfunction

command! -nargs=1 -complete=customlist,CompleteGitCheckoutCmd GitCheckout         call GitCheckout(<q-args>)
command! -nargs=* -complete=customlist,CompleteGitDiffCmd     GitDiff             call GitDiff(<q-args>)
command! -nargs=*                                             GitStatus           call GitStatus(<q-args>)
command! -nargs=? -complete=customlist,CompleteGitAddCmd      GitAdd              call GitAdd(<f-args>)
command! -nargs=* GitLog              call GitLog(<q-args>)
command! -nargs=* GitCommit           call GitCommit(<q-args>)
command! -nargs=1 GitCatFile          call GitCatFile(<q-args>)
command!          GitBlame            call GitBlame()
command!          GitVimDiffMerge     call GitVimDiffMerge()
command!          GitVimDiffMergeDone call GitVimDiffMergeDone()
command! -nargs=* GitPull             call GitPull(<q-args>)
command!          GitPullRebase       call GitPull('--rebase')
command! -nargs=* GitPush             call GitPush(<q-args>)
command! -nargs=* GitGrep             call GitGrep(<q-args>)

command! -nargs=+ -complete=customlist,CompleteGitCmd         Git                 call Git(<q-args>)
cabbrev git <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Git' : 'git')<CR>

" vim: set et sw=4 ts=4:
