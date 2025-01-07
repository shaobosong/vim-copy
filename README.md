# vim-copy
Copy text among different vim sessions

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
nmap gy <Plug>(vim-copy-normal)
nmap gyy <Plug>(vim-copy-line-normal)

xmap gy <Plug>(vim-copy-visual)

nmap gp <Plug>(vim-paste)
nmap gP <Plug>(vim-Paste)

xmap gp <Plug>(vim-paste)
xmap gP <Plug>(vim-Paste)
```
Using like `y` and `p`
