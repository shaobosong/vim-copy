# vim-copy
Copy register information among different vim sessions

## Install
- vim-plug
```vim
Plug 'shaobosong/vim-copy'
```

## Global Variables
- `g:vim_copy_clipboard`: Use this option to specify location of your clipboard. (Default: `$TEMP/vim-copy-clipboard`)

## Usage
### Configuration in vimrc
```vim
let g:vim_copy_clipboard = '~/.vim-copy-clipboard'

nmap gy <Plug>(vim-copy)
nmap gyy <Plug>(vim-copy-line)

xmap gy <Plug>(vim-copy)

nmap gp <Plug>(vim-paste)
nmap gP <Plug>(vim-Paste)

xmap gp <Plug>(vim-paste)
xmap gP <Plug>(vim-Paste)
```
Using like `y` and `p`
### Advanced Configuration
You can delete text and copy it to clipboard by using the following,
```vim
nmap <expr> <silent> <Plug>(vim-delete)
            \ vc#write_clipboard(#{type_command: '{r}d'})

nmap <silent> <Plug>(vim-delete-line)
            \ :<c-u>call vc#write_clipboard(
            \ #{command: v:count1 .. '{r}dd'
            \ })<cr>

xmap <silent> <Plug>(vim-delete)
            \ :<c-u>call vc#write_clipboard(#{
            \ command: join(['`<', '{r}d', visualmode(), '`>'], '')
            \ })<cr>
```
You can write into clipboard from register directly by using the following,
```vim
nmap <silent> <Plug>(vim-save-reg)
            \ :<c-u>call vc#write_clipboard(#{register: 'q'})<cr>
```
With the above feature, you can record a macro and execute it in another
session by using the following,
```vim
nmap <silent> <Plug>(vim-macro-record)
            \ :<c-u>call vc#write_clipboard(#{register: 'q'})<cr>

nmap <silent> <Plug>(vim-macro-execute)
            \ :<c-u>call vc#read_clipboard(#{
            \ command: '@q',
            \ register: 'q'
            \ })<cr>

nmap gm <Plug>(vim-macro-record)
nmap gM <Plug>(vim-macro-execute)
```
Type `qq` to start recording a macro, and type `q` to stop recording a macro.
Then type `gm` to write `q` register information into clipboard and type `gM` to execute a macro.
