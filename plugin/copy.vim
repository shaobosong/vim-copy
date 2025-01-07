if exists('g:loaded_vim_copy')
    finish
endif
let g:loaded_vim_copy = 1

nmap <expr> <silent> <Plug>(vim-copy-normal) vc#copy(#{motion: v:true})
nmap <expr> <silent> <Plug>(vim-copy-line-normal)
            \ ":\<c-u>call vc#copy(#{command: v:count1 .. 'yy'})\<cr>"
xmap <expr> <silent> <Plug>(vim-copy-visual)
            \ ":\<c-u>call vc#copy(#{command: 'gvy'})\<cr>"

nmap <expr> <silent> <Plug>(vim-paste)
            \ ":\<c-u>call vc#paste(#{command: 'p'})\<cr>"
nmap <expr> <silent> <Plug>(vim-Paste)
            \ ":\<c-u>call vc#paste(#{command: 'P'})\<cr>"

xmap <expr> <silent> <Plug>(vim-paste)
            \ ":\<c-u>call vc#paste(#{command: 'gvp'})\<cr>"
xmap <expr> <silent> <Plug>(vim-Paste)
            \ ":\<c-u>call vc#paste(#{command: 'gvP'})\<cr>"

nmap gy <Plug>(vim-copy-normal)
nmap gyy <Plug>(vim-copy-line-normal)

nmap gyp <Plug>(vim-paste)
nmap gyP <Plug>(vim-Paste)

xmap gy <Plug>(vim-copy-visual)

xmap gp <Plug>(vim-paste)
xmap gP <Plug>(vim-Paste)
