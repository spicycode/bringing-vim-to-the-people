" Initialize execute file list.
  let g:VimShell_ExecuteFileList = {}
  let g:VimShell_ExecuteFileList['rb'] = 'ruby'
  let g:VimShell_ExecuteFileList['pl'] = 'perl'
  let g:VimShell_ExecuteFileList['py'] = 'python'
 
  let g:VimShell_EnableInteractive = 1
  let g:VimShell_EnableSmartCase = 1
  let g:VimShell_EnableAutoLs = 1
 
" Display user name on Linux.
  " let g:VimShell_Prompt = $USER.$PWD."% "

" <C-Space>: switch to vimshell.
  nmap <C-@>  <Plug>(vimshell_switch)
  imap <C-@>  <Plug>(vimshell_switch)

" !: vimshell interactive execute.
  nnoremap !  :<C-u>VimShellInteractive<Space>
  
" &: vimshell background execute.
  nnoremap &  :<C-u>VimShellExecute<Space>