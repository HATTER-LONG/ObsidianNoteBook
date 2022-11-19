""""""""""""""""""""""""
" 编辑快捷 与 vscode 公用
""""""""""""""""""""""""
imap jj <ESC>
imap jk <ESC>
imap qj <ESC>la
imap qk <ESC>$a
imap 1n <Esc>j^i
imap 1b <Esc>k^i

imap <C-s> <Esc>:w
nmap <C-s> :w

vmap p pgvy
nmap <C-n> :nohl<cr>
nmap L $
vmap L $
nmap H ^
vmap H ^

nmap <C-q> :q<CR>
" 支持在Visual模式下，通过C-y复制到系统剪切板
vmap <C-c> "+y
" 支持在normal模式下，通过C-p粘贴系统剪切板
nmap <C-v> "+p

vmap <C-f> <C-c>/<C-r>*<CR>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map ql <Esc>$a<CR>

