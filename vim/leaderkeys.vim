" set leader to space
let mapleader="\<Space>"

" file exploring
nmap <Leader>ff :Explore<CR>
nmap <Leader>fn :Sexplore<CR>
nmap <Leader>ft :Texplore<CR>

" buffer switching
nmap <Leader>ww <C-w>w
nmap <Leader>wh <C-w>h
nmap <Leader>wj <C-w>j
nmap <Leader>wk <C-w>k
nmap <Leader>wl <C-w>l

" building software
nmap <Leader>cc :w<CR>:make<CR>

" CtrlP
nmap <Leader>bb :CtrlPBuffer<CR>
nmap <Leader>fp :CtrlP<CR>

