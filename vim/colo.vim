" Default colorscheme
au BufEnter * colorscheme default
au BufEnter * hi ColorColumn ctermbg=red
au BufEnter * hi CursorColumn ctermbg=black

" Colorschemes based on file extensions
autocmd BufEnter *.php colorscheme jellybeans
