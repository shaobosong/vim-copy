if exists('g:loaded_vim_copy')
    finish
endif
let g:loaded_vim_copy = 1

nmap <expr> <silent> <Plug>(vim-copy)
            \ vc#write_clipboard(#{
            \ motion_command: 'y',
            \ motion: v:true,
            \ })

nmap <expr> <silent> <Plug>(vim-copy-line)
            \ vc#directive(#{
            \ func: function(
            \     "vc#write_clipboard",
            \     [#{command: v:count1 .. 'yy'}]
            \ ),
            \ })

xmap <expr> <silent> <Plug>(vim-copy)
            \ vc#directive(#{
            \ func: function("vc#write_clipboard", [#{command: 'gvy'}]),
            \ })

nmap <expr> <silent> <Plug>(vim-paste)
            \ vc#directive(#{
            \ func: function("vc#read_clipboard", [#{command: 'p'}]),
            \ })

nmap <expr> <silent> <Plug>(vim-Paste)
            \ vc#directive(#{
            \ func: function("vc#read_clipboard", [#{command: 'P'}]),
            \ })

xmap <expr> <silent> <Plug>(vim-paste)
            \ vc#directive(#{
            \ func: function("vc#read_clipboard", [#{command: 'gvp'}]),
            \ })

xmap <expr> <silent> <Plug>(vim-Paste)
            \ vc#directive(#{
            \ func: function("vc#read_clipboard", [#{command: 'gvP'}]),
            \ })

nmap gy <Plug>(vim-copy)
nmap gyy <Plug>(vim-copy-line)

nmap gp <Plug>(vim-paste)
nmap gP <Plug>(vim-Paste)

xmap gy <Plug>(vim-copy)

xmap gp <Plug>(vim-paste)
xmap gP <Plug>(vim-Paste)
