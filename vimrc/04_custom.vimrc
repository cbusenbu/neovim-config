
"""""""""""""""""""""""""""""""""""""""""""""
"" My poor man's replacement for vim-slime ""
"""""""""""""""""""""""""""""""""""""""""""""
let g:my_active_terminal_job_id = -1

function! LaunchTerminal() range
  silent exe "normal! :vsplit\n"
  silent exe "normal! :terminal\n"
  exe "normal! G\n"
  call SetActiveTerminalJobID()
endfunction

function! LaunchIPython() range
  call LaunchTerminal()
  call jobsend(g:my_active_terminal_job_id, "ipython\r")
endfunction

function! SetActiveTerminalJobID()
  let g:my_active_terminal_job_id = b:terminal_job_id
  echom "Active terminal job ID set to " . g:my_active_terminal_job_id
endfunction

function! SendToTerminal() range
  " Yank the last selection into register "a"
  silent exe 'normal! gv"ay'
  " Send register "a" into the terminal
  call jobsend(g:my_active_terminal_job_id, @a)
  " Pause a moment, then send a carriage return to trigger its evaluation
  sleep 210ms
  call jobsend(g:my_active_terminal_job_id, "\r")
endfunction

function! SendNudgeToTerminal() range
  " Send in a nudge.  Can help trigger IPython evaluation
  call jobsend(g:my_active_terminal_job_id, "\r")
endfunction

"""""""""""""""""""""""""""""""""""""""""""""
""Stuff for code review                    ""
"""""""""""""""""""""""""""""""""""""""""""""
let s:git_status_dictionary = {
            \ "A": "Added",
            \ "B": "Broken",
            \ "C": "Copied",
            \ "D": "Deleted",
            \ "M": "Modified",
            \ "R": "Renamed",
            \ "T": "Changed",
            \ "U": "Unmerged",
            \ "X": "Unknown"
            \ }

function! s:get_diff_files(rev)
    let g:current_commit = a:rev
    let git_path = substitute(system('git rev-parse --show-toplevel'), '\n', '','').'/'
    let file_lit = split(system('git diff --name-status '.a:rev), '\n')
    let list = map(file_lit,
        \ '{"filename":matchstr(v:val, "\\S\\+$"),"text":s:git_status_dictionary[matchstr(v:val, "^\\w")]}'
        \ )
    let new_list = []
    for item in list
        call add(new_list, {"filename": git_path . item['filename'], "text": item['text'] })
    endfor
    call setqflist(new_list)
    copen
endfunction

command! -nargs=1 DiffRev call s:get_diff_files(<q-args>)

" nnoremap <silent> <leader>gm :tab split<CR>:DiffRev develop<CR>
" nnoremap <silent> <leader> gm :call g:DiffNextLoc(g:current_commit)<CR>
" nnoremap <silent> <leader> gM :call g:DiffPrevLoc(g:current_commit)<CR>

" " command! Glistmod only | call g:ListModified() | Gdiff
" " function! g:ListModified()
" " 	let old_makeprg=&makeprg
" " 	let old_errorformat=&errorformat
" " 	let &makeprg = "git ls-files -m"
" " 	let &errorformat="%f"
" " 	lmake
" " 	let &makeprg=old_makeprg
" " 	let &errorformat=old_errorformat
" " endfunction

" function! g:DiffNextLoc(rev)
" 	windo set nodiff
" 	only
" 	lnext
" 	Gdiff a:rev
" endfunction

" function! g:DiffPrevLoc(rev)
" 	windo set nodiff
" 	only
" 	lprevious
" 	Gdiff a:rev
" endfunction
