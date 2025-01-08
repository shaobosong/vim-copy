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
"
"   let s:motion_marks = #{
"               \ char:  ["`[", 'v`]'],
"               \ line:  ["`[", "']"],
"               \ block: ["`[", '\<c-v>`]'],
"               \ }

let s:motion_marks = #{
            \ char:  ["`[", 'v`]'],
            \ line:  ["`[", 'V`]'],
            \ block: ["`[", '\<c-v>`]'],
            \ }

function! s:write_clipboard(args) abort
    let l:command = get(a:args, 'command', '')
    let l:register = get(a:args, 'register', '"')
    let l:save = #{
                \ reginfo: getreginfo(l:register),
                \ }
    execute "normal!" l:command
    try
        call writefile([getreginfo(l:register)->string()], s:clipboard, 'b')
    catch
        echomsg 'Failed to write register information into ' .. s:clipboard
    endtry
    call setreg(l:register, l:save.reginfo)
endfunction

function! s:read_clipboard(args) abort
    let l:command = get(a:args, 'command', '')
    let l:register = get(a:args, 'register', '"')
    let l:save = #{
                \ reginfo: getreginfo(l:register),
                \ }
    try
        let l:reginfo = readfile(s:clipboard)->join()->eval()
    catch
        let l:reginfo = {}
    finally
        call setreg(l:register, l:reginfo)
    endtry
    if empty(l:reginfo)
        echomsg 'Nothing in '.. s:clipboard
        call setreg(l:register, l:save.reginfo)
        return
    endif
    execute "normal!" l:command
    call writefile([getreginfo(l:register)->string()], s:clipboard, 'b')
    call setreg(l:register, l:save.reginfo)
endfunction

function! vc#write_clipboard(args = {}, motion = '')
    if get(a:args, "motion", v:false) == v:true
        let a:args["motion"] = v:false
        let &operatorfunc = function('vc#write_clipboard', [a:args])
        return 'g@'
    endif
    if empty(a:motion)
        let l:register = get(a:args, 'register', '"')
        let l:command = join([
                    \ '"' .. l:register,
                    \ get(a:args, 'command', '')
                    \ ], '')
        call s:write_clipboard(#{
                    \ command: l:command,
                    \ register: l:register,
                    \ })
    else
        let l:marks = get(s:motion_marks, a:motion, [])
        let l:register = get(a:args, 'register', '"')
        let l:command = join([
                    \ l:marks[0],
                    \ '"' .. l:register,
                    \ get(a:args, 'motion_command', 'v'),
                    \ l:marks[1]
                    \ ], '')
        call s:write_clipboard(#{
                    \ command: l:command,
                    \ register: l:register,
                    \ })
    endif
endfunction

function! vc#read_clipboard(args = {})
    call s:read_clipboard(a:args)
endfunction

function! vc#error(msg)
    echomsg a:msg
endfunction

function! vc#directive(args = {})
    let Fr = get(a:args, "func", function('vc#error', ['No function']))
    return join([
                \ ":\<c-u>call",
                \ l:Fr->get("name"),
                \ "(",
                \ l:Fr->get("args")->join(','),
                \ ")\<cr>",
                \ ], ' ')
endfunction

let &cpo = s:save_cpo
