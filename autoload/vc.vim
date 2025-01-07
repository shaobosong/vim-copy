let s:save_cpo = &cpo
set cpo&vim

if !exists('g:vim_copy_clipboard')
    if has('win32') || has('win64')
        let s:clipboard = expand('$TEMP') . '\vim-copy-clipboard'
    else
        let s:clipboard = '/tmp/vim-copy-clipboard'
    endif
else
    let s:clipboard = expand(g:vim_copy_clipboard)
endif

" Execute command by {motion} type:
" > characterwise
"   Select the characters between '`[' and '`]' (including
"   the character under '`]'), and then yank them.
"   But, why not the following:
"       execute 'normal! `[v`]y'
"   The behavior of 'gv' will be changed. Not recommand!
"
" > linewise
"   Move to the first character, and yank from the current
"   line to the last line. The behavior is similar to 'y'.
"
" > blockwise-visual
"   Bug: '`]' is a incorrect postion in this case using 'g@'.
"        Unexpectedly, the column index is offset by -1 .
let s:motion_commands= #{
            \ char: "`[yv`]",
            \ line: "`[y']",
            \ block: "`[y\<c-v>`]",
            \ }

function! s:write_clipboard(command) abort
    let l:save = #{
                \ reginfo: getreginfo('"'),
                \ }
    execute "normal!" a:command
    try
        call writefile([getreginfo('"')->string()], s:clipboard, 'b')
    catch
        echomsg 'Failed to write register information into ' .. s:clipboard
    endtry
    call setreg('"', l:save.reginfo)
endfunction

function! s:read_clipboard(command) abort
    let l:save = #{
                \ reginfo: getreginfo('"'),
                \ }
    try
        let l:reginfo = readfile(s:clipboard)->join()->eval()
    catch
        let l:reginfo = {}
    finally
        call setreg('"', l:reginfo)
    endtry
    if empty(l:reginfo)
        echomsg 'Nothing in '.. s:clipboard
        call setreg('"', l:save.reginfo)
        return
    endif
    execute "normal!" a:command
    call writefile([getreginfo('"')->string()], s:clipboard, 'b')
    call setreg('"', l:save.reginfo)
endfunction

function! vc#copy(args = {}, motion_type = '')
    if get(a:args, "motion", v:false) == v:true
        let a:args["motion"] = v:false
        let &operatorfunc = function('vc#copy', [a:args])
        return 'g@'
    endif
    if empty(a:motion_type)
        call s:write_clipboard(get(a:args, 'command', ''))
    else
        call s:write_clipboard(get(s:motion_commands, a:motion_type, ''))
    endif
endfunction

function! vc#paste(args = {})
    call s:read_clipboard(get(a:args, 'command', ''))
endfunction

let &cpo = s:save_cpo
