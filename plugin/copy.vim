if exists('g:loaded_vim_copy')
    finish
endif
let g:loaded_vim_copy = 1

nmap <expr> <silent> <Plug>(vim-copy)
            \ vc#write_clipboard(#{type_command: '{r}y'})

nmap <silent> <Plug>(vim-copy-line)
            \ :<c-u>call vc#write_clipboard(#{command: v:count1 .. '{r}yy'})<cr>

xmap <silent> <Plug>(vim-copy)
            \ :<c-u>call vc#write_clipboard(#{
            \ command: join(['`<', '{r}y', visualmode(), '`>'], '')
            \ })<cr>

nmap <silent> <Plug>(vim-paste)
            \ :<c-u>call vc#read_clipboard(#{command: '{r}p'})<cr>

nmap <silent> <Plug>(vim-Paste)
            \ :<c-u>call vc#read_clipboard(#{command: '{r}P'})<cr>

xmap <silent> <Plug>(vim-paste)
            \ :<c-u>call vc#read_clipboard(#{command: 'gv{r}p'})<cr>

xmap <silent> <Plug>(vim-Paste)
            \ :<c-u>call vc#read_clipboard(#{command: 'gv{r}P'})<cr>

nmap gy <Plug>(vim-copy)
nmap gyy <Plug>(vim-copy-line)

nmap gp <Plug>(vim-paste)
nmap gP <Plug>(vim-Paste)

xmap gy <Plug>(vim-copy)

xmap gp <Plug>(vim-paste)
xmap gP <Plug>(vim-Paste)
