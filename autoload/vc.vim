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
"   Move to the first character, and yank a block to the last
"   character.

let s:type_marks = {
            \ 'char':  ['`[', 'v`]'],
            \ 'line':  ['`[', 'V`]'],
            \ 'block': ['`[', '`]'],
            \ }

let s:debug_verbose = v:false

function! vc#verbose(msg, ...) abort
  if s:debug_verbose
    if type(a:msg) == type([])
      for msg in a:msg
        echomsg printf('[vc%s] %s', (a:0 ? ':'.a:1 : ''), msg)
      endfor
    else
      echomsg printf('[vc%s] %s', (a:0 ? ':'.a:1 : ''), a:msg)
    endif
  endif
endfunction

function! s:write_clipboard(args) abort
    let l:register = a:args['register']
    let l:command = substitute(a:args['command'], '{r}', '"' .. l:register, '')
    let l:save = #{
                \ reginfo: getreginfo(l:register),
                \ }
    call vc#verbose('command: ' .. l:command)
    execute "normal!" l:command
    try
        call writefile([getreginfo(l:register)->string()], s:clipboard, 'b')
    catch
        echomsg 'Failed to write register information into ' .. s:clipboard
    endtry
    call setreg(l:register, l:save.reginfo)
endfunction

function! s:read_clipboard(args) abort
    let l:register = a:args['register']
    let l:command = substitute(a:args['command'], '{r}', '"' .. l:register, '')
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
    call vc#verbose('command: ' .. l:command)
    execute "normal!" l:command
    call writefile([getreginfo(l:register)->string()], s:clipboard, 'b')
    call setreg(l:register, l:save.reginfo)
endfunction

function! vc#write_clipboard(args = {}, type = '')
    if !empty(get(a:args, "type_command", '')) && empty(a:type)
        let &operatorfunc = function('vc#write_clipboard', [a:args])
        return 'g@'
    endif
    if empty(a:type)
        let l:register = get(a:args, 'register', '"')
        let l:command = get(a:args, 'command', '')
        call s:write_clipboard(#{
                    \ command: l:command,
                    \ register: l:register,
                    \ })
    else
        let l:marks = get(s:type_marks, a:type, ['', ''])
        let l:register = get(a:args, 'register', '"')
        let l:command = join([
                    \ l:marks[0],
                    \ get(a:args, 'type_command', ''),
                    \ l:marks[1]
                    \ ], '')
        call s:write_clipboard(#{
                    \ command: l:command,
                    \ register: l:register,
                    \ })
    endif
endfunction

function! vc#read_clipboard(args = {})
    let l:register = get(a:args, 'register', '"')
    let l:command = get(a:args, 'command', '')
    call s:read_clipboard(#{
                \ command: l:command,
                \ register: l:register,
                \ })
endfunction

let &cpo = s:save_cpo
